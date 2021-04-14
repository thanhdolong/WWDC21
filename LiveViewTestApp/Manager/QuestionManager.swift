//
//  QuestionManager.swift
//  LiveViewTestApp
//
//  Created by Thành Đỗ Long on 07.04.2021.
//

import Combine
import SwiftUI

final class QuestionManager {
    private var questionsIterator: IndexingIterator<[QuestionWithIndex]>?
    private(set) var isTimerRunning = false
    
    let configuration: QuizConfiguration
    let quizSession: QuizSession
    let timer: Publishers.Autoconnect<Timer.TimerPublisher> = {
        Timer.publish(every: timerInterval, on: .main, in: .common).autoconnect()
    }()
    
    private var replacementQuestion: Question?
    private var cancellable = Set<AnyCancellable>()
    
    static let timerInterval: Double = 0.5
    
    init(configuration: QuizConfiguration,
         session: QuizSession = .init()) {
        self.configuration = configuration
        self.quizSession = session
        
        timer
            .sink(receiveValue: { [weak self] _ in
                guard let self = self,
                      self.isTimerRunning else { return }
                
                self.revalidateTimer()
            })
            .store(in: &cancellable)
        
        quizSession
            .quizState
            .map({ $0 == .play || $0 == .prepareQuestion })
            .assign(to: \.isTimerRunning, on: self)
            .store(in: &cancellable)
    }
    
    /// Start the quiz
    func play() {
        let questions = Array(configuration.questions.dropLast()
                                .shuffled()
                                .enumerated())
        
        replacementQuestion = configuration.questions.last
        
        let lives = [Life].init(repeating: .available, count: configuration.lives)
        let lifelines = LifelineType.allCases.compactMap { Lifeline(type: $0) }
        
        questionsIterator = questions.makeIterator()
        
        quizSession.lives.send(lives)
        quizSession.responses.send([:])
        quizSession.questions.send(questions)
        quizSession.lifelines.send(lifelines)
        prepareQuestion()
    }
    
    /// Pause the quiz
    func pause() {
        quizSession.quizState.send(.pause)
    }
    
    /// Continue with the game
    func continueGame() {
        quizSession.quizState.send(.prepareQuestion)
    }
    
    /// Show correct answer
    func showAnswer() {
        quizSession.quizState.send(.showAnswer)
    }
    
    /// Show correct answer
    func quitGame() {
        quizSession.prepareTimeRemaining.send(0)
        quizSession.quizState.send(.end)
    }
    
    /// Use lifeline
    func use(lifeline lifelineType: LifelineType) {
        let lifelines = quizSession.lifelines.value.map { lifeline -> Lifeline in
            guard lifeline.id == lifelineType else { return lifeline }
            return Lifeline(type: lifelineType, isUsed: true)
        }
        
        switch lifelineType {
        case .fiftyFifty:
            guard let question = quizSession.currentQuestion.value?.element else {
                return
            }
            
            let correctAnswer = question.responses.compactMap { response -> String? in
                guard response != question.correctResponse else { return nil }
                return response
            }
            .shuffled()
            .prefix(2)
            
            quizSession.disabledResponses.send(Array(correctAnswer))
        case .newQuestion:
            if let replacementQuestion = replacementQuestion,
               let currentOffset = quizSession.currentQuestion.value?.offset {
                quizSession.disabledResponses.send([])
                quizSession.currentQuestion.send((offset: currentOffset, element: replacementQuestion))
                quizSession.timeRemaining.send(configuration.timeForQuestion)
            }
        case .audience:
            guard let currentQuestion = quizSession.currentQuestion.value?.element else {
                return
            }
            
            let result = currentQuestion
                .responses
                .compactMap({ response -> (String, CGFloat) in
                    switch response == currentQuestion.correctResponse {
                    case true:
                        return (response, .random(in: 0.5...1))
                    case false:
                        return (response, .random(in: 0.1...0.65))
                    }
            })
            
            quizSession.percentageResponses.send(result)
        }
        
        quizSession.lifelines.send(lifelines)
    }
    
    /// Prepare new question and run cooldown
    func prepareQuestion() {
        guard let currentQuestion = questionsIterator?.next(),
              quizSession.lives.value.contains(.available) else {
            quizSession.quizState.send(.end)
            return
        }
        
        quizSession.prepareTimeRemaining.send(configuration.prepareTime)
        quizSession.percentageResponses.send([])
        quizSession.disabledResponses.send([])
        quizSession.currentQuestion.send(currentQuestion)
        quizSession.quizState.send(.prepareQuestion)
    }
    
    /// Load the next question
    func startQuestion() {
        quizSession.timeRemaining.send(configuration.timeForQuestion)
        quizSession.quizState.send(.play)
    }
    
    /// Submit a response to a question
    func submit(response: String, for question: QuestionWithIndex) {
        let isCorrect = question.element.correctResponse == response
        submit(question: question, as: isCorrect)
    }
    
    private func recalculateLives(isQuestionCorrect: Bool) {
        guard isQuestionCorrect == false else { return }
        var lives = quizSession.lives.value
        
        if let availableLifeIndex = lives.firstIndex(where: { $0 == .available }) {
            lives[availableLifeIndex] = .unavailable
        }
        
        quizSession.lives.send(lives)
    }
    
    private func recalculateTotalPoints(isQuestionCorrect: Bool) {
        guard isQuestionCorrect else { return }
        let totalPoints = quizSession.totalPoints.value + quizSession.points.value
        quizSession.totalPoints.send(totalPoints)
    }
    
    private func revalidateTimer() {
        switch quizSession.quizState.value {
        case .play:
            decreaseQuestionTimer()
        case .prepareQuestion:
            decreasePrepareTimer()
        default:
            return
        }
    }
    
    
    private func decreaseQuestionTimer() {
        guard let currentQuestion = quizSession.currentQuestion.value else { return }
        let timeRemaining = quizSession.timeRemaining.value - QuestionManager.timerInterval
        
        quizSession.timeRemaining.send(timeRemaining)
        calculatePoints(for: currentQuestion, timeRemaining: timeRemaining)
        
        if timeRemaining < 0 {
            submit(question: currentQuestion, as: false)
            prepareQuestion()
        }
    }
    
    private func decreasePrepareTimer() {
        let prepareTimeRemaining = quizSession.prepareTimeRemaining.value - QuestionManager.timerInterval
        quizSession.prepareTimeRemaining.send(prepareTimeRemaining)
        
        if prepareTimeRemaining < 0 {
            startQuestion()
        }
    }
    
    private func calculatePoints(for question: QuestionWithIndex, timeRemaining: Double) {
        let multiplier = configuration.points
            .first(where: { $0.key.contains(timeRemaining) })?.value ?? 0
        
        let points = multiplier * Double(question.offset + 1) * 10
        
        quizSession.points.send(Int(points))
    }
    
    private func submit(question: QuestionWithIndex, as isCorrect: Bool) {
        var responses = quizSession.responses.value
        responses[question.offset] = isCorrect
        quizSession.responses.send(responses)
        recalculateTotalPoints(isQuestionCorrect: isCorrect)
        recalculateLives(isQuestionCorrect: isCorrect)
    }
}

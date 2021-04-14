//
//  QuizSession.swift
//  BookCore
//
//  Created by Thành Đỗ Long on 09.04.2021.
//

import Combine
import SwiftUI

struct QuizSession {
    typealias Response = String
    typealias ResponseIndex = Int
    
    enum State {
        case play
        case pause
        case prepareQuestion
        case showAnswer
        case end
    }
    
    let timeRemaining: CurrentValueSubject<Double, Never>
    let prepareTimeRemaining: CurrentValueSubject<Double, Never>
    let questions: CurrentValueSubject<[QuestionWithIndex], Never>
    let currentQuestion: CurrentValueSubject<QuestionWithIndex?, Never>
    let responses: CurrentValueSubject<[ResponseIndex:Bool], Never>
    let lifelines: CurrentValueSubject<[Lifeline], Never>
    let quizState: CurrentValueSubject<State, Never>
    let points: CurrentValueSubject<Int, Never>
    let totalPoints: CurrentValueSubject<Int, Never>
    let lives: CurrentValueSubject<[Life], Never>
    
    let disabledResponses = PassthroughSubject<[Response], Never>()
    let percentageResponses = PassthroughSubject<[(Response, CGFloat)], Never>()
    
    init(timeRemaining: Double = 0,
         prepareTimeRemaining: Double = 0,
         questions: [QuestionWithIndex] = [],
         currentQuestion: QuestionWithIndex? = nil,
         responses: [Int:Bool] = [:],
         lifelines: [Lifeline] = [],
         quizState: State = .prepareQuestion,
         points: Int = 0,
         totalPoints: Int = 0,
         lives: [Life] = []) {
        self.timeRemaining = .init(timeRemaining)
        self.prepareTimeRemaining = .init(prepareTimeRemaining)
        self.questions = .init(questions)
        self.currentQuestion = .init(currentQuestion)
        self.responses = .init(responses)
        self.lifelines = .init(lifelines)
        self.quizState = .init(quizState)
        self.points = .init(points)
        self.totalPoints = .init(totalPoints)
        self.lives = .init(lives)
    }
}

//
//  QuestionView.swift
//  LiveViewTestApp
//
//  Created by Thành Đỗ Long on 07.04.2021.
//

import SwiftUI
import Combine

struct GameOfThronesView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader(content: { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        VStack(alignment: .center, spacing: 12) {
                            ForEach(viewModel.questions, id: \.offset) { question  in
                                QuestionCapsuleView(animationDuration: viewModel.waitingTime(),
                                                    questionIndex: .constant(question.offset),
                                                    response: .constant(viewModel.response(for: question.offset)),
                                                    currentQuestionIndex: $viewModel.currentQuestionIndex,
                                                    loadingValue: $viewModel.prepareTimeRemaining)
                            }
                            .onChange(of: viewModel.quizState, perform: { quizState in
                                switch quizState {
                                case .end:
                                    withAnimation(.spring()) {
                                        proxy.scrollTo(viewModel.currentQuestion?.offset, anchor: .bottom)
                                    }
                                default:
                                    withAnimation(.spring()) {
                                        proxy.scrollTo(viewModel.currentQuestion?.offset, anchor: .top)
                                    }
                                }
                            })
                        }
                    }
                }
                .frame(height: viewModel.calucaleteHeight(geometry.size.height),
                       alignment: .center)
            })
            .padding(.horizontal, 32)
            .padding(.top, 200)
            .padding(.bottom, 200)
            
            if let currentQuestion = viewModel.currentQuestion {
                QuizView(viewModel: .init(question: currentQuestion,
                                          quizState: viewModel.quizState,
                                          gameManager: viewModel.gameManager))
            }
            
            if viewModel.quizState == .pause {
                GeometryReader(content: { geometry in
                    ZStack {
                        Color.gray
                            .opacity(0.8)
                        VStack() {
                            Text("Do you want to end the game?")
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            
                            HStack {
                                SolidButton(action: { viewModel.quitGame() },
                                            Text("End Game")
                                )
                                .opacity(0.8)
                                
                                SolidButton(action: { viewModel.continueGame() },
                                            Text("Continue")
                                )
                            }
                        }
                        .padding()
                        .modifier(CardViewModifier())
                        .frame(width: geometry.size.width * 0.6)
                        
                    }
                    .animation(.easeInOut)
                })
            }
        }
        .ignoresSafeArea()
        .background(Appearance.primaryColor)
    }
}

extension GameOfThronesView {
    class ViewModel: ObservableObject {
        @Published var questions: [QuestionWithIndex] = []
        @Published var responses: [Int: Bool] = [:]
        @Published var prepareTimeRemaining: Double = 0
        @Published var getReadyCoutdown: Int = 1
        @Published var quizState: QuizSession.State = .pause
        @Published var currentQuestion: QuestionWithIndex?
        @Published var currentQuestionIndex: Int?
        
        let height: CGFloat
        let gameManager: QuestionManager
        
        private var cancellable = Set<AnyCancellable>()
        
        init(height: CGFloat, gameManager: QuestionManager) {
            self.height = height
            self.gameManager = gameManager
            
            setupActions()
            gameManager.play()
        }
        
        func continueGame() {
            gameManager.continueGame()
        }
        
        func quitGame() {
            gameManager.quitGame()
        }
        
        func response(for questionOffset: Int) -> Bool? {
            responses.first(where: {$0.key == questionOffset} )?.value
        }
        
        func calucaleteHeight(_ height: CGFloat) -> CGFloat {
            let visibleRows = height / 65
            return visibleRows.rounded(.down) * 65
        }
        
        func waitingTime() -> Double {
            gameManager.configuration.prepareTime
        }
        
        private func setupActions() {
            let quizSession = gameManager.quizSession
            
            quizSession.prepareTimeRemaining
                .receive(on: DispatchQueue.main)
                .assign(to: \.prepareTimeRemaining, on: self)
                .store(in: &cancellable)
            
            quizSession.currentQuestion
                .receive(on: DispatchQueue.main)
                .assign(to: \.currentQuestion, on: self)
                .store(in: &cancellable)
            
            quizSession.currentQuestion
                .receive(on: DispatchQueue.main)
                .compactMap({ $0?.offset })
                .assign(to: \.currentQuestionIndex, on: self)
                .store(in: &cancellable)
            
            quizSession.questions
                .receive(on: DispatchQueue.main)
                .assign(to: \.questions, on: self)
                .store(in: &cancellable)
            
            quizSession.responses
                .receive(on: DispatchQueue.main)
                .assign(to: \.responses, on: self)
                .store(in: &cancellable)
            
            quizSession.quizState
                .receive(on: DispatchQueue.main)
                .assign(to: \.quizState, on: self)
                .store(in: &cancellable)
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let configuration = QuizConfiguration(questions: Question.appleStub(),
                                              points: [
                                                7.5..<10: 1,
                                                5..<7.5: 0.8,
                                                0..<5: 0.6
                                              ],
                                              timeForQuestion: 10,
                                              prepareTime: 3)
        
        let viewModel = GameOfThronesView.ViewModel(height: 500,
                                                    gameManager: .init(configuration: configuration))
        return GameOfThronesView(viewModel: viewModel)
            .previewDevice("iPad Pro (9.7-inch)")
            .edgesIgnoringSafeArea(.all)
    }
}

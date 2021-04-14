
//  QuizView.swift
//  LiveViewTestApp
//
//  Created by Thành Đỗ Long on 11.04.2021.
//

import SwiftUI
import Combine

struct QuizView: View {
    @StateObject var viewModel: ViewModel
    @State private var startAnimation: Bool = false
    
    var body: some View {
        VStack {
            HStack{
                if viewModel.quizState == .prepareQuestion {
                    Button(action: { viewModel.pauseGame() }, label: {
                        HStack {
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .accentColor(Appearance.textColor)
                    })
                }
                
                Spacer()
                
                ForEach(viewModel.lives, id: \.self) { life in
                    switch life {
                    case .unavailable:
                        Image(systemName: "heart.slash")
                            .foregroundColor(.gray)
                    case .available:
                        Image(systemName: "suit.heart.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(height: 24)
            .padding()
            
            Spacer()
                .frame(height: 60)
            
            HStack {
                Image(systemName: "star.fill")

                Text("\(viewModel.totalPoints)")
                    .fontWeight(.black)
            }
            .font(.largeTitle)
            .foregroundColor(Color.white)
            
            Spacer()
            
            if viewModel.quizState == .play {
                HStack {
                    Spacer()
                    Text("\(viewModel.points)")
                        .font(.title2)
                        .foregroundColor(Appearance.textColor)
                }
                .animation(.spring())
                .padding()
            }

            VStack {
                switch viewModel.quizState {
                case .end:
                    SolidButton(action: { viewModel.restart() },
                                Text("Play Again")
                    )
                    .padding(32)
                case .prepareQuestion:
                    HStack {
                        Spacer()
                        Text("Preparing Question")
                            .font(.largeTitle)
                            .foregroundColor(Appearance.textColor)
                            .padding()
                        Spacer()
                    }
                case .play, .showAnswer:
                    ProgressBarView(value: $viewModel.timeRemaining,
                                    maxValue: viewModel.gameManager.configuration.timeForQuestion)
                        .frame(height: 6)
                        .cornerRadius(3)
                        .padding(40)
                    
                    Text(viewModel.question.element.question)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    LazyVGrid(columns: [GridItem(.flexible()),
                                        GridItem(.flexible())]) {
                        ForEach(viewModel.question.element.responses, id: \.self) { response in
                            Button(action: { viewModel.submit(response: response) }, label: {
                                Text(response)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(Appearance.textColor)
                                    .opacity(viewModel.disabledResponses.contains(response) ? 0.75 : 1)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
                                    .padding()
                            })
                            .background(
                                ZStack {
                                    GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: 16)
                                            .foregroundColor(
                                                viewModel.responseBackground(response).opacity(0.2)
                                            )
                                        
                                        if viewModel.lifelines.contains(.init(type: .audience, isUsed: true)) {
                                            RoundedRectangle(cornerRadius: 16)
                                                .foregroundColor(.gray)
                                                .frame(width: viewModel.showPercentage(width: geometry.size.width,
                                                                                       response: response))
                                        }
                                        
                                        RoundedRectangle(cornerRadius: 16)
                                            .foregroundColor(viewModel.responseBackground(response))
                                            .opacity(0.8)
                                    }
                                    
                                    if viewModel.quizState == .play {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color.gray, lineWidth: 4)
                                            .opacity(0.9)
                                    }
                                }
                            )
                            .disabled(viewModel.isButtonDisabled(for: response))
                            .opacity(viewModel.isButtonDisabled(for: response) ? 0.2 : 1)
                            .shadow(color: Color.gray.opacity(0.05),
                                    radius: 25, x: 0, y: 4)
                            .padding(.horizontal)
                        }
                    }
                    
                    HStack {
                        ForEach(viewModel.lifelines) { lifeline  in
                            Button(lifeline.id.title, action: {
                                viewModel.useLifeline(lifeline)
                            })
                            .padding(16)
                            .foregroundColor(Appearance.textColor)
                            .buttonStyle(PlainButtonStyle())
                            .disabled(lifeline.isUsed || viewModel.quizState == .showAnswer)
                        }
                    }
                    .frame(height: 48)
                default:
                    EmptyView()
                }
            }
            .minimumScaleFactor(0.5)
            .background(Color.white)
            .shadow(color: Color.gray.opacity(0.05),
                    radius: 25, x: 0, y: 4)
            .cornerRadius(radius: 24, corners: [.topRight,  .topLeft])
            .animation(.spring())
        }
        .accentColor(Appearance.textColor)
        .background(Appearance.primaryColor.opacity(viewModel.quizState == .play ? 0.75 : 0))
    }
}

extension QuizView {
    class ViewModel: ObservableObject {
        @Published var lives: [Life] = []
        @Published var question: QuestionWithIndex
        @Published var lifelines: [Lifeline] = []
        @Published var timeRemaining: Double = 0
        @Published var totalPoints: Int = 0
        @Published var points: Int = 0
        @Published var showAnswer: Bool = false
        @Published var quizState: QuizSession.State
        
        /// MARK: Lifelines
        @Published var disabledResponses: [String] = []
        @Published var percentageResponses: [(String, CGFloat)] = []
        
        
        let gameManager: QuestionManager
        
        private var cancellable = Set<AnyCancellable>()
        
        init(question: QuestionWithIndex,
             quizState: QuizSession.State = .play,
             gameManager: QuestionManager) {
            self.question = question
            self.gameManager = gameManager
            self.quizState = quizState
            setupActions()
        }
        
        func restart() {
            gameManager.play()
        }
        
        func pauseGame() {
            gameManager.pause()
        }
        
        func useLifeline(_ lifeline: Lifeline) {
            gameManager.use(lifeline: lifeline.id)
        }
        
        func submit(response: String) {
            gameManager.submit(response: response, for: question)
            gameManager.showAnswer()
            showAnswer = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showAnswer = false
                self.gameManager.prepareQuestion()
            }
        }
        
        func isButtonDisabled(for response: String) -> Bool {
            disabledResponses.contains(response)
        }
        
        func responseBackground(_ response: String) -> Color {
            guard showAnswer == true else { return Color.clear }
            return response == question.element.correctResponse ? .green : .red
        }
        
        func showPercentage(width: CGFloat, response: String) -> CGFloat {
            let percentage = percentageResponses.first(where: { $0.0 == response })?.1 ?? 0
            return width * percentage
        }
        
        private func setupActions() {
            let quizSession = gameManager.quizSession
            
            quizSession.lives
                .receive(on: DispatchQueue.main)
                .assign(to: \.lives, on: self)
                .store(in: &cancellable)
            
            quizSession.quizState
                .receive(on: DispatchQueue.main)
                .assign(to: \.quizState, on: self)
                .store(in: &cancellable)
            
            quizSession.currentQuestion
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .assign(to: \.question, on: self)
                .store(in: &cancellable)
            
            quizSession.timeRemaining
                .receive(on: DispatchQueue.main)
                .assign(to: \.timeRemaining, on: self)
                .store(in: &cancellable)
            
            quizSession.points
                .receive(on: DispatchQueue.main)
                .assign(to: \.points, on: self)
                .store(in: &cancellable)
            
            quizSession.totalPoints
                .receive(on: DispatchQueue.main)
                .assign(to: \.totalPoints, on: self)
                .store(in: &cancellable)
            
            quizSession.lifelines
                .receive(on: DispatchQueue.main)
                .assign(to: \.lifelines, on: self)
                .store(in: &cancellable)
            
            quizSession.disabledResponses
                .receive(on: DispatchQueue.main)
                .assign(to: \.disabledResponses, on: self)
                .store(in: &cancellable)
            
            quizSession.percentageResponses
                .receive(on: DispatchQueue.main)
                .assign(to: \.percentageResponses, on: self)
                .store(in: &cancellable)
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        let configuration = QuizConfiguration(questions: Question.appleStub(),
                                              points: [0..<10: 10],
                                              timeForQuestion: 10,
                                              prepareTime: 5)
        let gameManager = QuestionManager(configuration: configuration)
        gameManager.play()
        return QuizView(viewModel: .init(question: gameManager.quizSession.currentQuestion.value!,
                                         gameManager: gameManager))
            .background(Color.yellow)
            .previewLayout(.sizeThatFits)
    }
}

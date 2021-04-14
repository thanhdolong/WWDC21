//
//  Pages.swift
//  BookCore
//
//  Created by Thành Đỗ Long on 04.04.2021.
//

import PlaygroundSupport

public class Pages {
    public static func instantiateHomepageScene() -> PlaygroundLiveViewable {
        let quizConfiguration = QuizConfiguration(questions: Question.appleStub(),
                                                  points: [
                                                    7.5...10: 1,
                                                    5...7.5: 0.8,
                                                    0...5: 0.6
                                                  ],
                                                  timeForQuestion: 10,
                                                  prepareTime: 5)
        let viewModel = HomepageView.ViewModel(gameManager: .init(configuration: quizConfiguration))
        
        return HomepageView(viewModel: viewModel).instantiateLiveView()
    }
    
    public static func instantiateHomepageScene(_ quizConfiguration: QuizConfiguration) -> PlaygroundLiveViewable {
        let viewModel = HomepageView.ViewModel(gameManager: .init(configuration: quizConfiguration))
        
        return HomepageView(viewModel: viewModel).instantiateLiveView()
    }
    
    public static func instantiateIntroduction() -> PlaygroundLiveViewable{
        IntroPage().instantiateLiveView()
    }
    
    public static func instantiateEpilogue() -> PlaygroundLiveViewable{
        EpiloguePage().instantiateLiveView()
    }
}


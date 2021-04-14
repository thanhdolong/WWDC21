//
//  QuizConfiguration.swift
//  BookCore
//
//  Created by Thành Đỗ Long on 09.04.2021.
//

public struct QuizConfiguration {
    let questions: [Question]
    let points: [ClosedRange<Double>: Double]
    let timeForQuestion: Double
    let prepareTime: Double
    let lives: Int
    
    public init(questions: [Question],
                points: [ClosedRange<Double>: Double] = [0...10: 1],
                timeForQuestion: Double = 10,
                prepareTime: Double = 5,
                lives: Int = 3) {
        self.questions = questions
        self.points = points
        self.timeForQuestion = timeForQuestion
        self.prepareTime = prepareTime
        self.lives = lives
    }
}

//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
import PlaygroundSupport
import BookCore
import Foundation

enum QuestionSet: CaseIterable {
    case gameOfThrones, apple, covid, random
    
    func loadQuestions() -> [Question] {
        switch self {
        case .gameOfThrones:
            return Question.gotStub()
        case .apple:
            return Question.appleStub()
        case .covid:
            return Question.covidtub()
        case .random:
            guard let randomQuestionSet = [Question.gotStub(),
                                   Question.appleStub(),
                                   Question.covidtub()]
                    .randomElement() else { return [] }
            return randomQuestionSet
        }
    }
}

//#-end-hidden-code

/*:

 # Personalize Quiz Game
 With several changes, you can customize the game. Too easy? No problem! Just lower the timer to answer the question or give fewer lives.
 
 * Important: You can additionally change the question set. Currently is available: ``gameOfThrones``, ``apple``, ``covid`` and by default ``random``.
*/

/// - Quiz configuration
let timeForQuestion: Double = /*#-editable-code*/<#T##time for question##Double#>/*#-end-editable-code*/
let prepareTime: Double = /*#-editable-code*/<#T##prepare time##Double#>/*#-end-editable-code*/
let lives: Int = /*#-editable-code*/<#T##lives##Int#>/*#-end-editable-code*/
let questionSet: QuestionSet = /*#-editable-code*/.random/*#-end-editable-code*/

//#-hidden-code
let quizConfiguration = QuizConfiguration(questions: questionSet.loadQuestions(),
                                          points: [0...timeForQuestion: 1],
                                          timeForQuestion: timeForQuestion,
                                          prepareTime: prepareTime,
                                          lives: lives)

PlaygroundPage.current.liveView = Pages.instantiateHomepageScene(quizConfiguration)
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code

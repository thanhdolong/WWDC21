//
//  Question.swift
//  BookCore
//
//  Created by Thành Đỗ Long on 09.04.2021.
//

import Foundation
import SwiftUI

typealias QuestionWithIndex = (offset: Int, element: Question)
public struct Question: Hashable {
    let question: String
    let responses: [String]
    let correctResponse: String
}

extension Question {
    public static func gotStub() -> [Question] {
        [
            Question(question: "Who Plotted and planned to kill King Joffrey?",
                     responses: ["Littlefinger", "Sansa Stark", "Daenerys Targaryen", "Margery Tyrel"],
                     correctResponse: "Sansa Stark"),
            Question(question: "What is the correct surname: Brienne of ….?",
                     responses: ["Gib", "Taragon", "Tully", "Tarth"],
                     correctResponse: "Tarth"),
            Question(question: "The Leader of the Unsullied is known as…",
                     responses: ["Grey Worm", "White Spider", "Khaleese", "Red Lion"],
                     correctResponse: "Khaleese"),
            Question(question: "Which house motto is `Hear me roar`?",
                     responses: ["Stark", "Tyrell", "Apple", "Lannister"],
                     correctResponse: "Lannister"),
            Question(question: "how did King Joffrey die?",
                     responses: ["Hung", "White walkers got to him", "Poisoned", "Stabbed from behind"],
                     correctResponse: "Poisoned"),
            Question(question: "What did Snow say to Arya Stark when teaching her how to sword fight, “Stick them with the…",
                     responses: ["Pointy end", "Needle end", "Pricky end", "Sticky end"],
                     correctResponse: "Pointy end")
        ]
    }
}

extension Question {
    public static func appleStub() -> [Question] {
        [
            Question(question: "In what year was the company Apple Computer incorporated?",
                     responses: ["1982", "1976", "2001", "2007"],
                     correctResponse: "1976"),
            Question(question: "When did Steve Jobs introduce the first iPhone?",
                     responses: ["January 9, 2007", "September 25, 2007", "January 9, 2008", "September 25, 2008"],
                     correctResponse: "January 9, 2007"),
            Question(question: "What is the biggest difference about the iPhone X?",
                     responses: ["It can stand up by itself", "It has 5 cameras", "It has no home button", "It glows in the dark"],
                     correctResponse: "It has no home button"),
            Question(question: "In which year was the first iPad released?",
                     responses: ["2008", "2010", "2012", "2013"],
                     correctResponse: "2010"),
            Question(question: "What is the title of Apple store employees?",
                     responses: ["Experts", "Appleoids", "Geniuses", "Clones"],
                     correctResponse: "Geniuses"),
            Question(question: "Which of these things can we NOT do with an Apple watch?",
                     responses: ["Make calls", "Take photos", "Send texts", "Check weather"],
                     correctResponse: "Take photos"),
            Question(question: "What is the name of Apple's artificial intelligence data friend?",
                     responses: ["Apple", "Steve", "Siri", "Sara"],
                     correctResponse: "Siri"),
            Question(question: "What was the name of the 2004 iPhone developmental plan?",
                     responses: ["Project Purple", "Project Jet", "Project River", "Project Touch"],
                     correctResponse: "Project Purple"),
            Question(question: "What was the Apple fail called when phones bent in pockets?",
                     responses: ["Bendsnooze", "Bendmore", "Bendloss", "Bendgate"],
                     correctResponse: "Bendgate"),
            Question(question: "When and where was the first European Apple Store opened?",
                     responses: ["London, 2004", "Paris, 2003", "Berlin 2002", "Prague 2001"],
                     correctResponse: "London, 2004"),
            Question(question: "Programming language Swift was introduced in",
                     responses: ["2010", "2014", "2016", "2018"],
                     correctResponse: "2014")
        ]
    }
}

extension Question {
    public static func covidtub() -> [Question] {
        [
            Question(question: "Covid-19 is the disease caused by:",
                     responses: ["SARS-CoV-2", "SARS-CoV-1", "H1N1", "H1N2"],
                     correctResponse: "SARS-CoV-2"),
            Question(question: "What is not a good way to protect others and ourselves not to get infected by SARS-CoV-2?",
                     responses: ["Physical distancing", "Wearing a mask", "Cleaning hands", "Pray"],
                     correctResponse: "Pray"),
            Question(question: "Where did the first case of the COVID-19 disease originate?",
                     responses: ["India", "China", "Italy", "Vietnam"],
                     correctResponse: "China"),
            Question(question: "The first influenza pandemic of the 21st century occurred in?",
                     responses: ["2002", "2009", "2004", "2012"],
                     correctResponse: "2009"),
            Question(question: "How many deaths caused Spanish Flue?",
                     responses: ["10-20 million", "70-100 million", "20-50 million", "110-130 million"],
                     correctResponse: "20-50 million"),
            Question(question: "The letter m in mRNA vaccines means:",
                     responses: ["Mutant", "Messenger", "Modify", "Mark"],
                     correctResponse: "Messenger"),
            Question(question: "Symptoms of COVID-19 is not:",
                     responses: ["Fever", "Dry cough", "Increased appetite", "Fatigue"],
                     correctResponse: "Fatigue")
        ]
    }
}

//
//  Lifeline.swift
//  BookCore
//
//  Created by Thành Đỗ Long on 16.04.2021.
//

import Foundation

enum LifelineType: CaseIterable {
    case fiftyFifty, newQuestion, audience
    
    var title: String {
        switch self {
        case .fiftyFifty:
            return "50/50"
        case .newQuestion:
            return "Switch the Question"
        case .audience:
            return "Ask the Audience"
        }
    }
}

struct Lifeline: Identifiable, Hashable {
    let id: LifelineType
    let isUsed: Bool
    
    init(type: LifelineType, isUsed: Bool = false) {
        self.id = type
        self.isUsed = isUsed
    }
}


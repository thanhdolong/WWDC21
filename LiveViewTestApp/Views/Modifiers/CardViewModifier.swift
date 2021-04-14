//
//  CardViewModifier.swift
//  LiveViewTestApp
//
//  Created by Thành Đỗ Long on 07.04.2021.
//

import SwiftUI

struct CardViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Color(.white)
            )
            .cornerRadius(18)
            .shadow(color: Color.gray.opacity(0.05),
                    radius: 25, x: 0, y: 4)
    }
}

//
//  View+.swift
//  BookCore
//
//  Created by Thành Đỗ Long on 04.04.2021.
//

import SwiftUI
import PlaygroundSupport

extension View {
    func instantiateLiveView() -> PlaygroundLiveViewable {
        UIHostingController(rootView: self)
    }
}

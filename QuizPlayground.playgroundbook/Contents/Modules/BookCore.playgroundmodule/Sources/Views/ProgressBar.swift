//
//  ProgressBar.swift
//  BookCore
//
//  Created by Thành Đỗ Long on 13.04.2021.
//

import SwiftUI

struct ProgressBarView: View {
    @Binding var value: Double
    
    @State var maxValue: Double
    @State var cornerRadius: CGFloat = 0
    @State var foregroundColor: Color = Appearance.secondaryColor
    @State var backgroundColor: Color = .gray
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .foregroundColor(backgroundColor)
                
                Rectangle()
                    .frame(width: progress(value: max(0, value),
                                           maxValue: maxValue,
                                           width: geometry.size.width))
                    .foregroundColor(foregroundColor)
                    .animation(.linear(duration: QuestionManager.timerInterval), value: value)
            }
            .cornerRadius(cornerRadius)
        }
        .animation(nil)
    }
    
    private func progress(value: Double, maxValue: Double, width: CGFloat) -> CGFloat {
        let percentage = value / maxValue
        return width * CGFloat(percentage)
    }
}
struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(value: .constant(20), maxValue: 100)
            .frame(height: 20)
            .padding()
    }
}

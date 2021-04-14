//
//  QuestionCapsuleView.swift
//  LiveViewTestApp
//
//  Created by Thành Đỗ Long on 10.04.2021.
//

import SwiftUI

struct QuestionCapsuleView: View {
    let animationDuration: Double
    
    @Binding var questionIndex: Int
    @Binding var response: Bool?
    @Binding var currentQuestionIndex: Int?
    @Binding var loadingValue: Double
    
    @State private var opacity: Double = 0
    @State private var horizontalPadding: CGFloat? = nil
    
    var body: some View {
        HStack {
            Text("Question #\(questionIndex)")
                .fontWeight(.heavy)
            
            Spacer()
            
            if offsetFromCurrentQuestion() ?? 0 >= 0, response == true {
                Image(systemName: "checkmark.circle")
            }
            
            if offsetFromCurrentQuestion() ?? 0 >= 0, response == false {
                Image(systemName: "xmark.circle")
            }
        }
        .foregroundColor(Appearance.primaryColor)
        .padding(.horizontal, 16)
        .font(.title2)
        .frame(height: 53)
        .background(
            ZStack {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(background())

                    if isCurrentQuestion() {
                        ProgressBarView(value: $loadingValue,
                                        maxValue: animationDuration,
                                        backgroundColor: .clear)
                    }
                }
            }
            .cornerRadius(24)
        )
        .onChange(of: currentQuestionIndex, perform: { value in
            startAnimation()
        })
        .onAppear(perform: {
            startAnimation()
        })
        .opacity(opacity)
        .padding(.horizontal, horizontalPadding)
        .shadow(color: Color.gray.opacity(0.05),
                radius: 25, x: 0, y: 4)
        .id(questionIndex)
    }
}

extension QuestionCapsuleView {
    func startAnimation() {
        withAnimation(.spring()) {
            horizontalPadding = horizontalPaddingCalculation()
            opacity = opacityCalculation()
        }
    }
    
    func isCurrentQuestion() -> Bool {
        guard let currentQuestionIndex = currentQuestionIndex else { return false }
        return currentQuestionIndex == questionIndex
    }
    
    func offsetFromCurrentQuestion() -> Double? {
        guard let currentQuestionIndex = currentQuestionIndex else { return nil }
        return Double(currentQuestionIndex - questionIndex)
    }
    
    func background() -> Color {
        guard let response = response else {
            return .white
        }
        
        switch response {
        case true:
            return Color.green.opacity(0.85)
        case false:
            return Color.red.opacity(0.85)
        }
    }
    
    func horizontalPaddingCalculation() -> CGFloat {
        guard let scale = offsetFromCurrentQuestion() else { return 0 }
        return CGFloat(abs(scale) * 16)
    }
    
    func opacityCalculation() -> Double {
        guard let mutriplier = offsetFromCurrentQuestion() else { return 1 }
        let visibleQuizes = 1 / 5
        
        guard mutriplier > 0 else { return  1 }
        return max(1 - (Double(visibleQuizes) * abs(mutriplier)) - 0.25, 0.05)
    }
}

struct QuestionCapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCapsuleView(animationDuration: 5,
                            questionIndex: .constant(0),
                            response: .constant(nil),
                            currentQuestionIndex: .constant(nil),
                            loadingValue: .constant(3))
            .previewLayout(.sizeThatFits)
    }
}

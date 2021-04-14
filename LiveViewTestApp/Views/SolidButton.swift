//
//  SolidButton.swift
//  LiveViewTestApp
//
//  Created by Thành Đỗ Long on 17.04.2021.
//

import SwiftUI

struct SolidButton<Label>: View where Label: View {
    private let label: Label
    @Binding var isDisabled: Bool

    let action: () -> Void

    init(action: @escaping () -> Void,
         _ label: Label,
         isDisabled: Binding<Bool> = .constant(false)) {
        self.action = action
        self.label = label
        self._isDisabled = isDisabled
    }

    var body: some View {
        Button(action: action, label: {
            label
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(16)
        })
//        .textStyle(size == .large ? .buttonLarge : .buttonSmall)
        .buttonStyle(GradientButtonStyle(isDisabled: $isDisabled))
        .disabled(isDisabled)

    }
}

private struct GradientButtonStyle: ButtonStyle {
    @Binding var isDisabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Appearance.primaryColor)
            .cornerRadius(12)
            .opacity(isDisabled ? 0.75 : 1)
            .scaleEffect(configuration.isPressed && isDisabled == false ? 0.93 : 1)
            .animation(.spring(), value: configuration.isPressed)
            .animation(.spring(), value: isDisabled)
    }
}

struct GradientButton_Previews: PreviewProvider {
    static var previews: some View {
        SolidButton(action: {
            print("Action button tap")
        }, Text("Button"))
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

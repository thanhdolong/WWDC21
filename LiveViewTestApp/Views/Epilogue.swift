//
//  Epilogue.swift
//  LiveViewTestApp
//
//  Created by Thành Đỗ Long on 19.04.2021.
//

import SwiftUI

struct Epilogue: View {
    @State var startAnimation: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Text("Hi 👋")
                Image("memoji")
                    .offset(y: startAnimation ? -10 : 0)
                    .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                               value: startAnimation)
                Text("Thank you fo checking ou my Swift Playground")
                Text("Made with ❤️ by Do Long Thanh")
            }
            .font(.title)
        }
        .foregroundColor(Color.white)
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
        .onAppear(perform: {
            startAnimation.toggle()
        })
    }
}

struct Epilogue_Previews: PreviewProvider {
    static var previews: some View {
        Epilogue()
    }
}

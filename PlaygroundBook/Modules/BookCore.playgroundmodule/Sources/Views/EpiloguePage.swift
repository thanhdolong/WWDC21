//
//  EpiloguePage.swift
//  BookCore
//
//  Created by Thành Đỗ Long on 19.04.2021.
//

import SwiftUI

struct EpiloguePage: View {
    @State var startAnimation: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Image("memoji")
                    .offset(y: startAnimation ? -10 : 0)
                    .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                               value: startAnimation)
                Text("Hi 👋. Thank you for checking out my Swift Playground")
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

struct EpiloguePage_Previews: PreviewProvider {
    static var previews: some View {
        EpiloguePage()
    }
}

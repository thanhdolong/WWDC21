//
//  IntroPage.swift
//  BookCore
//
//  Created by Thành Đỗ Long on 19.04.2021.
//

import SwiftUI
import PlaygroundSupport

struct IntroPage: View {
    @State var startAnimation: Bool = false
    @State var startLoading: Bool = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .top) {
                Circle()
                    .fill(Appearance.primaryColor)
                    .scaleEffect(CGSize(width: startLoading ? 4 : 2,
                                        height: startLoading ? 4 : 0.4))
                    .offset(y: startLoading ? 0 : geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                
                LogoView()
                    .hueRotation(.degrees(startAnimation ? 0 : 360))
                    .rotation3DEffect(
                        .degrees(startAnimation ? 0 : -360),
                        axis: (x: startAnimation ? 1 : -1,
                               y: startAnimation ? 1 : 0,
                               z: 0.0))
                    .animation(Animation
                                .easeInOut(duration: 10)
                                .repeatForever(autoreverses: true))
                
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "applelogo")
                        Text("WWDC21")
                            .fontWeight(.bold)
                    }
                    Text("Quiz game")
                }
                .padding(.bottom, 140)
                .font(.largeTitle)
                .foregroundColor(Color.white)
                
                
                VStack {
                    Spacer()
                    SolidButton(action: { startLoadingGame() }, Text("Start game"))
                        .padding(64)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity,
                   minHeight: 0, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .onAppear(perform: {
                startAnimation.toggle()
            })
        })
    }
    
    private func startLoadingGame() {
        withAnimation(.easeIn(duration: 0.75)) {
            startLoading.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            PlaygroundPage.current.navigateTo(page: .next)
        }
    }
}

struct IntroPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroPage()
    }
}

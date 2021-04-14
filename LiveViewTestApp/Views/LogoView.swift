//
//  LogoView.swift
//  LiveViewTestApp
//
//  Created by Thành Đỗ Long on 19.04.2021.
//

import SwiftUI

struct LogoView: View {
    
    // MARK:- variables
    @State var resetStrokes: Bool = true
    @State var strokeStart: CGFloat = 0
    @State var strokeEnd: CGFloat = 0
    
    var body: some View {
        AppleLogoShape()
            .trim(from: strokeStart, to: strokeEnd)
            .stroke(LinearGradient(gradient: .init(colors: ColorPalette.bottomLogo()),
                                   startPoint: .leading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 50,
                                       lineCap: .round,
                                       lineJoin: .round,
                                       miterLimit: 10))
            .blur(radius: 2)
            .onAppear() {
                withAnimation(.interpolatingSpring(stiffness: 0.3, damping: 1)) {
                    self.strokeEnd = 1
                }
            }
            .scaleEffect(0.4, anchor: .center)
    }
}


struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
        
    }
}

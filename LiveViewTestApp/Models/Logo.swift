//
//  Logo.swift
//  LiveViewTestApp
//
//  Created by Thành Đỗ Long on 19.04.2021.
//

import SwiftUI

struct AppleLogoShape: Shape {
    func path(in rect: CGRect) -> Path {
        var appleLogoPath = Path()
        appleLogoPath.move(to: CGPoint(x: 409, y: 252))
        appleLogoPath.addCurve(to: CGPoint(x: 464, y: 93), control1: CGPoint(x: 409, y: 252), control2: CGPoint(x: 409, y: 148))
        appleLogoPath.addCurve(to: CGPoint(x: 591, y: 33), control1: CGPoint(x: 519, y: 38), control2: CGPoint(x: 591, y: 33))
        appleLogoPath.addCurve(to: CGPoint(x: 557, y: 156), control1: CGPoint(x: 591, y: 33), control2: CGPoint(x: 595, y: 101))
        appleLogoPath.addCurve(to: CGPoint(x: 442, y: 236), control1: CGPoint(x: 519, y: 211), control2: CGPoint(x: 442, y: 236))
        UIColor.black.setStroke()

        //// Bezier 2 Drawing
        appleLogoPath.move(to: CGPoint(x: 365, y: 308))
        appleLogoPath.addCurve(to: CGPoint(x: 237, y: 287), control1: CGPoint(x: 365, y: 308), control2: CGPoint(x: 309.54, y: 274.55))
        appleLogoPath.addCurve(to: CGPoint(x: 56, y: 424), control1: CGPoint(x: 174.84, y: 297.67), control2: CGPoint(x: 96, y: 351))
        appleLogoPath.addCurve(to: CGPoint(x: 146, y: 671), control1: CGPoint(x: 16, y: 497), control2: CGPoint(x: 32, y: 628))
        appleLogoPath.addCurve(to: CGPoint(x: 528, y: 576), control1: CGPoint(x: 260, y: 714), control2: CGPoint(x: 447, y: 624))
        appleLogoPath.addCurve(to: CGPoint(x: 705, y: 340), control1: CGPoint(x: 609, y: 528), control2: CGPoint(x: 736, y: 400))
        appleLogoPath.addCurve(to: CGPoint(x: 505, y: 340), control1: CGPoint(x: 674, y: 280), control2: CGPoint(x: 567, y: 304))
        appleLogoPath.addCurve(to: CGPoint(x: 292, y: 509), control1: CGPoint(x: 443, y: 376), control2: CGPoint(x: 384, y: 422))
        appleLogoPath.addCurve(to: CGPoint(x: 168, y: 885), control1: CGPoint(x: 200, y: 596), control2: CGPoint(x: 84, y: 783))
        appleLogoPath.addCurve(to: CGPoint(x: 453, y: 914), control1: CGPoint(x: 252, y: 987), control2: CGPoint(x: 401, y: 931))
        appleLogoPath.addCurve(to: CGPoint(x: 640, y: 788), control1: CGPoint(x: 505, y: 897), control2: CGPoint(x: 597, y: 836))
        appleLogoPath.addCurve(to: CGPoint(x: 681, y: 682), control1: CGPoint(x: 661.08, y: 764.47), control2: CGPoint(x: 690.5, y: 717.5))
        appleLogoPath.addCurve(to: CGPoint(x: 602, y: 646), control1: CGPoint(x: 671.5, y: 646.5), control2: CGPoint(x: 632.84, y: 637.72))
        appleLogoPath.addCurve(to: CGPoint(x: 453, y: 768), control1: CGPoint(x: 541.5, y: 662.25), control2: CGPoint(x: 497, y: 684))
        appleLogoPath.addCurve(to: CGPoint(x: 570, y: 964), control1: CGPoint(x: 409, y: 852), control2: CGPoint(x: 471, y: 974))
        appleLogoPath.addCurve(to: CGPoint(x: 756, y: 838), control1: CGPoint(x: 669, y: 954), control2: CGPoint(x: 729, y: 890))
        appleLogoPath.addCurve(to: CGPoint(x: 785, y: 731), control1: CGPoint(x: 783, y: 786), control2: CGPoint(x: 785, y: 731))
        
        return appleLogoPath
    }
}

enum ColorPalette {
    static func bottomLogo() -> [Color] {
        [
            Color(red:0.651, green: 0.824, blue: 0.373),
            Color(red:1.000, green: 0.776, blue: 0.020),
            Color(red:0.941, green: 0.325, blue: 0.267),
            Color(red:0.506, green: 0.314, blue: 0.725),
            Color(red:0.451, green: 0.702, blue: 0.875)
        ]
    }
}

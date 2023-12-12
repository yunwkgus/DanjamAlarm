//
//  LottieView2.swift
//  DanjamRenew
//
//  Created by jose Yun on 2023/10/07.
//


import SwiftUI
import LottieUI

public struct DayLottie: View {
    
    let state1 = LUStateData(type: .loadedFrom(URL(string: "https://assets5.lottiefiles.com/packages/lf20_rjgikbck.json")!), speed: 0.9, loopMode: .autoReverse)
    let state2 = LUStateData(type: .loadedFrom(URL(string: "https://assets10.lottiefiles.com/packages/lf20_wdqlqkhq.json")!), speed: 1.1, loopMode: .loop)
    let state3 = LUStateData(type: .loadedFrom(URL(string: "https://assets2.lottiefiles.com/packages/lf20_agu7b2gf.json")!), speed: 0.95, loopMode: .autoReverse)

    public init() {}
    public var body: some View {
        ZStack {
            ForEach(0...1, id: \.self) { index in
                Color.yellow.mask {
                    LottieView(state: state1)
                        .blendMode(.screen)
                        .rotationEffect(Angle(degrees: CGFloat.random(in: -360...360)))
                        .scaleEffect(CGFloat.random(in: 0.7...0.8))
                }
                Color.orange.mask {
                    LottieView(state: state2)
                        .blendMode(.darken)
                        .rotationEffect(Angle(degrees: CGFloat.random(in: -360...360)))
                        .scaleEffect(CGFloat.random(in: 0.5...0.8))
                }
                Color.pink.mask {
                        LottieView(state: state3)
                            .blendMode(.screen)
                            .rotationEffect(Angle(degrees: CGFloat.random(in: -360...360)))
                            .scaleEffect(CGFloat.random(in: 0.9...1.0))
                }
            }
        }
    }
}

struct DayLottie_Previews: PreviewProvider {
    
    static var previews: some View {
        DayLottie()
    }
}

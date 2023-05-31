//
//  Playback.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/31.
//

import SwiftUI
import ComposableArchitecture



struct PlaybackView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GradientEffectView(
                    .constant(
                        AnimatedGradient.Model(
                            colors: [.red, .yellow, .green, .blue, .magenta]
                                .map { Color(uiColor: $0) }
                        )
                    )
                )
                VStack {
                    Text("지금 매연님이 듣고 있는 노래는")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding(.bottom, 30)
                    Image("ic_album_cover")
                        .resizable()
                        .frame(width: geometry.size.width - 100, height: geometry.size.width - 100)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                        .shadow(radius: 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("밤")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.title3)
                            Text("문재욱 & 임재현")
                                .foregroundColor(Color(.white.withAlphaComponent(0.5)))
                                .fontWeight(.medium)
                        }
                        Spacer()
                        Button(action: { }) {
                            CircleImageView(name: "square.and.arrow.up")
                        }.frame(width: 28, height: 28)
                        
                    }
                    .padding(.horizontal, 58)
                    .padding(.top, 8)
                    
                }
            }
        }
    }
    //    private func setAverageColor() {
    //        let uiColor = UIImage(named: images[currentIndex])?.averageColor ?? .clear
    //        backgroundColor = Color(uiColor)
    //    }
}

struct PlaybackView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackView()
    }
}

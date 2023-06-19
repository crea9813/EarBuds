//
//  Playback.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/31.
//

import SwiftUI
import ComposableArchitecture

struct PlaybackView: View {
    
    let store: StoreOf<Playback>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            GeometryReader { geometry in
                ZStack {
                    GradientEffectView(
                        .constant(
                            AnimatedGradient.Model(colors: viewStore.gradientColors)
                        )
                    )
                    VStack {
                        HStack {
                            Button(action: { }) {
                                CircleImageView(name: "person.fill")
                            }.frame(width: 40, height: 40)
                            Spacer()
                        }
                        .padding(.leading, 30)
                        .padding(.top, 30)
                        
                        Text("지금 매연님이 듣고 있는 노래는")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title2)
                            .padding(.top, 40)
                            .padding(.bottom, 30)
                        
                        AsyncImage(url: URL(string: viewStore.song!.artworkURL)) {
                            image in
                            image.resizable()
                        } placeholder: {
                            Image("").resizable()
                        }
                        .frame(width: geometry.size.width - 100, height: geometry.size.width - 100)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                        .shadow(radius: 10)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(viewStore.song?.name ?? "재생 중이 아님")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.title3)
                                Text(viewStore.song?.artistName ?? "")
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
                        Spacer()
                        
                        HStack {
                            Image(systemName: "play.circle")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .padding(.vertical, 10)
                                .padding(.leading, 18)
                            Text("음악 앱으로 재생")
                                .foregroundColor(Color(.white))
                                .fontWeight(.semibold)
                                .font(.headline)
                                .padding(.trailing, 18)
                        }
                        .background(Color(.white.withAlphaComponent(0.5)))
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        
                    }
                }
            }
        }
    }
}

struct PlaybackView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackView(store: Store(initialState: Playback.State()) {
            Playback()
        })
    }
}

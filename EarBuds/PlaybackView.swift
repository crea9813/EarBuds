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
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            viewStore.send(.setSheet(isPresented: true))
                        }) {
                            CircleImageView(name: "person.fill")
                        }
                        .frame(width: 40, height: 40)
                        .padding(.leading, 30)
                        .padding(.top, 30)
                        Spacer()
                    }
                    
                    Text("매연님이\n듣고 있는 노래는")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                    
                    AsyncImage(url: URL(string: viewStore.track?.attributes.artwork.url.replacingOccurrences(of: "{w}", with: "400").replacingOccurrences(of: "{h}", with: "400") ?? "")) {
                        image in
                        image.resizable().scaledToFill().layoutPriority(1)
                    } placeholder: {
                        Image("ic_album_cover").resizable()
                    }
                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                    .frame(width: 300)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    .shadow(radius: 10)
                    .layoutPriority(1)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewStore.track?.attributes.name ?? "재생 중이 아님")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.title3)
                            Text(viewStore.track?.attributes.artistName ?? "")
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
                    
                    if let href = viewStore.track?.attributes.url {
                        Link(destination: URL(string: href)!) {
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
                .zIndex(1)
                GradientEffectView(
                    .constant(
                        AnimatedGradient.Model(colors: viewStore.gradientColors)
                    )
                )
            }
            .sheet(isPresented: viewStore.binding(get: \.isSheetPresented, send: Playback.Action.setSheet(isPresented:))) {
                IfLetStore(self.store.scope(
                    state: \.profile,
                    action: Playback.Action.profile
                )
                ) {
                    ProfileView(store: $0)
                        .presentationDetents([.height(250)])
                } else: {
                    ProgressView()
                }
            }
            .task {
                viewStore.send(.fetchMusic)
            }
            .navigationBarBackButtonHidden(true)
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

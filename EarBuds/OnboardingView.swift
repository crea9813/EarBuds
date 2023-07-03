//
//  InviteView.swift
//  EarBuds
//
//  Created by 매기 on 2023/06/12.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    
    let store: StoreOf<Onboarding>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                GeometryReader { geometry in
                    ZStack {
                        GradientEffectView(
                            .constant(
                                AnimatedGradient.Model(colors: [randomColor(), randomColor(),randomColor()])
                            )
                        )
                        VStack {
                            Text("친구는 무슨 노래를 듣고 있을까요?")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.title2)
                                .padding(.top, 40)
                                .padding(.bottom, 30)
                            ZStack {
                                Circle()
                                    .frame(width: geometry.size.width - 100, height: geometry.size.width - 100)
                                    .shadow(radius: 10)
                                    .foregroundColor(Color(.black.withAlphaComponent(0.5)))
                                Circle()
                                    .frame(width: 100, height: 100)
                                    .shadow(radius: 10)
                                    .foregroundColor(Color(.white.withAlphaComponent(0.7)))
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .frame(width: 25, height: 30)
                                    .padding(.leading, 8)
                            }
                            
                            NavigationLink(destination: IfLetStore(
                                self.store.scope(
                                    state: \.playback,
                                    action: Onboarding.Action.playback
                                )
                            ) {
                                PlaybackView(store: $0)
                            } else: {
                                Text("Loading")
                            }, isActive: viewStore.binding(
                                get: \.isNavigationActive,
                                send: Onboarding.Action.setNavigation(isActive:)
                            )
                            ) {
                                HStack {
                                    Text("친구 초대하고 시작하기")
                                        .foregroundColor(Color(.white))
                                        .fontWeight(.bold)
                                        .font(.headline)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 12)
                                }
                                .background(Color(.white.withAlphaComponent(0.5)))
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                                .padding(30)
                            }
                        }
                    }
                }
                
            }
            .alert(store: self.store.scope(state: \.$alert, action: Onboarding.Action.alert))
        }
    }
    
    func randomColor() -> Color {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
        
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        
        return Color(randomColor)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(store: Store(initialState: Onboarding.State()) {
            Onboarding()
        })
    }
}

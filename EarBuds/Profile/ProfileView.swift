//
//  ProfileView.swift
//  EarBuds
//
//  Created by 매기 on 2023/07/04.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    VStack {
                        Text(viewStore.profile?.name ?? "")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                        
                        HStack {
                            VStack {
                                Text(viewStore.profile?.uid ?? "")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Text("Friends")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                            }
                        }.padding(.top, 18)
                        Spacer()
                        Text("친구로 추가하기")
                            .foregroundColor(Color(.white))
                            .fontWeight(.bold)
                            .font(.title3)
                            .padding(.horizontal, 60)
                            .padding(.vertical, 14)
                            .background(Color(.white.withAlphaComponent(0.5)))
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                    }
                    .zIndex(1)
                    
                    GradientEffectView(
                        .constant(
                            AnimatedGradient.Model(colors:
                                                    [Color.randomColor(),
                                                     Color.randomColor(),
                                                     Color.randomColor()])
                        )
                    )
                }
            }
            .task {
                viewStore.send(.fetchUserProfile)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(store: Store(initialState: ProfileFeature.State(uid: "CxdAOmfQU2asCbJ9YfQmhIX6Xd13")) {
            ProfileFeature()
        })
    }
}

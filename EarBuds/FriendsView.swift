//
//  FriendsView.swift
//  EarBuds
//
//  Created by 매기 on 2023/07/04.
//

import SwiftUI

struct FriendsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("친구 목록").font(.largeTitle).bold().foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            AddFriendView()
                        }, label: {
                            CircleImageView(name: "plus")
                        }).frame(width: 28, height: 28)
                    }.padding(.horizontal, 30)
                    Spacer()
                }
                .zIndex(1)
                
                GradientEffectView(
                    .constant(
                        AnimatedGradient.Model(colors: [Color.randomColor(),
                                                        Color.randomColor(),
                                                        Color.randomColor()])
                    )
                )
            }
        }.navigationTitle("친구 목록")
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}

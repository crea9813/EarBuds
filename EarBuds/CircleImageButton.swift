//
//  CircleImageButton.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/31.
//

import SwiftUI

struct CircleImageView: View {
    
    private let icon: String
    
    init(name: String) {
        self.icon = name
    }
    
    var body: some View {
        ZStack{
            Circle().fill(.white.opacity(0.3))
            Image(systemName: "\(icon)")
                .resizable()
                .scaledToFit()
                .font(Font.headline.weight(.bold))
                .scaleEffect(0.55)
                .foregroundColor(.white)
        }
    }
}

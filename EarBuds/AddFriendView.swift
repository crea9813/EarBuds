//
//  AddFriendView.swift
//  EarBuds
//
//  Created by 매기 on 2023/07/04.
//

import SwiftUI

struct AddFriendView: View {
    @State private var inviteCode: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("전달 받은\n초대 코드를 입력해주세요.")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
                .lineSpacing(10)
                .multilineTextAlignment(.leading)
            Text("친구를 추가해서 무슨 노래를 듣는지 서로 공유해요!")
                .multilineTextAlignment(.leading)
                .font(.callout)
                .fontWeight(.light)
                .padding(.bottom, 18)
            TextField("친구 코드 입력", text: $inviteCode)
                .font(.title)
                .fontWeight(.semibold)
            Spacer()
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    Text("확인")
                        .foregroundColor(Color(.white))
                        .fontWeight(.semibold)
                        .font(.headline)
                    Spacer()
                }
                .frame(height: 50)
                .background(Color(.black.withAlphaComponent(0.5)))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            })
        }.padding(22)
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView()
    }
}

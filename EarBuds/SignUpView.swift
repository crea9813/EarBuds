//
//  SignUpView.swift
//  EarBuds
//
//  Created by Wade on 2023/09/19.
//

import SwiftUI

struct SignUpView: View {
    
    let pages: [any View] = [UserIDForm(), PasswordForm(), UserNameForm()]
    
    var body: some View {
        ZStack {
            TabView {
                ForEach(0 ..< pages.count) { i in
                    
                }
            }
        }
    }
}

struct UserIDForm: View {
    @State var userID = ""
    
    private let titleString: LocalizedStringKey = "UserIDForm.title"
    private let textfieldString: LocalizedStringKey = "UserIDForm.textField"
    
    var body: some View {
        VStack {
            HStack {
                Text(titleString)
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
            }
            HStack {
                TextField(textfieldString, text: $userID)
                    .font(.title3)
                    .fontWeight(.semibold)
            }.padding(.top, 32)
            Spacer()
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    Text("확인")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.headline)
                    Spacer()
                }
                .frame(height: 58)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            })
        }
        .padding(.horizontal, 22)
        .padding(.top, 60)
        .padding(.bottom, 40)
    }
}

struct PasswordForm: View {
    @State var userID = ""
    
    private let titleString: LocalizedStringKey = "PasswordForm.title"
    private let textfieldString: LocalizedStringKey = "PasswordForm.textField"
    
    var body: some View {
        VStack {
            HStack {
                Text(titleString)
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
            }
            HStack {
                TextField(textfieldString, text: $userID)
                    .font(.title3)
                    .fontWeight(.semibold)
            }.padding(.top, 32)
            Spacer()
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    Text("확인")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.headline)
                    Spacer()
                }
                .frame(height: 58)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            })
        }
        .padding(.horizontal, 22)
        .padding(.top, 60)
        .padding(.bottom, 40)
    }
}

struct UserNameForm: View {
    @State var userID = ""
    
    private let titleString: LocalizedStringKey = "UserNameForm.title"
    private let textfieldString: LocalizedStringKey = "UserNameForm.textField"
    
    var body: some View {
        VStack {
            HStack {
                Text(titleString)
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
            }
            HStack {
                TextField(textfieldString, text: $userID)
                    .font(.title3)
                    .fontWeight(.semibold)
            }.padding(.top, 32)
            Spacer()
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    Text("확인")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.headline)
                    Spacer()
                }
                .frame(height: 58)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            })
        }
        .padding(.horizontal, 22)
        .padding(.top, 60)
        .padding(.bottom, 40)
    }
}

#Preview {
    SignUpView()
        .environment(\.locale, .init(identifier: "ko"))
}

#Preview {
    Group {
        PasswordForm()
            .environment(\.locale, .init(identifier: "ko"))
            .previewLayout(.device)
    }
}

extension View {
    func underlined(_ color: Color) -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 3).padding(.top, 35))
            .foregroundColor(color)
    }
}

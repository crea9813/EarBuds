//
//  InviteView.swift
//  EarBuds
//
//  Created by 매기 on 2023/06/12.
//

import SwiftUI
import ComposableArchitecture



struct OnboardingView: View {
    public let store: StoreOf<Onboarding>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                switch viewStore.viewState {
                case .start:
                    Text("start.title").font(.title).fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        viewStore.send(.startButtonTapped, animation: .easeInOut)
                    }, label: {
                        HStack {
                            Spacer()
                            Text("확인")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.headline)
                            Spacer()
                        }
                    })
                    .frame(height: 58)
                    .foregroundColor(.white)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                case .userID:
                    OnboardingForm(title: "userID.title", "userID.textField", viewStore.binding(get: \.id, send: Onboarding.Action.idChanged))
                        .transition(.slide)
                case .password:
                    OnboardingForm(title: "password.title", "password.textField", viewStore.binding(get: \.id, send: Onboarding.Action.idChanged))
                        .transition(.slide)
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 60)
            .padding(.bottom, 40)
        }
    }
}


struct OnboardingForm: View {
    
    private let title: LocalizedStringKey
    private let placeHolder: LocalizedStringKey
    
    @Binding private var text: String
    
    init(title: LocalizedStringKey, _ placeHolder: LocalizedStringKey, _ text: Binding<String>) {
        self.title = title
        self.placeHolder = placeHolder
        self._text = text
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
            }
            HStack {
                TextField(placeHolder, text: $text)
                    .font(.title3)
                    .fontWeight(.semibold)
            }.padding(.top, 32)
            Spacer()
            Button(action: {
                
            }, label: {
                HStack {
                    Spacer()
                    Text("확인")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.headline)
                    Spacer()
                }
            })
            .disabled(text.isEmpty)
            .frame(height: 58)
            .foregroundColor(.white)
            .background(text.isEmpty ? .gray : .blue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct ConfirmationButtonStyle: PrimitiveButtonStyle {
    let action: () -> Void
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(height: 58)
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    OnboardingView(
        store: Store(initialState: Onboarding.State(), reducer: {
            Onboarding()
        })
    )
        .environment(\.locale, .init(identifier: "ko"))
}

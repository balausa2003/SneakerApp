//
//  WelcomePageView.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 31.05.2023.
//

import SwiftUI

struct WelcomePageView: View {
 
    var body: some View {
       
        VStack {
            Image("back4")
                .resizable()
                .ignoresSafeArea()
            BottomView()
                .navigationBarBackButtonHidden()
            
        }
    }
}
struct BottomView: View {
    @State var signUpPage: Bool = false
    @State var signInPage: Bool = false
    var body: some View {
        VStack {
            Text("Welcome to the biggest sneakers store app")
                .font(.system(size: 28))
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .padding(.bottom,24)
            Button {
                signUpPage = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.black)
                        .frame(width: 358,height: 54)
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
            Button {
                signInPage = true
            } label: {
                Text("I already have an account")
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .padding(.top,24)
                    .padding(.bottom,6)
            }
            NavigationLink("", isActive: $signUpPage) {
                RegistrationPageView()
            }
            NavigationLink("", isActive: $signInPage) {
                AuthorizationView()
            }

        }
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}

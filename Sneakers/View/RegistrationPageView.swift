//
//  RegistrationPageView.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 31.05.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct RegistrationPageView: View {
    
    var body: some View {
     
            RegisterView()

        
        .navigationTitle("New User")
       

       
    }
}
struct RegisterView: View {
//    @FocusState private  var isUsernameFocused: Bool
//    @FocusState private var isPasswordFocused: Bool
    @State var username: String = ""
    @State var password: String = ""
    @State var isCatalogViewShow: Bool = false
    @AppStorage("uid") var userID: String = ""
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z]).{6,}$")
         
         return passwordRegex.evaluate(with: password)
     }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Email", text: $username)
                    .padding()
                    .frame(width: 315,height: 48)
                    .background(Color(red: 246/255, green: 246/255, blue: 246/255, opacity: 1))
                    .cornerRadius(4)
                    .padding([.top,.leading])
                    .accentColor(.black)
//                    .textFieldStyle(CustomTextFieldStyle(isFocused: isUsernameFocused))

                
                Spacer()
                if username != "" {
                    Image(systemName: username.isValidEmail() ? "checkmark" : "xmark" )
                        .resizable()
                        .frame(width: 15,height: 15)
                        .foregroundColor(username.isValidEmail() ? .green : .red)
                        .offset(x:-30)
                }
                    
            }.padding(.top,62)
            
            HStack {
                
                TextField("Password", text: $password)
                    .padding()
                    .frame(width: 315,height: 48)
                    .background(Color(red: 246/255, green: 246/255, blue: 246/255, opacity: 1))
                    .cornerRadius(4)
                    .padding([.top,.leading])
                    .accentColor(.black)
                Spacer()
                
                if password != "" {
                    Image(systemName: isValidPassword(password) ? "checkmark" : "xmark" )
                        .resizable()
                        .frame(width: 15,height: 15)
                        .foregroundColor(isValidPassword(password) ? .green : .red)
                        .offset(x:-30)
                }
            }
            Spacer()
            Button {
                Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    if let authResult = authResult {
                        print(authResult.user.uid)
                        userID = authResult.user.uid
                        
                    }
                }
                isCatalogViewShow = true
        
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
            NavigationLink("", destination: CatalogView(),isActive:$isCatalogViewShow)
            
        }
    }
    func register() {
        Auth.auth().createUser(withEmail: username, password: password) { result, error in
            if error != nil {
                print((error?.localizedDescription)!)
            }
            
        }
        
    }
}

//struct CustomTextFieldStyle: TextFieldStyle {
//    var isFocused: Bool
//
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .padding(.top,19)
//            .background(
//                RoundedRectangle(cornerRadius: 4)
//                    .stroke(isFocused ? Color(red: 246/255, green: 246/255, blue: 246/255, opacity: 1) : Color.black, lineWidth: 2)
//            )
//    }
//}
struct RegistrationPageView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPageView()
    }
}

//
//  AuthorizationView.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 31.05.2023.
//

import SwiftUI
import FirebaseAuth

struct AuthorizationView: View {
    @AppStorage("uid") var userID: String = ""

    var body: some View {
        VStack {
            if userID == "" {
                Authorization()
                    .navigationTitle("Welcome Back!")
                
            } else {
               
                CatalogView()
                    
                
                
                
                    
            }
        }
//        }.animation(.spring())
//            .onAppear {
//
//                NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
//
//                    let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
//                    self.status = status
//                }
//        }
//            .onDisappear {
//                NotificationCenter.default.addObserver(forName: NSNotification.Name("st"), object: nil, queue: .main) { (_) in
//
//                    let status = UserDefaults.standard.value(forKey: "st") as? Bool ?? false
//                    self.status = status
//                }
//            }
    }
}
struct Authorization: View {
    @FocusState private var isUsernameFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State var username: String = ""
    @State var password: String = ""
    @State var alert = false
    @State var message = ""
    @State var repeatPassword: String = ""
    @AppStorage("uid") var userID: String = ""
    @State var isCatalogShown = false
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
         
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
                
                SecureField("Password", text: $password)
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
                
                Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
                                     if let error = error {
                                         
                                         print(error)
                                         return
                                     }
                                     
                                     if let authResult = authResult {
                                         print(authResult.user.uid)
                                         withAnimation {
                                             userID = authResult.user.uid
                                             isCatalogShown = true
                                             
                                         }
                                     }
                                     
                                     
                                 }
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.black)
                        .frame(width: 358,height: 54)
                    Text("Sign In")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
            .alert(isPresented: $alert) {
                
                Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
        }
           
            
            NavigationLink("", destination: CatalogView(),isActive: $isCatalogShown)
            
            
        }
    }
    
    func signInWithEmail(email: String,password : String,completion: @escaping (Bool,String)->Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            
            if err != nil{
                
                completion(false,(err?.localizedDescription)!)
                return
            }
            
            completion(true,(res?.user.email)!)
        }
    }
   
   
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}

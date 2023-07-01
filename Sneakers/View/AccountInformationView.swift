//
//  AccountInformationView.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 10.06.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AccountInformationView: View {
    var body: some View {
       
            AccountInfo()
            .navigationBarBackButtonHidden()
        
        
    }
}
struct AccountInfo: View {
    @State var showingAlert = false
    @State var welcomePage = false
    @AppStorage("uid") var userID: String = ""
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .black
    }
    var body: some View {
        
        ZStack {
            Color(red: 246/255, green: 246/255, blue: 246/255)
                .ignoresSafeArea()
            VStack {
                
                List {
                    CustomCell( text: "Account Information", imageName: "chevron.right")
                    CustomCell( text: "Order History", imageName: "chevron.right")
                    CustomCell(text: "Shoe Size", imageName: "chevron.right")
                    Section("FAQ") {


                        CustomCell(text: "How to know your shoe size?", imageName: "arrow.up.right.square")
                        CustomCell(text: "How to check the authenticity of the shoe?", imageName: "arrow.up.right.square")
                    }
                    
                }
                
                .listStyle(.sidebar)
                Spacer()
                Button {
                    showingAlert = true
                   
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.black)
                            .frame(width: 358,height: 54)
                        Text("Sign Out")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure you want to sign out?"),
                          primaryButton: .default(Text("Confirm")){
                        let firebaseAuth = Auth.auth()
                                       do {
                                           try firebaseAuth.signOut()
                                           withAnimation {
                                               userID = ""
                                           }
                                       } catch let signOutError as NSError {
                                           print("Error signing out: %@", signOutError)
                                       }
                        welcomePage = true
                    },
                          secondaryButton:.cancel())
             }
                NavigationLink("", destination: WelcomePageView(), isActive: $welcomePage)
                    .navigationBarBackButtonHidden()
          }
        }
//        NavigationLink("", destination: WelcomePageView(), isActive: $welcomePage)
    }
}

struct CustomCell: View {
    
    @State var isClicked = false
    var text: String
    var imageName:String
    var body: some View {
        HStack {
            Button {
                isClicked.toggle()
            } label: {
                Text(text)
                    .foregroundColor(.black)
                    .padding()
                
            }
            Spacer()
            Image(systemName: imageName)
                .foregroundColor(Color(red: 60/255, green: 60/255, blue: 67/255,opacity: 0.3))
        }
       
        
         
    }
}



struct AccountInformationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInformationView()
    }
}

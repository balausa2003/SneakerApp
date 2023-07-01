//
//  CatalogView.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 31.05.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

enum Tabs: String {
    case home = "Hello, Sneakerhead!"
    case cart = "Cart"
    case profile = "Profile"
}
struct CatalogView: View {
    @State var selectedTab: Tabs = .home
   
   
   
    var body: some View {
        
            TabView(selection: $selectedTab) {
                Catalog()
                    .tabItem {
                        CustomItems(imageName:"house.fill", text:"Catalog")
                        Text("Hello")
                    }
                    .tag(Tabs.home)
                   
                CartPageView()
                    .tabItem {
                        CustomItems(imageName: "cart.fill", text: "Cart")
                    }
                    .tag(Tabs.cart)
                   
                AccountInformationView()
                    .tabItem {
                        CustomItems(imageName: "person.circle.fill", text: "Profile")
                    }
                    .tag(Tabs.profile)
            }
            .tint(.black)
            .scrollIndicators(.hidden)
            .navigationTitle(selectedTab.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()

    
    }
}
struct CustomItems: View {
    var imageName: String
    var text: String
    var body: some View {
        VStack {
            Image(systemName: imageName)
                
            Text(text)
        }
    }
}
struct Catalog: View {
    @ObservedObject var sneakers = APIManager()
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    @State var isButtonPressed:Bool = false
    var body: some View {
        ZStack {
            Color(red: 246/255, green: 246/255, blue: 246/255)
                .ignoresSafeArea()
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(sneakers.datas){ number in
                        Item(item: number)
                    }
                    .frame(width: 174,height: 330)
                    .background(Color.white)
                    .cornerRadius(4)
                    
                }
               
                .padding()
             
                
            }
        }
    }
}
 struct Item: View {
     var item: Sneakers
   @State var isSelected = false
    
     @Environment(\.presentationMode) var presentation
    var body: some View {
        VStack {
            WebImage(url: URL(string: item.pic))
                .resizable()
                .frame(width: 166,height: 166)
            HStack {
                Text(item.name)
                    .font(.system(size: 13))
                    .fontWeight(.semibold)
                    .padding(.leading,4)
                    .padding(.bottom,2)
                Spacer()
            }
            HStack {
                Text(item.desc)
                    .font(.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
                    .lineLimit(1)
                    .padding(.leading,4)
                    .padding(.bottom,4)
                Spacer()
            }
            HStack {
                Text("$\(item.price)")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .padding(.leading,4)
                Spacer()
            }
            Button {
                isSelected.toggle()
                let db = Firestore.firestore()
                if isSelected == true {
                    db.collection("cart")
                        .document()
                        .setData(
                            ["item": item.name,"quantity":1,
                             "desc": item.desc , "price":item.price,
                             "pic": item.pic]
                        ) { (err) in
                            
                            if err != nil {
                                print((err?.localizedDescription)!)
                                return
                            }
                            self.presentation.wrappedValue.dismiss()
                            
                            
                        }
                }
                else {
                    let ref = Database.database().reference()
                    let cartRef = ref.child("cart")
                    cartRef.child(item.id).removeValue()
                        
                    }
                
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.black)
                        .frame(width: 166,height: 40)
                        .opacity(isSelected ? 0.8 : 1)
                    Text(isSelected ? "Remove" : "Add to cart")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
        }
        
    }
    func numberOfItems(isPressed: Bool) -> String {
        var count: Int = 0
        if isPressed {
            count += 1
            return "\(count) •"
        }
        return ""
    }
    
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}

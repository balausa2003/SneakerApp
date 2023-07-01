//
//  CartPageView.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 02.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct CartPageView: View {
    @ObservedObject var cartItems = CartModel()
    
    var body: some View {
       
        if cartItems.isCartEmpty() {
            IsCartEmpty()
                           .navigationBarTitleDisplayMode(.inline)
                           .navigationBarBackButtonHidden()
        } else {
            CartItems()
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
        }
        //        if cartHasItems() {
        //
        //
        //        }
        //        if !cartHasItems() {
        //            IsCartEmpty()
        //                .navigationBarTitleDisplayMode(.inline)
        //                .navigationBarBackButtonHidden()
        //        }
        //    }
        //    func cartHasItems() -> Bool {
        //        return !cartItems.data.isEmpty
        //    }
    }
}

struct CartItems: View {
    @State private var showingAlert = false
    @State private var showingBottomSheet = false
    @ObservedObject var cartItems = CartModel()

    
    
    init() {
           UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .black
       }
    
    var body: some View {
        ZStack {
                Color(red: 246/255, green: 246/255, blue: 246/255)
                    .ignoresSafeArea()
            VStack {
                    List {
                        ForEach(cartItems.data) { item in
                            ItemsInCart(item: item)
                            
                        }
                        .onDelete{ (index) in
                          
                            let db = Firestore.firestore()
                            db.collection("cart").document(self.cartItems.data[index.last!].id).delete{(err) in
                                if err != nil {
                                    print((err?.localizedDescription)!)
                                    return
                                }
                                self.cartItems.data.remove(atOffsets: index)
                                
                               
                            }
                        }
                        TotalItem()
                    
                    .listStyle(.plain)
                   
                }
               
                
            
                    Spacer()
                    Button {
                        showingAlert = true
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.black)
                                .frame(width: 358,height: 54)
                            Text("Confirm Order")
                                .foregroundColor(.white)
                                
                        }
                    }
                   
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Proceed with payment"),
                              message: Text("Are you sure you want to confirm?"),
                              primaryButton: .default(Text("Confirm")) {showingBottomSheet = true
                                   
                        },
                              secondaryButton:.cancel())
                        
                    }
                    
                }
                .sheet(isPresented: $showingBottomSheet) {
                    BottomSheet()
                        .presentationDetents([.height(538)])
                }
               
            }
        }
   
    }

struct BottomSheet: View {
    @ObservedObject var cartModel = CartModel()
    @State var goToCatalogPage = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                    .ignoresSafeArea()
                    .foregroundColor(Color(red: 0.965, green: 0.965, blue: 0.965))
            VStack {
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 160,height: 160)
                            .foregroundColor(.white)
                        Image("img1")
                            .resizable()
                            .frame(width: 100,height: 100)
                    }
                    .offset(x: -52,y: 80)
                    
                    ZStack {
                        Circle()
                            .frame(width: 160,height: 160)
                            .foregroundColor(.white)
                        Image("img1")
                            .resizable()
                            .frame(width: 100,height: 100)
                    }
                    .offset(x:60,y:-20)
                }
               
                
                Text("Your order is succesfully placed. Thanks!")
                    .font(.system(size: 28,weight: .bold))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                 
                    .padding()
                Button {
                    
                   
                  
                    deleteCollection()
          
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.black)
                            .frame(width: 358,height: 54)
                        Text("Get back to shopping")
                            .foregroundColor(.white)
                    }
                }
                .padding()
               
               
            }
            VStack {
                
                    Image("back6")
                        .resizable()
                        .frame(width: 500,height: 200)
                        .ignoresSafeArea()
                   
                Spacer()
            }
          
        }
    }
    func deleteCollection() {
        let collectionRef = Firestore.firestore().collection("Cart")

           collectionRef.getDocuments { snapshot, error in
               if let error = error {
                   print("Error fetching documents: \(error)")
                   return
               }
               
               // Delete each document in the collection
               for document in snapshot!.documents {
                   document.reference.delete()
               }
               
               print("Collection deleted successfully.")
           }
       }
}

struct ItemsInCart: View {
    var item: Cart

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 0,height: 170)
                .foregroundColor(.white)
            
            HStack {
                WebImage(url: URL(string: item.pic))
                    .resizable()
                    .frame(width: 140,height: 140)
                    .cornerRadius(4)
                    .padding(.leading)
                    .padding([.top,.bottom],10)
                VStack {
                    HStack {
                        Text(item.item)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .padding(.bottom,2)
                            .padding(.top,21)
                            .padding(.leading)
                        Spacer()
                    }
                    HStack {
                        Text(item.desc)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .padding(.bottom,4)
                            .padding(.leading)
                        Spacer()
                    }
                    HStack {
                        Text("$\(item.price)")
                            .fontWeight(.bold)
                            .font(.system(size: 12))
                            .padding(.leading)
                            
                        Spacer()
                    }
                    CustomStepper(item:item)
                   
                    }
                
            }
                
        }
        
        
    }
}

struct CustomStepper: View {
    var item: Cart
    @State var count: Int = 1
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 160,height: 36)
            
            HStack {
                Button {
                    if count != 1 && count > 1 {
                        count -= 1
                        stepperValueChanged(item: item, newQuantity: count)
                    }
                } label: {
                    Image(systemName: "minus")
                    
                }
                .buttonStyle(BorderedButtonStyle())
                
                Text("\(count)")
                    .padding([.leading,.trailing],13)
                    .font(.system(size: 15))
                Button {
                    count += 1
                    stepperValueChanged(item: item, newQuantity: count)
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(BorderedButtonStyle())
            }
            
            .foregroundColor(.white)
        }
    }
    func stepperValueChanged(item: Cart, newQuantity: Int) {
        let db = Firestore.firestore()
        db.collection("cart").document(item.id).updateData(["quantity":newQuantity]) { (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
}
struct TotalItem: View {
    @ObservedObject var cartItems = CartModel()
 
    var body: some View {
        HStack {
            Text("\(countItems().0) items:   Total(Including Delivery)")
                
            Spacer()
            Text("$\(countItems().1)")
        }
    }
     func countItems() -> (Int,Int) {
         var count = 0
         var totalPrice = 0
        
         
        for item in cartItems.data {
           
            count += item.quantity
            totalPrice += item.quantity * item.price
        }
        
        return (count,totalPrice)
        
        
    }
}


struct IsCartEmpty: View {
    var body: some View {

            
            VStack {
                Image("back5")
                    .resizable()
                    .frame(height: 350)
                    .ignoresSafeArea()
          
                Text("Cart is empty")
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                Text("Find interesting models in the Catalog.")
                    .font(.system(size: 17))
                Spacer()
            
        }
    }
}

struct CartPageView_Previews: PreviewProvider {
    static var previews: some View {
        CartPageView()
    }
}

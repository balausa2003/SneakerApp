//
//  CartModel.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 17.06.2023.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

class CartModel: ObservableObject {
    @Published var data = [Cart]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("cart").addSnapshotListener { [self] snap, err in
            if err != nil {
                print((err?.localizedDescription)!)
                return 
            }
            
            for i in snap!.documentChanges {
                if i.type == .added {
                    let id = i.document.documentID
                    let item = i.document.get("item") as! String
                    let desc = i.document.get("desc") as! String
                    let price = i.document.get("price") as! Int
                    let pic = i.document.get("pic") as! String
                    let quantity = i.document.get("quantity") as! Int
                    
                    self.data.append(Cart(id: id, item: item, desc: desc, price: price, quantity: quantity, pic: pic))
                }
                if i.type == .modified {
                    let id = i.document.documentID
                    let quantity = i.document.get("quantity") as! NSNumber
                    for j in 0..<self.data.count {
                        if self.data[j].id == id {
                            self.data[j].quantity = Int(truncating: quantity)
                        }
                    }
                }
                
            }
        }
    }
    func isCartEmpty() -> Bool {
        return data.isEmpty
    }
    func removeAllItems() {
        return data.removeAll()
    }
}

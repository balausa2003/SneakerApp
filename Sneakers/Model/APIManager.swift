//
//  APIManager.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 15.06.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class APIManager: ObservableObject {
    @Published var datas = [Sneakers]()
    init() {
        let db = Firestore.firestore()
        db.collection("Sneakers").addSnapshotListener { [self] (snap,err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges {
                let id = i.document.documentID
                let name = i.document.get("name") as! String
                let desc = i.document.get("desc") as! String
                let price = i.document.get("price") as! Int
                let pic = i.document.get("pic") as! String
             
                
                self.datas.append(Sneakers(id: id, name: name, desc: desc, price: price, pic: pic))
            }
            
        }
    }
    
    
}

//class APIManager {
//
//    static let shared = APIManager()
//
//    private func configureFB() -> Firestore {
//        var db: Firestore!
//        let settings = FirestoreSettings()
//        Firestore.firestore().settings = settings
//        db = Firestore.firestore()
//        return db
//    }
//
//    func getPost(collection: String, docName: String, completion: @escaping (Document?) -> Void ) {
//        let db = configureFB()
//        db.collection(collection).document(docName).getDocument(completion: {(document , error) in
//            guard error == nil else {completion(nil); return}
//            let doc = Document(name: document?.get("name") as! String, description: document?.get("description") as! String, price: document?.get("price")as! Int)
//            completion(doc)
//        })
//
//    }
//    func getImage(picName: String, completion: @escaping (UIImage) -> Void) {
//        let storage = Storage.storage()
//        let reference = storage.reference()
//        let pathRef = reference.child("pictures")
//
//        var image: UIImage = UIImage(named: "img1")!
//
//        let fileRef = pathRef.child(picName + ".png")
//        fileRef.getData(maxSize: 1024*1024) { data, error in
//            guard error == nil else { completion(image); return}
//            image = UIImage(data: data!)!
//            completion(image)
//        }
//
//    }
//}

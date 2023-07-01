//
//  introPage.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 29.05.2023.
//

import Foundation

struct Page: Identifiable , Equatable {
    let id = UUID()
    var imageURL: String
    var tag: Int
    
    static var samplePage = Page(imageURL:"back1" , tag: 0)
    
    static var samplePages:[Page] = [
        Page(imageURL: "back1", tag: 0),
        Page(imageURL: "back2", tag: 1),
        Page(imageURL: "back3", tag: 2)
    
    ]
}

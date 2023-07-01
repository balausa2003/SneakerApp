//
//  CustomBottom.swift
//  Sneakers
//
//  Created by Балауса Косжанова on 31.05.2023.
//

import SwiftUI

struct CustomBottom: View {
    var text: String
    var body: some View {
        Button {
            
  
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.black)
                    .frame(width: 358,height: 54)
                Text(text)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

struct CustomBottom_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottom(text:"")
    }
}

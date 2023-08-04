//
//  Subtitle.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 10/16/22.
//

import Foundation
import SwiftUI

struct Subtitle : View {
    
    var text : String
    var weight: Font.Weight?
    var size : CGFloat?
    var alignment: TextAlignment?
    var textColor : Color?
    
    var body : some View {
        VStack{
            Text(text)
                .foregroundColor(textColor ?? .black)
                .font(.system(size: size ?? 16, weight: weight ?? .regular))
                .lineLimit(nil)
                .multilineTextAlignment(alignment ?? .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

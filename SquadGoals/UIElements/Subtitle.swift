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
    
    var body : some View {
        VStack{
            Text(text)
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .medium))
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

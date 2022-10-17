//
//  Title.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 1/9/22.
//

import Foundation
import SwiftUI

struct Title : View {
    
    var text : String
    
    var body : some View {
        VStack{
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 32, weight: .heavy))
                .lineLimit(nil)
                .multilineTextAlignment(.center)
        }
    }
}

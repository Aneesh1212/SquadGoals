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
    var lineLimit : Int?
    
    var body : some View {
        VStack{
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 32, weight: .heavy))
                .minimumScaleFactor(0.5)
                .lineLimit(lineLimit ?? 1)
                .multilineTextAlignment(.center)
        }
    }
}

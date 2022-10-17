//
//  WhiteActionButton.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 1/9/22.
//

import Foundation
import SwiftUI

struct WhiteActionButton : View {
    
    var text : String
    
    var body : some View {
        Text(text)
            .foregroundColor(Colors.blueText)
            .font(.system(size: 22))
            .frame(width: 300, height: 60, alignment: .center)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 15)
    }
    
}

//
//  WhiteActionButton.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 1/9/22.
//

import Foundation
import SwiftUI

struct TrailingViewHelper : View {
    
    var view : AnyView
    
    var body : some View {
        
        HStack {
            Spacer()
            view
        }
    }
}

//
//  LeftAligner.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 4/2/23.
//

import Foundation
import SwiftUI

struct LeftAligner: View {
    var content: AnyView
    
    var body : some View {
        HStack {
            content
            Spacer()
        }
    }
}

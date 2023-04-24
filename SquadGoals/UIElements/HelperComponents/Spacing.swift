//
//  Spacing.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 10/16/22.
//

import Foundation
import SwiftUI

struct Spacing : View {
    var height : CGFloat
    var body : some View {
        Spacer()
            .frame(height: height)
    }
}

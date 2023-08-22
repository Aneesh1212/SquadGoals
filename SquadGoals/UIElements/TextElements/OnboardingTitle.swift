//
//  OnboardingTitle.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 10/16/22.
//

import Foundation
import SwiftUI

struct OnboardingTitle : View {
    var text : String
    var body : some View {
        VStack{
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 36, weight: .heavy))
                .minimumScaleFactor(0.75)
                .lineLimit(1)
                .multilineTextAlignment(.center)
        }
    }
}

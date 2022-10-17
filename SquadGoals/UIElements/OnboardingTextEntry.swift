//
//  OnboardingTextEntry.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 10/16/22.
//

import Foundation
import SwiftUI

struct OnboardingTextEntry : View {
    
    var placeholder : String
    var value: Binding<String>
    
    var body : some View {
        TextField(
            placeholder,
            text: value
        )
            .font(.system(size: 20))
            .frame(height: 50, alignment: .center)
            .padding(.leading, 15)
            .background(Colors.lightOrangeBackground)
            .cornerRadius(5)
            .foregroundColor(.black)
    }
}

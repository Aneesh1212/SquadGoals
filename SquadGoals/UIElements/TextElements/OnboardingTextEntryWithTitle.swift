//
//  OnboardingTextEntry.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 10/16/22.
//

import Foundation
import SwiftUI

struct OnboardingTextEntryWithTitle : View {
    
    var title: String
    var placeholder : String
    var value: Binding<String>
    
    var body : some View {
        VStack(alignment: .leading, spacing: 2){
            Text(title)
                .foregroundColor(Colors.lightOrangeBackground)
            
            TextField(
                placeholder,
                text: value
            )
                .font(.system(size: 20))
                .frame(height: 50, alignment: .center)
                .fixedSize(horizontal: false, vertical: false)
                .foregroundColor(.black)
                .padding(.leading, 15)
                .background(Color.white)
                .cornerRadius(10)
                .lineLimit(nil)
        }
    }
}

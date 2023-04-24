//
//  RedActionButton.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 4/2/23.
//

import SwiftUI
struct RedActionButton : View {
    
    var text : String
    var action: () -> Void
    
    var body : some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .frame(height: 45, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(Colors.buttonRed)
                .cornerRadius(15)
        })
    }
}

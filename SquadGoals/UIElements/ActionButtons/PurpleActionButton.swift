//
//  PurpleActionButton.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 3/28/23.
//

import SwiftUI
struct PurpleActionButton : View {
    
    var text : String
    var action: () -> Void
    
    var body : some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .frame(height: 25, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(Colors.buttonPurple)
                .cornerRadius(15)
        })
    }
}

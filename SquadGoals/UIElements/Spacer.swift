//
//  Spacer.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 10/16/22.
//

import Foundation
struct Spacing : View {
    var action : () -> Void
    var text: String
    var body : some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.white)
                .frame(width: 250, height: 40, alignment: .center)
                .background(Colors.blueText)
                .cornerRadius(15)
                .shadow(radius: 5)
        })
    }
}

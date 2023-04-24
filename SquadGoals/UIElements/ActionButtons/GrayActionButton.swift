//
//  GrayActionButton.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 3/29/23.
//
import SwiftUI

struct GrayActionButton : View {
    
    var text : String
    var action : () -> Void
    
    var body : some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .medium))
                .frame(height: 45, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(.gray)
                .cornerRadius(15)
        })
    }
}

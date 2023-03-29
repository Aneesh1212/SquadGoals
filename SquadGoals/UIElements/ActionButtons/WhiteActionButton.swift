//
//  WhiteActionButton.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 3/28/23.
//
import SwiftUI

struct WhiteActionButton : View {
    
    var text : String
    var action : () -> Void
    
    var body : some View {
        Button(action: action, label: {
            HStack{
                Text(text)
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Text(">")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding()
            .frame(height: 60, alignment: .center)
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(15)
        })
    }
}

//
//  WhiteCard.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 3/27/23.
//
import SwiftUI

struct WhiteCard<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(content: content)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(20)
    }
}

//
//  WhiteCard.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 3/27/23.
//
import SwiftUI

struct WhiteCard<Content: View>: View {
    var verticalPadding: CGFloat
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content, verticalPadding: CGFloat = Styling.smallUnit) {
        self.content = content
        self.verticalPadding = verticalPadding
    }

    var body: some View {
        VStack(content: content)
            .padding(.horizontal)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(20)
    }
}

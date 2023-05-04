//
//  GreenCard.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 5/3/23.
//

import SwiftUI

struct GreenCard<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(content: content)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Colors.buttonGreen)
            .cornerRadius(20)
    }
}


//
//  LightBlueCard.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 5/2/23.
//

import SwiftUI

struct LightBlueCard<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(content: content)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Colors.buttonLightBlue)
            .cornerRadius(20)
    }
}

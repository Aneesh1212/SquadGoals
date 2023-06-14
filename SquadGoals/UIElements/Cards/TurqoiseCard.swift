//
//  TurqoiseCard.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 5/2/23.
//

import SwiftUI

struct TurqoiseCard<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(content: content)
            .padding(.vertical, Styling.smallUnit)
            .frame(maxWidth: .infinity)
            .background(Colors.turqoiseBackground)
            .cornerRadius(20)
    }
}

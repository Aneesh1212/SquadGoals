//
//  Tutorial1.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct Tutorial1: View {
    
    @State var navigateToTutorial2 = false
    var user: User
    let count = 1
    let subtitle = "Choose 1-3 personal goals to progress and track over the next few months. Here are some examples for inspiration."
    let image = "Tutorial1"
    func onClick() {
        navigateToTutorial2 = true
    }
    
    var body: some View {
        NavigationLink(destination: Tutorial2(user: self.user), isActive: $navigateToTutorial2) { EmptyView() }
        // BaseTutorial(count: count, subtitle: subtitle, image: image, onClick: onClick)
    }
}

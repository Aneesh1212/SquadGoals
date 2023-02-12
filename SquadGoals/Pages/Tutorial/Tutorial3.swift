//
//  Tutorial2.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct Tutorial3: View {
    
    @State var navigateToCreateGoal = false
    let count = 3
    let subtitle = "Cross off the tasks as you complete them to make progress. Monitor how your friends are doing and hold them accountable!"
    let image = "Tutorial3"
    func onClick() {
        navigateToCreateGoal = true
    }
    
    var body: some View {
        NavigationLink(destination: CreateGoal(isSingleGoal: false), isActive: $navigateToCreateGoal) { EmptyView() }
        //BaseTutorial(count: count, subtitle: subtitle, image: image, onClick: onClick)
    }
}

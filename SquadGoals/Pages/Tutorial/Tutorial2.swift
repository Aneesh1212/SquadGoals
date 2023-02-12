//
//  Tutorial2.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct Tutorial2: View {
    
    @State var navigateToTutorial3 = false
    let count = 2
    let subtitle = "Every week, you will create subtasks for these goals. These can remain consistent or adjust to fit your schedule."
    let image = "Tutorial2"
    func onClick() {
        navigateToTutorial3 = true
    }
    
    var body: some View {
        NavigationLink(destination: Tutorial3(), isActive: $navigateToTutorial3) { EmptyView() }
        // BaseTutorial(count: count, subtitle: subtitle, image: image, onClick: onClick)
    }
}

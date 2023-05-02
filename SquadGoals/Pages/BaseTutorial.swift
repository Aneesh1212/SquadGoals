//
//  BaseTutorial.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct BaseTutorial: View {
    
    var user : User
    @State var count = 0
    @State var navigateToCreateGoal = false
    
    let images = ["Tutorial1New", "Tutorial2New", "Tutorial3New", "Tutorial4New"]
    let subtitles = [
        "Choose 1-3 personal goals to progress and track over the next few months. Here are some examples for inspiration.",
        "Every week, you will break down your goals into tasks. Some tasks you do just once, like Editing a Resume, and some are recurring like Meditate 7x/week.",
        "When you finish a task, cross it off on the Homepage to show off to your friends and make progress towards the Finish Line.",
        "Track the progress of your squad, and their contribution to your team score. Send them a congrats or motivational push notification to keep them accountable."
    ]
    
    func incrementStepper() -> Void {
        if (count < 3) {
            count += 1
        } else {
            navigateToCreateGoal = true
        }
    }
    
    var body: some View {
        VStack (spacing: 4){
            HStack(alignment: .top) {
                Image(uiImage: UIImage(named: "megaphone")!)
                    .resizable()
                    .frame(width: 28.0, height: 28.0)
                
                Title(text: "How It Works")
            }
            Spacing(height:Styling.extraSmallUnit)
            Subtitle(text: subtitles[count], size: 14)
            
            Spacer()
            
            Image(uiImage: UIImage(named: images[count])!)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Filler()
            
            BlueActionButton(text: count < 3 ? "Next" : "Got It", action: incrementStepper)
                .padding(.bottom, 6)
            
            CarouselCounter(count: count + 1)
            
            NavigationLink(destination: CreateGoal(user: self.user, isSingleGoal: false), isActive: $navigateToCreateGoal) { EmptyView() }
            
        }
        .padding(.horizontal, 16)
        .background(Colors.background)
    }
}

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
    
    let images = ["Tutorial1", "Tutorial2", "Tutorial3", "Tutorial4"]
    let subtitles = [
        "Choose 1-3 personal goals to progress and track over the next few months. Here are some examples for inspiration.",
        "Every week, you will break down your goals into tasks. Some tasks you do just once, like Editing a Resume, and some are recurring like Meditate 7x/week.",
        "When you finish a task, cross it off on the Homepage to show off to your friends and make progress towards the Finish Line.",
        "Track the progress of your squad, and their contribution to your team score. Send them a congrats or motivational push notification to keep them accountable."
    ]
    
    var body: some View {
        VStack (spacing: 4){
            HStack(alignment: .top) {
                Image(uiImage: UIImage(named: "megaphone")!)
                    .resizable()
                    .frame(width: 28.0, height: 28.0)
                
                Text("HOW IT WORKS")
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(Colors.lightOrangeBackground)
            }
            
            Text("STEP \(String(count + 1))")
                .font(.system(size: 16, weight: .heavy))
                .foregroundColor(Colors.lightOrangeBackground)
                .padding(.bottom, 24)
            
            Text(subtitles[count])
                .font(.system(size: 16))
                .foregroundColor(Colors.lightOrangeBackground)
                .padding(.bottom, 24)
            
            Image(uiImage: UIImage(named: images[count])!)
                .resizable()
            
            Spacer()
            
            Button(action: {
                if (count < 3) {
                    count += 1
                } else {
                    navigateToCreateGoal = true
                }
            }) {
                Text(count < 3 ? "NEXT" : "GOT IT")
                    .foregroundColor(Colors.lightOrangeBackground)
                    .font(.system(size: 22))
                    .frame(width: 160, height: 40, alignment: .center)
                    .background(Colors.blueText)
                    .cornerRadius(20)
                    .padding(.bottom, 8)
                    .shadow(radius: 5)
            }
            
            CarouselCounter(count: count + 1)
            
            HStack {
                Spacer()
            }
            
            NavigationLink(destination: CreateGoal(user: self.user, isSingleGoal: false), isActive: $navigateToCreateGoal) { EmptyView() }
            
        }
        .padding(.horizontal, 16)
        .background(Colors.darkOrangeForeground)
    }
}

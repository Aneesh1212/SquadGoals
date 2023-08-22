//
//  InviteFriendsComponent.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 5/3/23.
//

import UIKit
import SwiftUI

struct InviteFriendsComponent2: View {
    @Binding var shareText: ShareText?
    var groupId: String

    var body: some View {
        WhiteCard {
            VStack(spacing: 12) {

                Subtitle(text: "Your teammate", weight: .bold, textColor: .gray)
                
                ZStack{
                    Circle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [3]))
                        .foregroundColor(.gray)
                        .background(Circle().fill(Colors.lightOrangeBackground))
                        .frame(width: 60, height: 60)
                    Image(systemName: "plus")
                        .font(.title2)
                        .imageScale(.medium)
                        .foregroundColor(.gray)
                }

                GreenActionButton(text: "Add", action: {
                    shareText = ShareText(text: "https://apps.apple.com/us/app/squadgoals/id1603697577")
                }, height: 32, textColor: .white)
                
                Text("TEAM #\(groupId)")
                    .underline()
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
    }
}

// 1. Activity View
struct ActivityView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

// 2. Share Text
struct ShareText: Identifiable {
    let id = UUID()
    let text: String
}

//
//  InviteFriendsComponent.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 5/3/23.
//

import UIKit
import SwiftUI

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

struct InviteFriendsComponent: View {
    @State var shareText: ShareText?
    var groupId: String

    var body: some View {
        GreenCard {
            VStack(spacing: Styling.smallUnit) {

                Text("Add more Teammates to your Squad \n Group ID: \(Text(groupId).underline())")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.center)

                PurpleActionButton(text: "Invite a friend", height: 42, action: {
                    shareText = ShareText(text: "https://apps.apple.com/us/app/squadgoals/id1603697577")
                })
                .padding(.horizontal, Styling.largeUnit)
            }
            .padding(.vertical, 16)
            .padding(.bottom, 16)
        }
        .sheet(item: $shareText) { shareText in
            ActivityView(text: shareText.text)
        }
    }
}


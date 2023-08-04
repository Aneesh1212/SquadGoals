//
//  EmptyState.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 5/3/23.
//
import UIKit
import SwiftUI

struct EmptyState: View {
    var body: some View {
        VStack {
            Spacer()

            TurqoiseCard {
                VStack(spacing:0) {
                    Subtitle(text: "Almost there!", weight: .medium, size: 20)
                        .padding(.bottom, 0)

                    Image(uiImage: UIImage(named: "almost_there")!)
                        .resizable()
                        .padding()
                        .aspectRatio(contentMode: .fit)

                    Subtitle(text: "Visit the Profile Tab to Add Goals \n or \n Click Edit tasks to add Tasks", weight: .regular, size: 15, alignment: .center)
                }
            }

            Spacer()
            Spacer()
        }
    }
}

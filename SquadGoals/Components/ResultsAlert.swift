//
//  ResultsAlert.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 7/18/22.
//
import SwiftUI
import Foundation
import UIKit

struct ResultsAlert: View {
    
    @Binding var shown: Bool
    @Binding var showReflectionModal: Bool
    @Binding var showBanner : Bool
    @StateObject var viewModel : GoalViewModel
    @Binding var tab : Int
    
    var body: some View {
        VStack {
            Spacer()
            Text("TEAM SUMMARY").foregroundColor(Colors.blueText).fontWeight(.heavy)
            Spacer()
                .frame(height:20)
            ForEach(self.viewModel.teammateStrings, id: \.self) { teammateString in
                Text(teammateString).foregroundColor(Colors.blueText).padding(.bottom, 3)
            }
            Spacer()
                .frame(height:20)
            HStack {
                Button("Review Week") {
                    showBanner = true
                    shown.toggle()
                }
                .fixedSize(horizontal: true, vertical: true)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 3)
                .background(Colors.blueText)
                .cornerRadius(15)
                            
                Button("Continue") {
                    shown.toggle()
                    showReflectionModal = true
                }
                .fixedSize(horizontal: true, vertical: true)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 3)
                .background(Colors.blueText)
                .cornerRadius(15)
            }
        }
        .padding(.vertical, 10)
        .frame(width: UIScreen.main.bounds.width-75)
        .fixedSize(horizontal: false, vertical: true)
        .background(Colors.lightOrangeBackground)
        .cornerRadius(5)
        .clipped()
        .border(Colors.blueText, width: 2)
        
    }
}

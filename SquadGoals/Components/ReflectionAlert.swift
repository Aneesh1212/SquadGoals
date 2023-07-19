//
//  ResultsAlert.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 7/18/22.
//
import SwiftUI
import Foundation
import UIKit

struct ReflectionAlert: View {
    
    var viewModel : GoalViewModel
    @Binding var shown : Bool
    @State var navigateToReflection = false
    @State var navigateToMondayPlanning = false
    
    
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Weekly Reflection").foregroundColor(Colors.blueText).fontWeight(.heavy)
            Spacer()
                .frame(height:20)
            Text("Jot a few reflections down from this week").foregroundColor(Colors.blueText).multilineTextAlignment(.center)
            Spacer()
                .frame(height:30)
        
            Button("Reflect") {
                navigateToReflection = true
            }
            .fixedSize(horizontal: true, vertical: true)
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 3)
            .background(Colors.blueText)
            .cornerRadius(15)
            
            Button("Skip") {
                navigateToMondayPlanning = true
            }
            .fixedSize(horizontal: true, vertical: true)
            .foregroundColor(Colors.blueText)
            .padding(.horizontal)
            .padding(.vertical, 3)
            .cornerRadius(15)
            .background(.white)
            .buttonBorderShape(.automatic)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Colors.blueText, lineWidth: 2)
            )
            
            NavigationLink(destination: MondayReflection(viewModel: self.viewModel), isActive: $navigateToReflection) { EmptyView() }
            
            NavigationLink(destination: MondayPlanning(viewModel: self.viewModel, mode: Mode.weekly), isActive: $navigateToMondayPlanning) { EmptyView() }
            
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

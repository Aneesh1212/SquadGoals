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
    @Binding var showBanner : Bool
    @StateObject var viewModel : GoalViewModel
    @State var navigateToMondayPlanning = false
    @State private var maxWidth: CGFloat = .zero
    
    var body: some View {
        WhiteCard {
            Title(text: "Team Summary")
            
            ForEach(self.viewModel.teammatePercentages.sorted(by: >), id: \.key) { name, percentage in
                HStack{
                    Subtitle(text: "\(name) completed", weight: .semibold)
                    Spacer()
                    Subtitle(text: "\(String(Int(percentage * 100)))%", weight: .semibold)
                }
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
            }
                
                HStack{
                    BlueActionButton(text: "Review Week", action: {
                        showBanner = true
                        shown.toggle()
                    })
                    OrangeActionButton(text: "Continue", action: {
                        navigateToMondayPlanning = true
                    })
                }
                
                GrayActionButton(text: "Cancel", action: {
                    showBanner = true
                    shown.toggle()
                })
                
                NavigationLink(destination: MondayPlanning(user: self.viewModel.user, viewModel:self.viewModel, mode: Mode.weekly), isActive: $navigateToMondayPlanning) { EmptyView() }
            }
            .padding(.horizontal, 25)
        }
    
    
    private func rectReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { gp -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = max(binding.wrappedValue, gp.frame(in: .local).width)
            }
            return Color.clear
        }
    }
}

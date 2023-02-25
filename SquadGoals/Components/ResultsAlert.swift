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
    @EnvironmentObject var userSession : UserSession
    @State var navigateToMondayPlanning = false
    @State private var maxWidth: CGFloat = .zero
    
    var body: some View {
        VStack {
            Spacer()
            Text("TEAM SUMMARY").foregroundColor(Colors.blueText).fontWeight(.heavy)
            Spacer()
                .frame(height:20)
            ForEach(userSession.teammateStrings, id: \.self) { teammateString in
                Text(teammateString).foregroundColor(Colors.blueText).padding(.bottom, 3)
            }
            Spacer()
                .frame(height:20)
            Button("Review this Week") {
                showBanner = true
                shown.toggle()
            }
            .fixedSize(horizontal: true, vertical: true)
            .foregroundColor(Colors.blueText)
            .padding(.horizontal)
            .padding(.vertical, 3)
            .cornerRadius(15)
            .background(rectReader($maxWidth))
            .frame(minWidth: maxWidth)
            .background(.white)
            .buttonBorderShape(.automatic)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Colors.blueText, lineWidth: 1)
            )
            
            Button("Continue to Next Week") {
                navigateToMondayPlanning = true
            }
            .fixedSize(horizontal: true, vertical: true)
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 3)
            .background(rectReader($maxWidth))
            .frame(minWidth: maxWidth)
            .background(Colors.blueText)
            .cornerRadius(15)
            .shadow(color: .gray, radius: 2, x: 0.0, y: 4.0)
            
            Spacer()
            
            NavigationLink(destination: MondayPlanning(mode: Mode.weekly), isActive: $navigateToMondayPlanning) { EmptyView() }
        }
        .padding(.vertical, 20)
        .frame(width: UIScreen.main.bounds.width-75)
        .fixedSize(horizontal: false, vertical: true)
        .background(Colors.lightOrangeBackground)
        .clipped()
        .border(Colors.blueText, width: 2)
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

//
//  Banner.swift
//  BannersSwiftUI
//
//  Created by Jean-Marc Boullianne on 11/30/19.
//  Copyright © 2019 Jean-Marc Boullianne. All rights reserved.
//
import SwiftUI

struct BannerModifier: View {
    
    var user : User
    @Binding var tab : Int
    @State var navigateToPlanning = false
    
    var body : some View {
        
        NavigationLink(destination: MondayPlanning(user: self.user, viewModel: GoalViewModel(user:self.user), mode: Mode.weekly), isActive: $navigateToPlanning) { EmptyView() }
        
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Congrats on the week!")
                        .bold()
                    Text("Click here to visit the Monday Planning page to create your new weekly goals")
                        .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                }
                Spacer()
            }
            .foregroundColor(Color.white)
            .padding(12)
            .background(Color(red: 67/255, green: 154/255, blue: 215/255))
            .cornerRadius(8)
        }
        .animation(.easeInOut)
        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
        .padding(.horizontal)
        .padding(.bottom, 4)
        .background(tab == 1 ? Colors.lightOrangeBackground : Colors.darkOrangeForeground)
        .onTapGesture {
            self.navigateToPlanning = true
        }
    }
    
}

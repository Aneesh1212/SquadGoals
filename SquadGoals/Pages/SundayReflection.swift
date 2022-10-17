//
//  SundayReflection.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct SundayReflection: View {
    
    @State var user : User
    @State var navigateToPlanning = false
    @State var wentWell : String = ""
    @State var improve : String = ""
    @State var reflection : String = ""
    @State var satisfaction : String = ""
    @State private var number = 7.0
    
    let dataArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    var wentWellView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What went well this week?")
                .foregroundColor(Colors.lightOrangeBackground)
                .padding(.bottom, 5)
            TextEditor(
                text: $wentWell
            )
            .font(.system(size: 20))
            .frame(height: 60, alignment: .center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 15)
            .background(Color.white)
            Spacer()
                .frame(height: 16)
        }
    }
    
    var improveView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What could you improve? (optional)")
                .foregroundColor(Colors.lightOrangeBackground)
                .padding(.bottom, 5)
            TextEditor(
                text: $improve
            )
            .font(.system(size: 20))
            .frame(height: 60, alignment: .center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 15)
            .background(Color.white)
            Spacer()
                .frame(height: 16)
        }
    }
    
    var reflectionView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Notable Reflections? (optional)")
                .foregroundColor(Colors.lightOrangeBackground)
                .padding(.bottom, 5)
            TextEditor(
                text: $reflection
            )
            .font(.system(size: 20))
            .frame(height: 90, alignment: .center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 15)
            .background(Color.white)
            Spacer()
                .frame(height: 16)
        }
    }
    
    var satisfactionView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Rate your satisfaction with this week")
                .foregroundColor(Colors.lightOrangeBackground)
                .padding(.bottom, 5)
            
            Slider(
                value: $number,
                in: 1...10,
                step: 1
            ) {
                Text("Speed")
            } minimumValueLabel: {
                Text("1")
            } maximumValueLabel: {
                Text("10")
            } .foregroundColor(.white)
            
            HStack{
                Spacer()
                Text("\(Int(number))")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)
                Spacer()
            }

            Spacer()
                .frame(height: 16)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("SUNDAY REFLECTION")
                .multilineTextAlignment(.leading)
                .font(.system(size: 30, weight: .heavy))
                .padding(.bottom, 15)
                .foregroundColor(Colors.lightOrangeBackground)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Every week is a new chance to become smarter on how we approach our goals")
                .multilineTextAlignment(.leading)
                .font(.system(size: 20))
                .padding(.bottom, 30)
                .foregroundColor(Colors.lightOrangeBackground)
                .fixedSize(horizontal: false, vertical: true)
            
            NavigationLink(destination: SundayPlanning(user: self.user, viewModel: GoalViewModel(user:self.user), mode: Mode.weekly), isActive: $navigateToPlanning) { EmptyView() }
            
            VStack(alignment: .leading) {
                wentWellView
                improveView
                reflectionView
                satisfactionView
            }
            
            Spacer()
                .frame(height: 50)
            
            HStack {
                Spacer()
                Button(action: {
                    self.navigateToPlanning = true
                }) {
                    Text("Share")
                        .foregroundColor(Colors.lightOrangeBackground)
                        .font(.system(size: 22))
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Colors.blueText)
                        .cornerRadius(15)
                }
                Spacer()
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 25)
        .background(Colors.darkOrangeForeground)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

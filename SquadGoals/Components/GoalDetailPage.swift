//
//  GoalAdded.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct GoalDetailPage: View {
    
    @State var goal : Goal
    var viewModel : GoalViewModel
    var sortedDates : Array<Date> = []
    @State var shouldNavigateToEditGoal = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ViewBuilder func getView(date : String, targets : Array<Target>) -> some View {
        
        let completedTargets = UtilFunctions.calculateCompletedTargetsFromTarget(targets: targets)
        let totalTargets = UtilFunctions.calculateTotalTargetsFromTarget(targets: targets)
        
        VStack(alignment: .leading) {
            VStack {
                Subtitle(text: "\(String(date)) - \(String(completedTargets)) / \(String(totalTargets)) this week")
            }
            
            VStack(alignment: .leading, spacing:0) {
                ForEach(targets, id: \.self) { target in
                    let finished : Int = target.original - target.frequency
                    let unfinished : Int = target.frequency
                    ForEach(0..<finished, id: \.self) { _ in
                        HStack(spacing : 0){
                            Text(target.title)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "checkmark")
                                .resizable()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .background(Color.green)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .background(Rectangle().fill(.white).shadow(radius: 3))
                        .opacity(0.8)
                    }
                    ForEach(0..<unfinished, id: \.self) { _ in
                        HStack(spacing : 0){
                            Text(target.title)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .background(Rectangle().fill(.white).shadow(radius: 3))
                    }
                }
            }.border(.gray, width: 0.5)
        }
    }
    
    var body: some View {
        NavigationLink(destination: EditGoal(viewModel: self.viewModel, goal: self.$goal), isActive: $shouldNavigateToEditGoal) { EmptyView() }
        
        VStack(spacing:0){
            BlueCard {
                HStack(alignment: .top) {
                    TitleV2(text: goal.title, lineLimit: 2, size: 28, shouldLeftAlign: true)
                    Spacer()
                    PillActionButton(text: "Edit Goal", icon: "pencil", foregroundColor: .white, backgroundColor: Colors.opaqueWhite, action: {
                        shouldNavigateToEditGoal = true
                    })
                }
                Spacing(height: Styling.smallUnit)
                HStack{
                    SubtitleV2(text: "Current Momentum:🔥\(String(goal.momentumScore))")
                    Spacer()
                    SubtitleV2(text: "Record:🔥\(String(goal.recordMomentum))")
                }
            }
            
            Spacing(height: Styling.mediumUnit)
            
            ScrollView(showsIndicators: false){
                LeftAligner(content: AnyView(SubtitleV2(text: "Accomplished Past Targets", weight: .semibold)))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Colors.darkOrangeForeground)
                    .cornerRadius(50)
                ForEach(self.goal.pastTargets.keys.sorted{
                    $0 > $1
                }, id: \.self) {pastTargetDate in
                    getView(date: goodFormat(date: pastTargetDate), targets: self.goal.pastTargets[pastTargetDate] ?? [])
                }
            }
            
            RedActionButton(text:"Delete Goal", action: {
                self.presentationMode.wrappedValue.dismiss()
                viewModel.deleteGoal(goalKey: goal.key)
            })
            .padding(.vertical, Styling.smallUnit)
        }
        .padding(.horizontal, 25)
        .background(Colors.background)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

func goodFormat(date : Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d"
    dateFormatter.dateStyle = .medium
    return dateFormatter.string(from: date)
}

/*ZStack{
 Image(uiImage: UIImage(named: "completion_badge_light")!)
 .resizable()
 .offset(y: 10)
 Text("\(String(completedTargets)) / \(String(totalTargets)) \n TARGETS \n COMPLETED")
 .foregroundColor(Colors.blueText)
 .font(.system(size: 17))
 .multilineTextAlignment(.center)
 }
 .frame(width: 175.0, height: 150.0)
 .padding(.bottom, 20)*/

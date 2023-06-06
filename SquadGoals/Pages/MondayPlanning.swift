//
//  GoalAdded.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI
import Firebase

enum Mode {
    case editing, initial, weekly
}
struct MondayPlanning: View {
    
    @State var user : User
    @StateObject var viewModel : GoalViewModel
    var mode: Mode
    @State var navigateToHome = false
    @State var showEditWarning = false
    @State var submitClicked = false
    @State var goals : Array<Goal> = []
    @State var titles : [[String]] = []
    @State var frequencies : [[String]] = []
    @State var completedNums : [[Int]] = []
    @State var keys : [[String]] = []
    var ref = Database.database().reference()
    @State var showExample : Bool = false
    
    var frequencyOptions : Array<String> = ["Once", "2x", "3x", "4x", "5x", "6x", "7x"]
    
    var targetEntryTable : some View {
        VStack(spacing: 24) {
            ForEach(0..<self.goals.count, id: \.self) { goalIndex in
                TestTable(goalKey: goals[goalIndex].key, goalTitle: goals[goalIndex].title, titles: $titles[goalIndex], frequencies: $frequencies[goalIndex], completedNums: $completedNums[goalIndex], keys: $keys[goalIndex], showToolTip: goalIndex == 0 && mode == Mode.initial)
                    .zIndex(Double(self.goals.count - goalIndex))
            }
        }
        .padding(.bottom, 30)
    }
    
    func saveGoals() {
        for goalIndex in 0..<goals.count {
            let goal = goals[goalIndex]
            for targetIndex in 0..<titles[goalIndex].count {
                let targetTitle = titles[goalIndex][targetIndex]
                let targetFrequencyString = frequencies[goalIndex][targetIndex]
                let targetKey = keys[goalIndex][targetIndex]
                let targetFrequency = UtilFunctions.convertFrequencyToNum(frequencyWord: targetFrequencyString)
                let targetCompletedNum = completedNums[goalIndex][targetIndex]
                let newTarget = Target(title: targetTitle, frequency: max(targetFrequency - targetCompletedNum, 0), original: targetFrequency, key: targetKey)
                if (targetTitle != "") {
                    viewModel.createTargets(goalId: goal.key, targets: [newTarget])
                }
            }
        }
    }
    
    func loadPastTargets(user: User, justGoals: Bool, newGoals: Bool) {
        self.goals = []
        self.titles = []
        self.frequencies = []
        self.completedNums = []
        self.keys = []
        for goal in user.goals {
            self.goals.append(goal)
            var currentTitles : [String] = []
            var currentFrequencies : [String] = []
            var currentCompletedNums : [Int] = []
            var currentKeys : [String] = []
            if (!justGoals) {
                for currentTarget in goal.currTargets {
                    let targetsRef = self.ref.child("targets").child(goal.key)
                    let targetKey = targetsRef.childByAutoId().key ?? ""
                    currentTitles.append(currentTarget.title)
                    if newGoals {
                        currentKeys.append(targetKey)
                        currentCompletedNums.append(0)
                    } else {
                        currentKeys.append(currentTarget.key)
                        currentCompletedNums.append(currentTarget.original - currentTarget.frequency)
                    }
                    currentFrequencies.append(UtilFunctions.convertFrequencyToString(frequency: currentTarget.original))
                }
            }
            self.titles.append(currentTitles)
            self.frequencies.append(currentFrequencies)
            self.completedNums.append(currentCompletedNums)
            self.keys.append(currentKeys)
        }
    }
    
    func getTitleString() -> String {
        switch(mode) {
        case .editing:
            return "Edit Weekly Tasks"
        case .weekly:
            return "Monday Planning"
        case .initial:
            return "Enter Weekly Tasks"
        }
    }
    
    var body: some View {
        ZStack{
            VStack() {
                OrangeCard{
                    VStack(spacing: 6){
                        TitleV2(text:getTitleString())
                        SubtitleV2(text: "Break down each goal into smaller tasks to complete this week.")
                        SubtitleV2(text: "These will clear every Sunday at midnight.")
                    }
                }
                
                if (mode == Mode.weekly) {
                    GreenActionButton(text: "Load Past Targets", action: {
                        loadPastTargets(user: self.viewModel.user, justGoals: false, newGoals: true)
                    })
                }
                
                if (mode == Mode.initial) {
                    GreenActionButton(text: "Show Example", action: {
                        showExample.toggle()
                    })
                }
                
                ScrollView {
                    targetEntryTable
                        .onChange(of: self.viewModel.user) { value in
                            loadPastTargets(user: value, justGoals: (mode == Mode.weekly), newGoals:false)
                        }
                        .padding(.top, 10)
                }
                
                BlueActionButton(text:"Submit all", action: {
                    self.showEditWarning = true
                })
                                
                NavigationLink(destination: Main(user: self.user, showReflection: false), isActive: $navigateToHome) { EmptyView() }
            }
            .padding(.horizontal, Styling.mediumUnit)
            .padding(.bottom, Styling.extraSmallUnit)
            .overlay(Color.gray.opacity(showExample ? 0.6 : 0.0))
            .background(Colors.background)
            
            if (showExample) {
                ExampleTargetsModal(shown: $showExample)
            }
        }
        .alert("Weekly tasks are cleared every Sunday at Midnight. Please ensure your tasks fit this timeline", isPresented: $showEditWarning) {
            Button("Submit") {
                self.navigateToHome = true
                let defaults = UserDefaults.standard
                let previousMonday = Calendar(identifier: .gregorian).startOfDay(for: Date.today().previous(.monday, considerToday: true))
                defaults.set(previousMonday, forKey: "lastSetMonday")
                saveGoals()
            }
            Button("Edit", role: .cancel) { self.showEditWarning = false }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            Task {
                self.viewModel.getGoals(phoneNumber: user.phoneNumber, isMondayPlanning: true)
            }
        }
    }
}


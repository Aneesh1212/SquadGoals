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
    @EnvironmentObject var viewModel : GoalViewModel
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
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
    }
    
    func saveGoals() {
        for goalIndex in 0..<goals.count {
            let goal = goals[goalIndex]
            for targetIndex in 0..<titles[goalIndex].count {
                let targetTitle = titles[goalIndex][targetIndex]
                let targetFrequencyString = frequencies[goalIndex][targetIndex]
                let targetKey = keys[goalIndex][targetIndex]
                let targetFrequency = viewModel.convertFrequencyToNum(frequencyWord: targetFrequencyString)
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
                    currentFrequencies.append(viewModel.convertFrequencyToString(frequency: currentTarget.original))
                }
            }
            self.titles.append(currentTitles)
            self.frequencies.append(currentFrequencies)
            self.completedNums.append(currentCompletedNums)
            self.keys.append(currentKeys)
        }
    }
    
    
    var body: some View {
        ZStack{
            VStack() {
                switch (mode) {
                case .editing:
                    Title(text:"EDIT WEEKLY TASKS")
                        .padding(.bottom, 6)
                        .foregroundColor(Colors.lightOrangeBackground)
                case .weekly:
                    Title(text:"MONDAY PLANNING")
                        .padding(.bottom, 6)
                        .foregroundColor(Colors.lightOrangeBackground)
                case .initial:
                    Title(text:"ENTER WEEKLY TASKS")
                        .padding(.bottom, 6)
                        .foregroundColor(Colors.lightOrangeBackground)
                }
                
                VStack(alignment: .leading) {
                    Text("Break down your goals - how can you make progress this week?")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16))
                        .padding(.bottom, 6)
                        .padding(.horizontal, 25)
                        .foregroundColor(Colors.lightOrangeBackground)
                    
                    Text("These will clear every Sunday at midnight.")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16))
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                        .foregroundColor(Colors.lightOrangeBackground)
                }
                
                if (mode == Mode.weekly) {
                    Button(action: {
                        loadPastTargets(user: self.viewModel.user, justGoals: false, newGoals: true)
                    }) {
                        Text("Load Past Targets")
                            .foregroundColor(Colors.lightOrangeBackground)
                            .font(.system(size: 16))
                            .frame(width: 150, height: 40, alignment: .center)
                            .background(Colors.blueText)
                            .cornerRadius(15)
                    }
                }
                
                if (mode == Mode.initial) {
                    Button(action: {
                        showExample.toggle()
                    }) {
                        Text("Show Example")
                            .foregroundColor(Colors.lightOrangeBackground)
                            .font(.system(size: 16))
                            .frame(width: 150, height: 40, alignment: .center)
                            .background(Colors.blueText)
                            .cornerRadius(15)
                    }
                }
                
                ScrollView {
                    targetEntryTable
                        .onChange(of: self.viewModel.user) { value in
                            loadPastTargets(user: value, justGoals: (mode == Mode.weekly), newGoals:false)
                        }
                        .padding(.top, 10)
                    
                    NavigationLink(destination: Main(user: self.user, showReflection: false), isActive: $navigateToHome) { EmptyView() }
                    
                    Button(action: {
                        self.showEditWarning = true
                    }) {
                        Text("Submit")
                            .foregroundColor(Colors.lightOrangeBackground)
                            .font(.system(size: 22))
                            .frame(width: 200, height: 60, alignment: .center)
                            .background(Colors.blueText)
                            .cornerRadius(15)
                    }
                }
                
                HStack {
                    Spacer()
                }
                
                Spacer()
                
            }
            .overlay(Color.gray.opacity(showExample ? 0.6 : 0.0))
            
            if (showExample) {
                ExampleTargetsModal(shown: $showExample)
            }
        }
        .background(Colors.darkOrangeForeground)
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
                await self.viewModel.getGoals(phoneNumber: user.phoneNumber, isMondayPlanning: true)
            }
        }
    }
}

extension Date {
    static func today() -> Date {
        return Date()
    }
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        let calendar = Calendar(identifier: .gregorian)
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}


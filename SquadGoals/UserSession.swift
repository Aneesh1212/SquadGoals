//
//  UserSession.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 2/13/23.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseAuth
import SwiftUI
import FirebaseFirestore


class UserSession : ObservableObject {
    @Published var user = User(name: "", phoneNumber: "", groupId: "", goals: [], teammates: [])
    
    // Util variables
    var ref = Database.database().reference()
    
    // Navigation Flags
    @Published var showUserExists = false
    @Published var navigateToJoinGroup = false
    @Published var showGroupNotFound = false
    @Published var navigateToCreateGoal = false
    @Published var navigateToHome = false
    @Published var navigateToReflection = false
    @Published var showUnableToFindUser = false
    @Published var showReflection = false
    
    // Data
    @Published var completedTargets : Int = 0
    @Published var teammatePhones : Array<String> = []
    @Published var totalTargets : Int = 0
    @Published var currBrags : Array<Brag> = []
    @Published var titles : Array<String> = []
    @Published var teammateStrings : Array<String> = []
    @Published var week : Int = 4
    
    
    // Login functions
    func createUser(userName : String, phoneNumber : String) {
        ref.child("users/\(phoneNumber)").getData(completion:  { error, snapshot in
            if (snapshot.exists()) {
                self.showUserExists = true
            } else {
                self.ref.child("users").child(phoneNumber).setValue(["name" : userName, "phone" : phoneNumber])
                self.logUserFCMtoken(phoneNumber: phoneNumber)
                self.user = User(name: userName, phoneNumber: phoneNumber, groupId: "", goals : [], teammates: [])
                self.navigateToJoinGroup = true
            }
        })
    }

    func joinGroup(groupId : String) {
        ref.child("groups/\(groupId)").getData(completion:  { error, snapshot in
            if (snapshot.exists()) {
                let groupRef = self.ref.child("groups").child(groupId).child("users")
                let userKey = groupRef.childByAutoId().key ?? ""
                groupRef.child(userKey).setValue(self.user.phoneNumber)
                self.addGroupToUser(groupId: groupId)
                self.user.groupId = groupId
                self.navigateToCreateGoal = true
            }
            else {
                self.showGroupNotFound = true
            }
        })
    }
    
    func createGroup(groupName : String) -> String {
        let groupId = String(Int.random(in: 100000..<999999))
        self.ref.child("groups").child(groupId).setValue(["groupName" : groupName, "creationDate" : String(Date().timeIntervalSince1970)])
        joinGroup(groupId: groupId)
        return groupId
    }
    
    func addGroupToUser(groupId : String) {
        self.ref.child("users").child(user.phoneNumber).setValue(["name" : user.name, "phone" : user.phoneNumber, "groupId" : groupId])
    }
    
    func tryAutoSignIn() {
        let phoneNumber : String = UserDefaults.standard.string(forKey: "phoneNumber") ?? "X"
        signUserIn(phoneNumber: phoneNumber)
    }
    
    func signUserIn(phoneNumber : String) {
        ref.child("users/\(phoneNumber)").getData(completion:  { error, snapshot in
            if (snapshot.exists()) {
                let userData = snapshot.value as? Dictionary<String, String> ?? [:]
                let userName = userData["name"] ?? ""
                let userPhone = userData["phone"] ?? ""
                let userGroup = userData["groupId"] ?? ""
                self.user = User(name: userName, phoneNumber: userPhone, groupId: userGroup, goals: [], teammates: [])
                self.showUnableToFindUser = false
                self.logUserFCMtoken(phoneNumber: phoneNumber)
                self.signInNavigation()
                self.getGoals()
                self.getTeamMemberPhoneNumbers()
                self.calculateWeek()
                UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
            }
            else {
                self.showUnableToFindUser = true
            }
        })
    }
    
    private func signInNavigation() {
        let defaults = UserDefaults.standard
        let lastSetSunday = ((defaults.object(forKey: "lastSetSunday") as? Date) ?? Date(timeIntervalSince1970: 0))
        let fakeLastSetMonday = Calendar.current.date(byAdding: .day, value: 1, to: lastSetSunday)
        let lastSetMonday = (defaults.object(forKey: "lastSetMonday") as? Date) ?? (fakeLastSetMonday ?? Date(timeIntervalSince1970: 0))
        let daysSinceMonday = (Calendar.current.dateComponents([.day], from: lastSetMonday, to: Date())).day!
        if (daysSinceMonday >= 7) {
        // if (true) {
            self.showReflection = true
        } else {
            self.showReflection = false
        }
        self.navigateToHome = true
    }
    
    private func logUserFCMtoken(phoneNumber : String) {
        let fcmToken = UserDefaults.standard.object(forKey: "fcmToken")
        self.ref.child("fcmTokens").child(phoneNumber).setValue(["token" : fcmToken])
    }
    
    func createGoal(goalTitle : String, goalReason : String, goalCategory: String, goalPrivate: Bool) {
        let goalRef = self.ref.child("goals").child(user.phoneNumber).child("goals")
        let goalKey = goalRef.childByAutoId().key ?? ""
        goalRef.child(goalKey).setValue(["title" : goalTitle, "reason": goalReason, "category" : goalCategory, "private": String(goalPrivate)])
        user.goals.append(Goal(title: goalTitle, reason: goalReason, category: goalCategory, isPrivate: goalPrivate, currTargets: []))
    }
    
    func editGoal(key: String, goalTitle: String, goalReason: String, goalCategory: String, goalPrivate: Bool) {
        let goalRef = self.ref.child("goals").child(user.phoneNumber).child("goals").child(key)
        goalRef.setValue(["title" : goalTitle, "reason": goalReason, "category" : goalCategory, "private": String(goalPrivate)])
        for var goal in user.goals {
            if (goal.key == key) {
                goal.title = goalTitle
                goal.reason = goalReason
                goal.category = goalCategory
                goal.isPrivate = goalPrivate
            }
        }
    }
    
    func updateGoalName(goalKey: String, title: String) {
        let goalPath = "goals/"+user.phoneNumber+"/goals/"+goalKey+"/title"
        let updates = [goalPath: title]
        self.ref.updateChildValues(updates)
        for var goal in user.goals {
            if (goal.key == goalKey) {
                goal.title = title
            }
        }
    }
    
    func createTargets(goalId : String, targets : Array<Target>) {
        let targetsRef = self.ref.child("targets").child(goalId)
        for target in targets {
            targetsRef.child(target.key).setValue(["title" : target.title, "frequency" : String(target.frequency), "original": String(target.original), "creationDate" : String(target.creationDate.timeIntervalSince1970)])
        }
        for var goal in user.goals {
            if (goal.key == goalId) {
                goal.currTargets.append(contentsOf: targets)
            }
        }
    }
    
    func writeResults() {
        let teamPercentage = calculateTeamTargetPercent()
        let currPercentage = calculateWeeklyTargetPercent(goals: user.goals)
        let resultRef = self.ref.child("results").child(user.groupId)
        ref.child("results/\(user.groupId)").getData(completion:  { error, snapshot in
            let data = snapshot.value as? Dictionary<String, String> ?? [:];
            var winner = data["winner"] ?? ""
            var winnerPercentage = Float(data["winnerPercentage"] ?? "0.0") ?? 0.0
            if (currPercentage >= winnerPercentage) {
                winnerPercentage = currPercentage
                winner = self.user.name
            }
            resultRef.setValue(["teamPercentage": String(teamPercentage), "winner": winner, "winnerPercentage": String(winnerPercentage)])
        });
    }
    
    func overwriteTarget(goalId : String, targetId: String, targetFrequency : Int){
        let targetPath = "targets/"+goalId+"/"+targetId+"/frequency"
        let updates = [targetPath: targetFrequency]
        self.ref.updateChildValues(updates)
        for goal in user.goals {
            if (goal.key == goalId) {
                for var target in goal.currTargets {
                    target.frequency = targetFrequency
                }
            }
        }
    }
    
    
    
    func getGoals() {
        let lastSetSunday = ((UserDefaults.standard.object(forKey: "lastSetSunday") as? Date) ?? Date(timeIntervalSince1970: 0))
        let lastSetMonday = (UserDefaults.standard.object(forKey: "lastSetMonday") as? Date) ?? Date(timeIntervalSince1970: 0)
        self.completedTargets = 0
        self.totalTargets = 0
                
        ref.child("goals/\(user.phoneNumber)/goals").observe(DataEventType.value, with: { goalSnapshot in
            self.user.goals = []
            let goals = goalSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
            for goalDataPair in goals {
                let goalData = goalDataPair.value
                let goalTitle = goalData["title"] ?? ""
                let goalReason = goalData["reason"] ?? ""
                let goalCategory = goalData["category"] ?? ""
                let goalPrivate = Bool(goalData["private"] ?? "") ?? false
                var newGoal = Goal(title: goalTitle, reason: goalReason, category: goalCategory, isPrivate: goalPrivate, currTargets: [], key : goalDataPair.key)
                
                let goalKey = goalDataPair.key
                self.ref.child("targets/\(goalKey)").getData(completion:  { error, targetsSnapshot in
                    let targets = targetsSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
                    for targetDataPair in targets {
                        let targetData = targetDataPair.value
                        let targetTitle = targetData["title"] ?? ""
                        let targetFrequency = Int(targetData["frequency"] ?? "0") ?? 1
                        let targetOriginal = Int(targetData["original"] ?? "0") ?? 1
                        let targetCreationDate = Date(timeIntervalSince1970: (Double(targetData["creationDate"] ?? "0") ?? 0.0))
                        let newTarget = Target(title: targetTitle, frequency: targetFrequency, original: targetOriginal, key: targetDataPair.key, creationDate: targetCreationDate)
                        let targetMonday = targetCreationDate.previous(.monday, considerToday: true)
                        newGoal.pastTargets[targetMonday] = newGoal.pastTargets[targetMonday] ?? []
                        newGoal.pastTargets[targetMonday]?.append(newTarget)
                    }
                    for mondayDate in newGoal.pastTargets.keys {
                        if (Calendar.current.dateComponents([.day], from: mondayDate, to: lastSetMonday).day == 0){
                            newGoal.currTargets = newGoal.pastTargets[mondayDate] ?? []
                            
                            for target in newGoal.currTargets {
                                self.totalTargets += target.original
                                self.completedTargets += target.original - target.frequency
                            }
                        }
                    }
                    self.user.goals.append(newGoal)
                })
            }
        });
    }
    
    func getTeamMemberPhoneNumbers() {
        self.teammatePhones = []
        let groupRef = self.ref.child("groups").child(self.user.groupId).child("users").getData(completion:  { error, usersSnapshot in
            let users = usersSnapshot.value as? Dictionary<String, String> ?? [:]
            for userDataPair in users {
                if (userDataPair.value != self.user.phoneNumber) {
                    self.teammatePhones.append(userDataPair.value)
                }
            }
            self.getTeammateInfo()
        })
    }
    
    func getTeammateInfo(){
        self.user.teammates = []
        let usersRef = self.ref.child("users").getData(completion:  { error, usersSnapshot in
            let users = usersSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
            for userDataPair in users{
                if (self.teammatePhones.contains(userDataPair.key)) {
                    let userName = userDataPair.value["name"] ?? ""
                    let userPhoneNumber = userDataPair.value["phone"] ?? ""
                    let userGroup = userDataPair.value["groupId"] ?? ""
                    let newTeammate = User(name: userName, phoneNumber: userPhoneNumber, groupId: userGroup, goals: [], teammates: [])
                    self.user.teammates.append(newTeammate)
                }
            }
            self.getTeammateGoals()
        })
    }
    
    func getTeammateGoals(){
        let lastSetMonday = (UserDefaults.standard.object(forKey: "lastSetMonday") as? Date) ?? Date(timeIntervalSince1970: 0)
        for teammate in user.teammates {
            ref.child("goals/\(teammate.phoneNumber)/goals").observe(DataEventType.value, with: { goalSnapshot in
                let teammateIndex : Int = self.user.teammates.firstIndex(of: teammate) ?? 0
                let goals = goalSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
                for goalDataPair in goals {
                    let goalData = goalDataPair.value
                    let goalTitle = goalData["title"] ?? ""
                    let goalReason = goalData["reason"] ?? ""
                    let goalCategory = goalData["category"] ?? ""
                    let goalPrivate = Bool(goalData["private"] ?? "") ?? false
                    var newGoal = Goal(title: goalTitle, reason: goalReason, category: goalCategory, isPrivate: goalPrivate, currTargets: [], key : goalDataPair.key)
                    
                    let goalKey = goalDataPair.key
                    self.ref.child("targets/\(goalKey)").getData(completion:  { error, targetsSnapshot in
                        guard error == nil else {
                            return;
                        }
                        let targets = targetsSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
                        for targetDataPair in targets {
                            let targetData = targetDataPair.value
                            let targetTitle = targetData["title"] ?? ""
                            let targetFrequency = Int(targetData["frequency"] ?? "0") ?? 1
                            let targetOriginal = Int(targetData["original"] ?? "0") ?? 1
                            let targetCreationDate = Date(timeIntervalSince1970: (Double(targetData["creationDate"] ?? "0") ?? 0.0))
                            let newTarget = Target(title: targetTitle, frequency: targetFrequency, original: targetOriginal, key: targetDataPair.key, creationDate: targetCreationDate)
                            let targetMonday = targetCreationDate.previous(.monday, considerToday: true)
                            newGoal.pastTargets[targetMonday] = newGoal.pastTargets[targetMonday] ?? []
                            newGoal.pastTargets[targetMonday]?.append(newTarget)
                        }
                        for mondayDate in newGoal.pastTargets.keys {
                            if (Calendar.current.dateComponents([.day], from: mondayDate, to: lastSetMonday).day == 0){
                                newGoal.currTargets = newGoal.pastTargets[mondayDate] ?? []
                            }
                        }
                        self.user.teammates[teammateIndex].goals.append(newGoal)
                        self.calculateTeamStrings()
                    })
                }
            })
        }
    }
    
    func calculateTeamStrings() {
        self.teammateStrings = []
        for teammate in self.user.teammates {
            let percentage = calculateWeeklyTargetPercent(goals: teammate.goals)
            self.teammateStrings.append("\(teammate.name) completed \(String(Int(percentage * 100)))%")
        }
    }
    
    func calculateWeek() {
        self.ref.child("groups").child(self.user.groupId).child("creationDate").getData(completion:  { error, creationDateString in
            let creationDate = Date(timeIntervalSince1970: Double(creationDateString.value as? String ?? "0") ?? 0.0)
            let nextMonday = Calendar(identifier: .gregorian).startOfDay(for: (creationDate.next(.monday, considerToday: true)))
            if (nextMonday.compare(Date()) != ComparisonResult.orderedAscending) {
                self.week = 0
            } else {
                let weekNumber = Calendar.current.dateComponents([.weekOfYear], from: nextMonday, to: Date()).weekOfYear ?? 0
                self.week = weekNumber + 1
            }
        })
    }
    
    func sendNotification(users: Array<User>, title : String, message : String){
        for user in users {
            self.ref.child("fcmTokens").child(user.phoneNumber).child("token").getData(completion:  { error, fcmTokenSnapshot in
                let token = fcmTokenSnapshot.value as? String ?? ""
                UtilFunctions.postRequest(fcmToken: token, title: title, message: message)
            })
        }
    }
    
    
    func calculateWeeklyTargetPercent(goals : Array<Goal>) -> Float {
        let totalTargets = calculateTotalTargets(goals: goals)
        let completedTargets = calculateCompletedTargets(goals: goals)
        let result = (totalTargets == 0) ? 0.0 : Float(Float(completedTargets) / Float(totalTargets))
        return result
    }
    
    func calculateTeamTargetPercent() -> Float {
        var totalTargets = 0
        var completedTargets =  0
        let teammates = self.user.teammates + [self.user]
        for teammate in teammates {
            totalTargets += calculateTotalTargets(goals: teammate.goals)
            completedTargets += calculateCompletedTargets(goals: teammate.goals)
        }
        if (totalTargets == 0) { return Float(0)}
        return Float(Float(completedTargets) / Float(totalTargets))
    }
    
    func calculateTotalTargets(goals : Array<Goal>) -> Int {
        var totalTargets = 0
        for goal in goals {
            for target in goal.currTargets {
                totalTargets += target.original
            }
        }
        return totalTargets
    }
    
    func calculateCompletedTargets(goals : Array<Goal>) -> Int {
        var completedTargets = 0
        for goal in goals {
            for target in goal.currTargets {
                completedTargets += (target.original - target.frequency)
            }
        }
        return completedTargets
    }
    
    func calculateTotalTargetsFromTarget(targets : Array<Target>) -> Int {
        var totalTargets = 0
        for target in targets {
            totalTargets += target.original
        }
        return totalTargets
    }
    
    func calculateCompletedTargetsFromTarget(targets : Array<Target>) -> Int {
        var completedTargets = 0
        for target in targets {
            completedTargets += (target.original - target.frequency)
        }
        return completedTargets
    }
    
    func createBrag(goalId : String, brag : Brag) {
        let bragsRef = self.ref.child("brags").child(goalId)
        let bragKey = bragsRef.childByAutoId().key ?? ""
        bragsRef.child(bragKey).setValue(["text" : brag.text])
    }
    
    func getBrags(goalKey : String) {
        self.currBrags = []
        self.ref.child("brags/\(goalKey)").getData(completion:  { error, bragsSnapshot in
            guard error == nil else {
                return;
            }
            let brags = bragsSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
            for bragDataPair in brags {
                let bragData = bragDataPair.value
                let bragText = bragData["text"] ?? ""
                let newBrag = Brag(text: bragText)
                self.currBrags.append(newBrag)
            }
        })
    }
}

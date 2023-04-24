//
//  LoginViewModel.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/15/21.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseAuth
import FirebaseMessaging

class GoalViewModel : ObservableObject {
    
    @Published var user : User
    @Published var completedTargets : Int = 0
    @Published var teammatePhones : Array<String> = []
    var ref = Database.database().reference()
    @Published var totalTargets : Int = 0
    @Published var currBrags : Array<Brag> = []
    @Published var titles : Array<String> = []
    @Published var teammatePercentages : [String: Float] = [:]
    @Published var week : Int = 4
    
    init (user : User) {
        self.user = user
    }
    
    func createGoal(phoneNumber : String, goalTitle : String, goalReason : String, goalCategory: String) {
        let goalRef = self.ref.child("goals").child(phoneNumber).child("goals")
        let goalKey = goalRef.childByAutoId().key ?? ""
        goalRef.child(goalKey).setValue(["title" : goalTitle, "reason": goalReason, "category" : goalCategory, "momentumScore": "0", "positiveMomentum": "1", "negativeMomentum": "-1", "crossedOff": "false"])
    }
    
    func editGoal(key: String, goalTitle: String, goalReason: String, goalCategory: String) {
        let goalRef = self.ref.child("goals").child(self.user.phoneNumber).child("goals").child(key)
        goalRef.updateChildValues(["title" : goalTitle, "reason": goalReason, "category" : goalCategory])
    }
    
    func deleteGoal(goalKey: String) {
        self.ref.child("goals").child(user.phoneNumber).child("goals").child(goalKey).removeValue()
        self.ref.child("targets").child(goalKey).removeValue()
        self.ref.child("brags").child(goalKey).removeValue()
    }
    
    func createTargets(goalId : String, targets : Array<Target>) {
        let targetsRef = self.ref.child("targets").child(goalId)
        for target in targets {
            targetsRef.child(target.key).setValue(["title" : target.title, "frequency" : String(target.frequency), "original": String(target.original), "creationDate" : String(target.creationDate.timeIntervalSince1970)])
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
    
    func overwriteTarget(goalId : String, targetId: String, targetTitle: String, targetFrequency : Int, targetOriginal : Int, creationDate : Date){
        self.ref.child("targets").child(goalId).child(targetId).setValue(["title" : targetTitle, "frequency" : String(targetFrequency), "original": String(targetOriginal), "creationDate" : String(creationDate.timeIntervalSince1970)])
    }
    
    func getGoals(phoneNumber : String, isMondayPlanning: Bool = false) {
        let lastSetSunday = ((UserDefaults.standard.object(forKey: "lastSetSunday") as? Date) ?? Date(timeIntervalSince1970: 0))
        let fakeLastSetMonday = Calendar.current.date(byAdding: .day, value: 1, to: lastSetSunday)
        let lastSetMonday = (UserDefaults.standard.object(forKey: "lastSetMonday") as? Date) ?? (fakeLastSetMonday ?? Date(timeIntervalSince1970: 0))
        self.completedTargets = 0
        self.totalTargets = 0
                
        ref.child("goals/\(phoneNumber)/goals").observe(DataEventType.value, with: { goalSnapshot in
            self.user.goals = []
            let goals = goalSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
            for goalDataPair in goals {
                let goalData = goalDataPair.value
                let goalTitle = goalData["title"] ?? ""
                let goalReason = goalData["reason"] ?? ""
                let goalCategory = goalData["category"] ?? ""
                let goalMomentumScore = Int(goalData["momentumScore"] ?? "0") ?? 0
                let goalPositiveMomentum = Int(goalData["positiveMomentum"] ?? "0") ?? 0
                let goalNegativeMomentum = Int(goalData["negativeMomentum"] ?? "0") ?? 0
                let goalCrossedOff = Bool(goalData["crossedOff"] ?? "false") ?? false
                var newGoal = Goal(title: goalTitle, reason: goalReason, category: goalCategory, currTargets: [], momentumScore: goalMomentumScore, positiveMomentum: goalPositiveMomentum, negativeMomentum: goalNegativeMomentum, crossedOff: goalCrossedOff, key : goalDataPair.key)
                
                let goalKey = goalDataPair.key
                
                self.ref.child("targets/\(goalKey)").getData(completion:  { error, targetsSnapshot in
                    guard error == nil else {
                        print(error!.localizedDescription)
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
                            
                            for target in newGoal.currTargets {
                                self.totalTargets += target.original
                                self.completedTargets += target.original - target.frequency
                            }
                        }
                    }
                    print("added goal")
                    self.user.goals.append(newGoal)
                })
            }
        });
    }
    
    func getTeamMemberPhoneNumbers() {
        self.teammatePhones = []
        let groupRef = self.ref.child("groups").child(self.user.groupId).child("users").getData(completion:  { error, usersSnapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
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
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
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
        let lastSetSunday = ((UserDefaults.standard.object(forKey: "lastSetSunday") as? Date) ?? Date(timeIntervalSince1970: 0))
        let fakeLastSetMonday = Calendar.current.date(byAdding: .day, value: 1, to: lastSetSunday)
        let lastSetMonday = (UserDefaults.standard.object(forKey: "lastSetMonday") as? Date) ?? (fakeLastSetMonday ?? Date(timeIntervalSince1970: 0))
        for teammate in user.teammates {
            ref.child("goals/\(teammate.phoneNumber)/goals").observe(DataEventType.value, with: { goalSnapshot in
                let teammateIndex : Int = self.user.teammates.firstIndex(of: teammate) ?? 0
                let goals = goalSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
                for goalDataPair in goals {
                    let goalData = goalDataPair.value
                    let goalTitle = goalData["title"] ?? ""
                    let goalReason = goalData["reason"] ?? ""
                    let goalCategory = goalData["category"] ?? ""
                    let goalMomentumScore = Int(goalData["momentumScore"] ?? "0") ?? 0
                    let goalPositiveMomentum = Int(goalData["positiveMomentum"] ?? "0") ?? 0
                    let goalNegativeMomentum = Int(goalData["negativeMomentum"] ?? "0") ?? 0
                    let goalCrossedOff = Bool(goalData["crossedOff"] ?? "false") ?? false
                    var newGoal = Goal(title: goalTitle, reason: goalReason, category: goalCategory, currTargets: [], momentumScore: goalMomentumScore, positiveMomentum: goalPositiveMomentum, negativeMomentum: goalNegativeMomentum, crossedOff: goalCrossedOff, key : goalDataPair.key)
                    
                    let goalKey = goalDataPair.key
                    self.ref.child("targets/\(goalKey)").getData(completion:  { error, targetsSnapshot in
                        guard error == nil else {
                            return;
                        }
                        let targets = targetsSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
                        for targetDataPair in targets {
                            let targetData = targetDataPair.value
                            //print("Individual target data : \(targetData)")
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
                        self.calculateTeamPercentages()
                    })
                }
            })
        }
    }
    
    func sendUpdateNotification(targetTitle: String) {
        let new = Float(Float(self.completedTargets) / Float(self.totalTargets))
        let old = Float((Float(self.completedTargets) - 1) / Float(self.totalTargets))
        if (new == 1.0) {
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Squad Goals: Team Update", message: "Chef's Kiss! \(self.user.name) has finished ALL their goals this week. Congratulate \(self.user.name) on their determination and grit!")
        }
        else if (old < 0.25 && new >= 0.25){
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Squad Goals: Team Update", message: "\(self.user.name) is out of the gates with 25% of their goals done!")
        }
        else if (old < 0.5 && new >= 0.5){
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Squad Goals: Team Update", message: "\(self.user.name) is halfway there! Let's send a note of encouragement to keep up the progress.")
        }
        else if (old < 0.75 && new >= 0.75){
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Squad Goals: Team Update", message: "Omg \(self.user.name) has finished 75% of their week goals. A little bit more for that 100% and 🍷")
        } else {
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Squad Goals: Team Update", message: "\(String(self.user.name)) just checked off \(targetTitle)")
        }
    }
    
    func calculateTeamPercentages() {
        self.teammatePercentages = [:]
        for teammate in self.user.teammates {
            let percentage = calculateWeeklyTargetPercent(goals: teammate.goals)
            self.teammatePercentages[teammate.name] = percentage
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
    
    func deleteAllGoals(phoneNumber : String) {
        ref.child("goals/\(phoneNumber)/goals").removeValue()
        ref.child("targets").removeValue()
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

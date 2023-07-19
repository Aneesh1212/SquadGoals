//
//  GoalViewModel.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/15/21.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseAuth
import FirebaseMessaging

let ref = Database.database().reference()
let pastMonday = Calendar(identifier: .gregorian).startOfDay(for: Date()).previous(.monday, considerToday: true)

class GoalViewModel : ObservableObject {

    @Published var user : User = User(name: "", phoneNumber: "", groupId: "", goals: [], teammates: [])
    @Published var completedTargets : Int = 0
    @Published var teammatePhones : Array<String> = []
    @Published var totalTargets : Int = 0
    @Published var currBrags : Array<Brag> = []
    @Published var teammatePercentages : [String: Float] = [:]
    @Published var week : Int = 4
    
    // Flags
    @Published var showUserExists = false
    @Published var navigateToJoinGroup = false
    @Published var showGroupNotFound = false
    @Published var navigateToHome = false
    @Published var navigateToReflection = false
    @Published var showUnableToFindUser = false
    @Published var showReflection = false
    @Published var navigateToMissingGroup = false

    weak var gestureRecognizer: GestureRecognizerInteractor? = UIApplication.shared
    
    func createGoal(goalTitle : String, goalReason : String, goalCategory: String) {
        let goalRef = ref.child("goals").child(user.phoneNumber).child("goals")
        let goalKey = goalRef.childByAutoId().key ?? ""
        goalRef.child(goalKey).setValue(["title" : goalTitle, "reason": goalReason, "category" : goalCategory, "momentumScore": "0", "positiveMomentum": "1", "negativeMomentum": "-1", "crossedOff": "false"])
        self.user.goals.append(Goal(title: goalTitle, reason: goalReason, category: goalCategory, currTargets: [], momentumScore: 0, positiveMomentum: 1, negativeMomentum: -1, recordMomentum: 0, crossedOff: false, key: goalKey))
    }
    
    func editGoal(key: String, goalTitle: String, goalReason: String, goalCategory: String) {
        let goalRef = ref.child("goals").child(self.user.phoneNumber).child("goals").child(key)
        goalRef.updateChildValues(["title" : goalTitle, "reason": goalReason, "category" : goalCategory])
        for (index, _) in user.goals.enumerated() {
            if (user.goals[index].key == key) {
                user.goals[index].title = goalTitle
                user.goals[index].reason = goalReason
                user.goals[index].category = goalCategory
            }
        }
    }
    
    func updateGoalMomentum(goal: Goal) {
        let goalRef = ref.child("goals").child(self.user.phoneNumber).child("goals").child(goal.key)
        goalRef.updateChildValues(["momentumScore" : String(goal.momentumScore), "positiveMomentum": String(goal.positiveMomentum), "negativeMomentum" : String(goal.negativeMomentum), "crossedOff" : goal.crossedOff ? "true" : "false", "recordMomentum": String(goal.recordMomentum)])
        let goalIndex = self.user.goals.firstIndex { $0.key ==  goal.key } ?? 0
        self.user.goals[goalIndex] = goal
    }
    
    func deleteGoal(goalKey: String) {
        ref.child("goals").child(user.phoneNumber).child("goals").child(goalKey).removeValue()
        ref.child("targets").child(goalKey).removeValue()
        ref.child("brags").child(goalKey).removeValue()
        self.user.goals.removeAll { $0.key == goalKey }
        self.resetUserTargetNumbers()
    }
    
    func createTargets(goalId : String, targets : Array<Target>) {
        let targetsRef = ref.child("targets").child(goalId)
        for target in targets {
            targetsRef.child(target.key).setValue(["title" : target.title, "frequency" : String(target.frequency), "original": String(target.original), "creationDate" : String(target.creationDate.timeIntervalSince1970)])
        }
        let goalIndex = self.user.goals.firstIndex { $0.key == goalId } ?? 0
        self.user.goals[goalIndex].currTargets = targets
        self.user.goals[goalIndex].pastTargets[pastMonday] = targets
        self.resetUserTargetNumbers()
    }
    
    func writeResults() {
        let teamPercentage = calculateTeamTargetPercent()
        let currPercentage = calculateWeeklyTargetPercent(goals: user.goals)
        let resultRef = ref.child("results").child(user.groupId)
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
    
    func incrementTarget(goalId : String, targetId: String, targetTitle: String, targetFrequency : Int, targetOriginal : Int, creationDate : Date) {
        completedTargets += 1
        ref.child("targets").child(goalId).child(targetId).setValue(["title" : targetTitle, "frequency" : String(targetFrequency), "original": String(targetOriginal), "creationDate" : String(creationDate.timeIntervalSince1970)])
        let goalIndex = self.user.goals.firstIndex { $0.key == goalId } ?? 10
        let targetIndex = self.user.goals[goalIndex].currTargets.firstIndex { $0.key == targetId } ?? 10
        self.user.goals[goalIndex].currTargets[targetIndex].frequency = targetFrequency
        if (self.user.goals[goalIndex].pastTargets[pastMonday] != nil) {
            self.user.goals[goalIndex].pastTargets[pastMonday]![targetIndex].frequency = targetFrequency
        }
    }
    
    func getGoals() {
        let lastSetSunday = ((UserDefaults.standard.object(forKey: "lastSetSunday") as? Date) ?? Date(timeIntervalSince1970: 0))
        let fakeLastSetMonday = Calendar.current.date(byAdding: .day, value: 1, to: lastSetSunday)
        let lastSetMonday = (UserDefaults.standard.object(forKey: "lastSetMonday") as? Date) ?? (fakeLastSetMonday ?? Date(timeIntervalSince1970: 0))
        self.completedTargets = 0
        self.totalTargets = 0
        
        ref.child("goals/\(user.phoneNumber)/goals").getData(completion: { error, goalSnapshot in
            self.user.goals = []
            let goals = goalSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
            for goalDataPair in goals {
                let goalData = goalDataPair.value
                let goalTitle = goalData["title"] ?? ""
                let goalReason = goalData["reason"] ?? ""
                let goalCategory = goalData["category"] ?? ""
                let goalMomentumScore = Int(goalData["momentumScore"] ?? "0") ?? 0
                let goalPositiveMomentum = Int(goalData["positiveMomentum"] ?? "1") ?? 1
                let goalNegativeMomentum = Int(goalData["negativeMomentum"] ?? "-1") ?? -1
                let goalCrossedOff = Bool(goalData["crossedOff"] ?? "false") ?? false
                let goalRecordMomentum = Int(goalData["recordMomentum"] ?? "0") ?? 0
                var newGoal = Goal(title: goalTitle, reason: goalReason, category: goalCategory, currTargets: [], momentumScore: goalMomentumScore, positiveMomentum: goalPositiveMomentum, negativeMomentum: goalNegativeMomentum, recordMomentum: goalRecordMomentum, crossedOff: goalCrossedOff, key : goalDataPair.key)
                
                let goalKey = goalDataPair.key
                
                ref.child("targets/\(goalKey)").getData(completion:  { error, targetsSnapshot in
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
                        if (Calendar.current.dateComponents([.day], from: mondayDate, to: lastSetMonday).day == 0) {
                            newGoal.currTargets = newGoal.pastTargets[mondayDate] ?? []
                        }
                    }
                    self.user.goals.append(newGoal)
                    self.resetUserTargetNumbers()
                    // TODO add ARC strongWeak self
                })
            }
        });
    }
    
    func resetUserTargetNumbers() {
        self.totalTargets = 0
        self.completedTargets = 0
        for goal in user.goals {
            for target in goal.currTargets {
                self.totalTargets += target.original
                self.completedTargets += target.original - target.frequency
            }
        }
    }
    
    func getTeamMemberPhoneNumbers() {
        self.teammatePhones = []
        ref.child("groups").child(self.user.groupId).child("users").getData(completion:  { error, usersSnapshot in
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
        ref.child("users").getData(completion:  { error, usersSnapshot in
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
                let teammateIndex : Int = self.user.teammates.firstIndex { $0.phoneNumber == teammate.phoneNumber } ?? 0
                let goals = goalSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
                for goalDataPair in goals {
                    let goalData = goalDataPair.value
                    let goalTitle = goalData["title"] ?? ""
                    let goalReason = goalData["reason"] ?? ""
                    let goalCategory = goalData["category"] ?? ""
                    let goalMomentumScore = Int(goalData["momentumScore"] ?? "0") ?? 0
                    let goalPositiveMomentum = Int(goalData["positiveMomentum"] ?? "1") ?? 1
                    let goalNegativeMomentum = Int(goalData["negativeMomentum"] ?? "-1") ?? -1
                    let goalCrossedOff = Bool(goalData["crossedOff"] ?? "false") ?? false
                    let goalRecordMomentum = Int(goalData["recordMomentum"] ?? "0") ?? 0
                    var newGoal = Goal(title: goalTitle, reason: goalReason, category: goalCategory, currTargets: [], momentumScore: goalMomentumScore, positiveMomentum: goalPositiveMomentum, negativeMomentum: goalNegativeMomentum, recordMomentum: goalRecordMomentum, crossedOff: goalCrossedOff, key : goalDataPair.key)
                    
                    let goalKey = goalDataPair.key
                    ref.child("targets/\(goalKey)").getData(completion:  { error, targetsSnapshot in
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
    
    func sendUpdateNotification(targetTitle: String, goalMomentum: Int) {
        let new = Float(Float(self.completedTargets) / Float(self.totalTargets))
        let old = Float((Float(self.completedTargets) - 1) / Float(self.totalTargets))
        if (new == 1.0) {
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Squad Goals: Team Update", message: "Chef's Kiss! \(self.user.name) has finished ALL their goals this week. Congratulate \(self.user.name) on their determination and grit!")
        }
        else if (old < 0.25 && new >= 0.25){
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Out of the gates with 25%", message: "\(String(self.user.name)) completed \"\(targetTitle.trimmingCharacters(in: .whitespaces))\". \(getProgressUpdateString(goalMomentum: goalMomentum))")
        }
        else if (old < 0.5 && new >= 0.5){
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Halfway there!", message: "\(String(self.user.name)) completed \"\(targetTitle.trimmingCharacters(in: .whitespaces))\". \(getProgressUpdateString(goalMomentum: goalMomentum))")
        }
        else if (old < 0.75 && new >= 0.75){
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Squad Goals: Team Update", message: "Wow \(self.user.name) has finished 75% of their week goals. A little bit more for that 100% and 🍷")
        } else {
            UtilFunctions.sendNotification(users: self.user.teammates + [self.user], title: "Squad Goals: Team Update", message:
                                            "\(String(self.user.name)) completed \"\(targetTitle.trimmingCharacters(in: .whitespaces))\". \(getProgressUpdateString(goalMomentum: goalMomentum))")
        }
    }
    
    func getProgressUpdateString(goalMomentum: Int) -> String {
        let possibleStrings = [
            "Their goal momentum is now \(String(goalMomentum)).",
            "This brings their goal momentum to \(String(goalMomentum)).",
            "With \(String(goalMomentum)) as their goal momentum, they're on the path to success.",
            "They're proudly achieving a goal momentum of \(String(goalMomentum))",
            "Their hard work pays off with \(String(goalMomentum)) as their goal momentum.",
        ]
        return possibleStrings.randomElement()!
    }
    
    func calculateTeamPercentages() {
        self.teammatePercentages = [:]
        for teammate in self.user.teammates {
            let percentage = calculateWeeklyTargetPercent(goals: teammate.goals)
            self.teammatePercentages[teammate.name] = percentage
        }
    }
    
    func calculateWeek() {
        ref.child("groups").child(self.user.groupId).child("creationDate").getData(completion:  { error, creationDateString in
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
        let totalTargets = UtilFunctions.calculateTotalTargets(goals: goals)
        let completedTargets = UtilFunctions.calculateCompletedTargets(goals: goals)
        let result = (totalTargets == 0) ? 0.0 : Float(Float(completedTargets) / Float(totalTargets))
        return result
    }
    
    func calculateTeamTargetPercent() -> Float {
        var totalTargets = 0
        var completedTargets =  0
        let teammates = self.user.teammates + [self.user]
        for teammate in teammates {
            totalTargets += UtilFunctions.calculateTotalTargets(goals: teammate.goals)
            completedTargets += UtilFunctions.calculateCompletedTargets(goals: teammate.goals)
        }
        if (totalTargets == 0) { return Float(0)}
        return Float(Float(completedTargets) / Float(totalTargets))
    }
    
    func createBrag(goalId : String, brag : Brag) {
        let bragsRef = ref.child("brags").child(goalId)
        let bragKey = bragsRef.childByAutoId().key ?? ""
        bragsRef.child(bragKey).setValue(["text" : brag.text])
        let goalIndex = self.user.goals.firstIndex { $0.key == goalId } ?? 0
        self.user.goals[goalIndex].brags.append(brag)
    }
    
    func getBrags(goalKey : String) {
        self.currBrags = []
        ref.child("brags/\(goalKey)").getData(completion:  { error, bragsSnapshot in
            let brags = bragsSnapshot.value as? Dictionary<String, Dictionary<String, String>> ?? [:]
            for bragDataPair in brags {
                let bragData = bragDataPair.value
                let bragText = bragData["text"] ?? ""
                let newBrag = Brag(text: bragText)
                self.currBrags.append(newBrag)
            }
        })
    }
    
    
    // Pragma mark - LoginViewModel
    
    func signUserIn(phoneNumber : String) {
        ref.child("users/\(phoneNumber)").getData(completion:  { error, snapshot in
            if (snapshot.exists()) {
                let userData = snapshot.value as? Dictionary<String, String> ?? [:]
                let userName = userData["name"] ?? "NA"
                let userPhone = userData["phone"] ?? "NA"
                let userGroup = userData["groupId"] ?? "NA"
                self.user = User(name: userName, phoneNumber: userPhone, groupId: userGroup, goals: [], teammates: [])
                UtilFunctions.logUserFCMtoken(phoneNumber: phoneNumber)
                UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                self.signInNavigation()
                self.getGoals()
                self.getTeamMemberPhoneNumbers()
                self.calculateWeek()
            }
            else {
                self.showUnableToFindUser = true
            }
        })
    }
    
    func addGroupToUser(groupId : String) {
        ref.child("users").child(user.phoneNumber).setValue(["name" : user.name, "phone" : user.phoneNumber, "groupId" : groupId])
        // TODO write concurrent update
    }
    
    private func signInNavigation() {
        if (self.user.groupId == "") {
            self.navigateToMissingGroup = true
            return
        }
        let lastSetMonday = (UserDefaults.standard.object(forKey: "lastSetMonday") as? Date) ?? Date(timeIntervalSince1970: 0)
        let daysSinceMonday = (Calendar.current.dateComponents([.day], from: lastSetMonday, to: Date())).day!
        if (daysSinceMonday >= 7) {
            // if (true) {
            self.showReflection = true
        } else {
            self.showReflection = false
        }
        self.navigateToHome = true
    }
    
    func tryAutoSignIn() {
        let phoneNumber : String = UserDefaults.standard.string(forKey: "phoneNumber") ?? "X"
        signUserIn(phoneNumber: phoneNumber)
    }
    
    func createGroup(groupName : String) -> String {
        let groupId = String(Int.random(in: 100000..<999999))
        ref.child("groups").child(groupId).setValue(["groupName" : groupName, "creationDate" : String(Date().timeIntervalSince1970)])
        joinGroup(groupId: groupId)
        return groupId
    }
    
    func joinGroup(groupId : String) {
        ref.child("groups/\(groupId)").getData(completion:  { error, snapshot in
            if (snapshot.exists()) {
                let groupRef = ref.child("groups").child(groupId).child("users")
                let userKey = groupRef.childByAutoId().key ?? ""
                groupRef.child(userKey).setValue(self.user.phoneNumber)
                self.addGroupToUser(groupId: groupId)
                self.user.groupId = groupId // TODO nice concurrency already done
                self.getGoals()
                self.getTeamMemberPhoneNumbers()
                self.calculateWeek()
            } else {
                self.showGroupNotFound = true
            }
        })
    }
    
    func createUser(userName : String, phoneNumber : String) {
        ref.child("users/\(phoneNumber)").getData(completion:  { error, snapshot in
            if (snapshot.exists()) {
                self.showUserExists = true
            } else {
                ref.child("users").child(phoneNumber).setValue(["name" : userName, "phone" : phoneNumber])
                UtilFunctions.logUserFCMtoken(phoneNumber: phoneNumber)
                self.user = User(name: userName, phoneNumber: phoneNumber, groupId: "", goals : [], teammates: [])
                self.navigateToJoinGroup = true
                UtilFunctions.setLastSetMonday()
            }
        })
    }
}

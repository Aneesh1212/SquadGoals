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
import Combine
import SwiftUI
import FirebaseFirestore


class LoginViewModel : ObservableObject {
    
    var ref = Database.database().reference()
    @Published var userName : String? = nil
    @Published var currentUser : User = User(name: "", phoneNumber: "", groupId: "", goals : [], teammates: [])
    
    // Flags
    @Published var showUserExists = false
    @Published var navigateToJoinGroup = false
    @Published var showGroupNotFound = false
    @Published var navigateToCreateGoal = false
    @Published var navigateToHome = false
    @Published var navigateToReflection = false
    @Published var showUnableToFindUser = false
    @Published var showReflection = false
    weak var gestureRecognizer: GestureRecognizerInteractor? = UIApplication.shared
    
    func createUser(userName : String, phoneNumber : String) {
        print("Creating user with name: \(userName) and phoneNumber \(phoneNumber)")
        ref.child("users/\(phoneNumber)").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if (snapshot.exists()) {
                self.showUserExists = true
            } else {
                self.ref.child("users").child(phoneNumber).setValue(["name" : userName, "phone" : phoneNumber])
                self.logUserFCMtoken(phoneNumber: phoneNumber)
                self.currentUser = User(name: userName, phoneNumber: phoneNumber, groupId: "", goals : [], teammates: [])
                self.navigateToJoinGroup = true
            }
        })
    }
    
    func getUserName(phoneNumber : String) {
        print("Getting user name with phone \(phoneNumber)")
        ref.child("users/\(phoneNumber)/username").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            self.userName = snapshot.value as? String;
            print("Found user with name: \(self.userName ?? "")")
        });
    }
    
    func joinGroup(phoneNumber : String, groupId : String) {
        print("Phone number \(phoneNumber) joining groupId: \(groupId)")
        
        ref.child("groups/\(groupId)").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if (snapshot.exists()) {
                let groupRef = self.ref.child("groups").child(groupId).child("users")
                let userKey = groupRef.childByAutoId().key ?? ""
                groupRef.child(userKey).setValue(phoneNumber)
                self.addGroupToUser(name: self.currentUser.name, phoneNumber: phoneNumber, groupId: groupId)
                self.currentUser.groupId = groupId
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
        joinGroup(phoneNumber: self.currentUser.phoneNumber, groupId: groupId)
        return groupId
    }
    
    func signUserIn(phoneNumber : String) {
        ref.child("users/\(phoneNumber)").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            if (snapshot.exists()) {
                let userData = snapshot.value as? Dictionary<String, String> ?? [:]
                let userName = userData["name"] ?? ""
                let userPhone = userData["phone"] ?? ""
                let userGroup = userData["groupId"] ?? ""
                self.currentUser = User(name: userName, phoneNumber: userPhone, groupId: userGroup, goals: [], teammates: [])
                self.showUnableToFindUser = false
                self.logUserFCMtoken(phoneNumber: phoneNumber)
                self.signInNavigation()
            }
            else {
                self.showUnableToFindUser = true
            }
        })
    }
    
    func addGroupToUser(name : String?, phoneNumber : String, groupId : String) {
        self.ref.child("users").child(phoneNumber).setValue(["name" : name, "phone" : phoneNumber, "groupId" : groupId])
    }
    
    func isValidNameAndPhone(name : String, phoneNumber: String) -> Bool {
        let intPhone = Int(phoneNumber) ?? 0
        return (name != "") && (1000000000 <= intPhone) && (intPhone <= 9999999999)
    }
    
    func isValidGroupId(groupId : String) -> Bool {
        let intGroupId = Int(groupId) ?? 0
        return (100000 <= intGroupId) && (intGroupId <= 999999)
    }
    
    func parsePhoneNumber(phoneNumber : String) -> String {
        return phoneNumber.replacingOccurrences(of: "-", with: "")
    }
    
    private func signInNavigation() {
        let defaults = UserDefaults.standard
        let lastSetSunday = (defaults.object(forKey: "lastSetSunday") as? Date) ?? Date(timeIntervalSince1970: 0)
        print("Last set sunday", lastSetSunday)
        let daysSinceSunday = (Calendar.current.dateComponents([.day], from: lastSetSunday, to: Date())).day!
        if (daysSinceSunday >= 7) {
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

}

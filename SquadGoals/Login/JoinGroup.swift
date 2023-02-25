//
//  JoinGroup.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct JoinGroup: View {
    
    @EnvironmentObject var userSession : UserSession
    @State private var shouldNavigate: Bool = false
    @State private var groupID: String = ""
    @State private var groupName: String = ""
    @State private var showInvalidGroupId = false
    @State private var showNewGroupId = false
    @State private var showNoGroupName = false
    @State private var newGroupId = ""
    
    
    var body: some View {
        VStack{
            OnboardingTitle(text: "WELCOME \(userSession.user.name.uppercased())!")
                .padding(.top, Styling.onboardingTitlePadding)
                .padding(.bottom, Styling.largeUnit)
                .lineLimit(nil)
            
            OnboardingTextEntry(placeholder: "Enter an existing squad ID", value: $groupID)
                .padding(.bottom, Styling.smallUnit)
            
            OnboardingActionButton(action: {
                if (UtilFunctions.isValidGroupId(groupId: self.groupID)) {
                    userSession.joinGroup(groupId: self.groupID)
                    self.shouldNavigate = true
                } else {
                    self.showInvalidGroupId = true
                }
            }, text: "JOIN GROUP")
            .padding(.bottom, Styling.largeUnit)
            
            NavigationLink(destination: BaseTutorial(), isActive: $userSession.navigateToCreateGoal) { EmptyView() }
                        
            VStack(alignment: .leading, spacing: 5) {
                Text("Don't have one?")
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                OnboardingTextEntry(placeholder: "Name your new squad", value: $groupName)
                    .padding(.bottom, Styling.smallUnit)
            }
            
            OnboardingActionButton(action: {
                if (self.groupName == "") {
                    self.showNoGroupName = true
                }
                let groupId = userSession.createGroup(groupName: self.groupName)
                self.newGroupId = groupId
                // showNewGroupId = true
            }, text: "CREATE A NEW SQUAD")
            
            Filler()
        }
        .padding(.horizontal, 30)
        .background(Colors.darkOrangeForeground)
        .alert("Please enter a 6 digit group ID", isPresented: $showInvalidGroupId) {
            Button("OK", role: .cancel) { }
        }
        .alert("Could not find a group with this ID", isPresented: $userSession.showGroupNotFound) {
            Button("OK", role: .cancel) { }
        }
        .alert("Please enter a group name", isPresented: $showNoGroupName) {
            Button("OK", role: .cancel) { }
        }
        .alert(isPresented: $showNewGroupId) {
            Alert(title: Text("\(self.groupName) Created!"), message: Text("You group ID is \(self.newGroupId). Share with squad members so they can join the same group. You can also find the code on your profile page"), dismissButton: .default(Text("Copy and Proceed"), action: {
                UIPasteboard.general.setValue(self.newGroupId, forPasteboardType: "public.plain-text")
                userSession.navigateToCreateGoal = true }))
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
}

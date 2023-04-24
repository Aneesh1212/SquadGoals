//
//  JoinGroup.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct JoinGroup: View {
    
    @StateObject var viewModel = LoginViewModel()
    @State private var shouldNavigate: Bool = false
    @State private var groupID: String = ""
    @State private var groupName: String = ""
    @State private var showInvalidGroupId = false
    @State private var showNewGroupId = false
    @State private var showNoGroupName = false
    @State private var newGroupId = ""
    
    
    var body: some View {
        VStack(alignment: .leading){
            Title(text: "Welcome \(viewModel.currentUser.name)!")
                .lineLimit(nil)
            Spacing(height:6)
            Subtitle(text: "Let's join a squad")
            
            Spacing(height: Styling.largeUnit)
            
            VStack(alignment: .leading){
                Subtitle(text: "Squad ID")
                OnboardingTextEntry(placeholder: "Enter an existing squad ID", value: $groupID)
                BlueActionButton(text: "Join Squad", action: joinSquad)
            }
            
            Spacing(height: Styling.largeUnit)
            
            VStack(alignment: .leading){
                Subtitle(text: "Don't have one?")
                OnboardingTextEntry(placeholder: "Name your new squad", value: $groupName)
                BlueActionButton(text: "Create a New Squad", action: createSquad)
            }
            
            NavigationLink(destination: BaseTutorial(user: viewModel.currentUser), isActive: $shouldNavigate) { EmptyView() }
            
            
            Filler()
        }
        .padding(.bottom, Styling.mediumUnit)
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.background)
        .alert("Please enter a 6 digit group ID", isPresented: $showInvalidGroupId) {
            Button("OK", role: .cancel) { }
        }
        .alert("Could not find a group with this ID", isPresented: $viewModel.showGroupNotFound) {
            Button("OK", role: .cancel) { }
        }
        .alert("Please enter a group name", isPresented: $showNoGroupName) {
            Button("OK", role: .cancel) { }
        }
        .alert(isPresented: $showNewGroupId) {
            Alert(title: Text("\(self.groupName) Created!"), message: Text("You group ID is \(self.newGroupId). Share with squad members so they can join the same group. You can also find the code on your profile page"), dismissButton: .default(Text("Copy and Proceed"), action: {
                UIPasteboard.general.setValue(self.newGroupId, forPasteboardType: "public.plain-text")
                self.viewModel.navigateToCreateGoal = true }))
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
    func joinSquad(){
        if (viewModel.isValidGroupId(groupId: self.groupID)) {
            // viewModel.joinGroup(phoneNumber: viewModel.currentUser.phoneNumber, groupId: self.groupID)
            self.shouldNavigate = true
        } else {
            self.showInvalidGroupId = true
        }
    }
    
    func createSquad(){
        if (self.groupName == "") {
            self.showNoGroupName = true
        }
        let groupId = viewModel.createGroup(groupName: self.groupName)
        self.newGroupId = groupId
        // showNewGroupId = true
    }
}

//
//  JoinGroup.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct JoinGroup: View {
    
    @StateObject var viewModel = GoalViewModel()
    @State private var shouldNavigate: Bool = false
    @State private var groupID: String = ""
    @State private var groupName: String = ""
    @State private var showInvalidGroupId = false
    @State private var showNewGroupId = false
    @State private var showNoGroupName = false
    @State private var newGroupId = ""
    
    
    var body: some View {
        VStack(alignment: .leading){
            Title(text: "Welcome \(viewModel.user.name)!")
                .lineLimit(nil)
            Spacing(height:6)
            Subtitle(text: "Let’s join a Squad! Enter an ID for an existing Squad, or create a new one")
            
            Spacing(height: Styling.largeUnit)
            Spacing(height: Styling.largeUnit)

            VStack(alignment: .center){
                BlueActionButton(text: "Create a New Squad", action: createSquad)
                
                Subtitle(text: "or")
                    .padding(.vertical, Styling.mediumUnit)
                
                VStack(alignment: .leading){
                    OnboardingTextEntry(placeholder: "Enter an existing squad ID", value: $groupID)
                    Spacing(height: Styling.smallUnit)
                    BlueActionButton(text: "Join an Existing Squad", action: joinSquad)
                }
                
            }
            
            NavigationLink(destination: BaseTutorial(viewModel: self.viewModel), isActive: $shouldNavigate) { EmptyView() }
            
            Filler()
        }
        .padding(.bottom, Styling.mediumUnit)
        .padding(.top, Styling.smallUnit)
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
                self.shouldNavigate = true }))
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
    func joinSquad(){
        if (UtilFunctions.isValidGroupId(groupId: self.groupID)) {
            viewModel.joinGroup(groupId: self.groupID)
            self.shouldNavigate = true
        } else {
            self.showInvalidGroupId = true
        }
    }
    
    func createSquad(){
        /*if (self.groupName == "") {
            self.showNoGroupName = true
            return
        }*/
        let groupId = viewModel.createGroup(groupName: self.groupName)
        self.newGroupId = groupId
        self.showNewGroupId = true
    }
}

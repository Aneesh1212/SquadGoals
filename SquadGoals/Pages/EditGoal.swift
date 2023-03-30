//
//  JoinGroup.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct EditGoal: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var goalReason: String = ""
    @State var viewModel : GoalViewModel
    @Binding var goal : Goal
    @State private var goalKey : String = ""
    @State private var goalTitle: String = ""
    @State private var goalCategory: String = ""
    @State var navigateBack = false
    
    var goalTitleView: some View {
        VStack(alignment: .leading, spacing: 2){
            Text("Goal Title")
                .foregroundColor(Colors.lightOrangeBackground)
            TextField(
                "",
                text: $goalTitle
            )
                .font(.system(size: 20))
                .frame(height: 45, alignment: .center)
                .fixedSize(horizontal: false, vertical: false)
                .foregroundColor(.black)
                .padding(.leading, 10)
                .background(Color.white)
                .cornerRadius(10)
                .lineLimit(nil)
            Spacer()
                .frame(height: 15)
        }
    }
    
    var goalReasonView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Why is this Goal Important to you?")
                .foregroundColor(Colors.lightOrangeBackground)
            TextEditor(
                text: $goalReason
            )
                .font(.system(size: 20))
                .frame(height: 90, alignment: .center)
                .fixedSize(horizontal: false, vertical: false)
                .padding(.leading, 5)
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.black)
            Spacer()
                .frame(height: 15)
        }
    }
    
    var goalCategoryView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Goal Category")
                .foregroundColor(Colors.lightOrangeBackground)
            TextField(
                "Mental Health, Fitness, Professional",
                text: $goalCategory
            )
                .font(.system(size: 20))
                .frame(height: 45, alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 10)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
            Spacer()
                .frame(height: 12)
        }
        .padding(.bottom, 10)
    }

    var body: some View {
        VStack(alignment: .leading){
            Title(text: "Edit Goal")
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack{
                goalTitleView
                goalReasonView
                goalCategoryView
            }
            
            Spacer()
            
            Button(action: {
                viewModel.editGoal(key: goalKey, goalTitle: goalTitle, goalReason: goalReason, goalCategory: goalCategory)
                self.goal.title = goalTitle
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save changes")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 40, alignment: .center)
                    .background(Colors.blueText)
                    .cornerRadius(15)
            }
            
            Text("You can't make edits after submitting. If need be, please contact admin")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.system(size: 14))
            
            HStack{
                Spacer()
            }
        }
        .padding(.horizontal, 25)
        .background(Colors.darkOrangeForeground)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            self.viewModel = viewModel
            self.goalKey = goal.key
            self.goalTitle = goal.title
            self.goalReason = goal.reason
            self.goalCategory = goal.category
        }
    }
    
}


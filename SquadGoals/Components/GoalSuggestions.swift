//
//  GoalSuggestions.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/21/21.
//

import Foundation
import SwiftUI

struct GoalSuggestions : View {
    
    @StateObject var viewModel : GoalViewModel
    @Binding var chosenSuggestion : String
    
    var suggestionList = ["Consistent exercise", "Learning a skill", "Work productivity", "Quitting a bad habit", "Hobbies", "Studying & career development","Improved mental health"]
    
    func chooseSuggestionAction(suggestion: String) -> () {
        chosenSuggestion = suggestion
    }
    
    var body : some View {
        let teamList = [viewModel.user] + viewModel.user.teammates
        VStack(alignment: .center) {
            
            Subtitle(text: "Some Ideas 🤗", textColor: .gray)
            WrappingHStack(tags: suggestionList, selectionAction: chooseSuggestionAction)
        }
    }
}


//
//  NavigationController.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 3/3/23.
//

import Foundation
import SwiftUI

enum Pages {
    case Welcome(shouldTryToSignIn: Bool)
    case CreateAccount
    case SignIn
    case JoinGroup
    case Homepage(showReflectionPrompt: Bool)
    case Main(showResultsModal: Bool)
    case ProfilePage
    case MondayPlanning(mode: Mode)
    case UserPage(user: User)
    case GoalAdded(goalTitle: String)
    case SquadPage(isReviewing: String)
    case EditGoal(goal: Binding<Goal>)
    case CreateGoal(isSingleGoal: Bool)
    case BaseTutorial
    case Tutorial1
    case Tutorial2
    case Tutorial3
}



//
//  User.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/21/21.
//

import Foundation

struct User : Hashable {
    var name : String
    var phoneNumber : String
    var groupId : String
    var goals : Array<Goal>
    var teammates : Array<User>
        
    init(name: String, phoneNumber : String, groupId : String, goals : Array<Goal>, teammates : Array<User>) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.groupId = groupId
        self.goals = goals
        self.teammates = teammates
    }
}

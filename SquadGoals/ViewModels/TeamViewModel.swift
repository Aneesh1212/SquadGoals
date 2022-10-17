//
//  TeamViewModel.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/15/21.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseAuth

class TeamViewModel : ObservableObject {
    
    var ref = Database.database().reference()
    @Published var teamMembersPhoneNumbers : Array<String> = []
    
    func getTeamMemberPhoneNumbers(groupId : String) {
        let groupRef = self.ref.child("groups").child(groupId).child("users").getData(completion:  { error, usersSnapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            let users = usersSnapshot.value as? Dictionary<String, String> ?? [:]
            for userDataPair in users {
                self.teamMembersPhoneNumbers.append(userDataPair.value)
            }
        })
    }
    
}

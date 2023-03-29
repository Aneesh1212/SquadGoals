//
//  UtilFunctions.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 3/28/23.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseAuth
import FirebaseMessaging


struct UtilFunctions {
    
    static var ref = Database.database().reference()

    static func sendNotification(users: Array<User>, title : String, message : String){
        for user in users {
            ref.child("fcmTokens").child(user.phoneNumber).child("token").getData(completion:  { error, fcmTokenSnapshot in
                let token = fcmTokenSnapshot.value as? String ?? ""
                postRequest(fcmToken: token, title: title, message: message)
            })
        }
    }
    
    static func postRequest(fcmToken : String, title: String, message : String) {
        let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
        let postParams = ["to": fcmToken, "notification": ["body": message, "title": title, "sound": "default"]] as [String : Any]
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAu2rSefM:APA91bFa3h50iejCE77zayaKR_mMhHJJRgcBjx28VMX0XI23OxlARJFbiDZdmapp55UfLjQBP4lio8_QN9E1aciDZTpDhBqfc8vKlvTQEXVMobZ-U4MlypXLSVwOAsLyUIhZRywz6CYU", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: .prettyPrinted)
        } catch {
            print("Caught an error: \(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in }
        task.resume()
    }
    
    static func getDayOfWeek() -> Int {
        return max(Calendar.current.component(.weekday, from: Date()) - 1, 0)
    }
    
    static func getDaysLeftInCycle() -> Int {
        return 7 - getDayOfWeek()
    }
    
    static func convertFrequencyToNum(frequencyWord : String) -> Int {
        switch frequencyWord {
        case "Once":
            return 1
        case "2x":
            return 2
        case "3x":
            return 3
        case "4x":
            return 4
        case "5x":
            return 5
        case "6x":
            return 6
        case "7x":
            return 7
        default:
            return 1
        }
    }
    
    static func convertFrequencyToString(frequency : Int) -> String {
        switch frequency {
        case 1:
            return "Once"
        case 2:
            return "2x"
        case 3:
            return "3x"
        case 4:
            return "4x"
        case 5:
            return "5x"
        case 6:
            return "6x"
        case 7:
            return "7x"
        default:
            return "Once"
        }
    }
}

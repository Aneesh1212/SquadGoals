//
//  NotificationViewModel.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 1/9/22.
//

import Foundation


class NotificationViewModel {
    
    func postRequest() {
        let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
        let postParams = ["to": "fAxWfrDU1082he5KJjW5Wm:APA91bF3CaeGFBeIsX5Ba4NpbSg0tDQYEdSFWUSgqfNKXKB6awJKXCP-erznpJzBl02ux5s6kUK_wuk5GREw-lWmp3iooub7fL3byFqMWe8Eo2PHNRxNhh7tRqK98aSAKNOahh8r4a7N", "notification": ["body": "This is the body.", "title": "This is the title."]] as [String : Any]

        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAu2rSefM:APA91bFa3h50iejCE77zayaKR_mMhHJJRgcBjx28VMX0XI23OxlARJFbiDZdmapp55UfLjQBP4lio8_QN9E1aciDZTpDhBqfc8vKlvTQEXVMobZ-U4MlypXLSVwOAsLyUIhZRywz6CYU", forHTTPHeaderField: "Authorization")

        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: .prettyPrinted)
            print("My paramaters: \(postParams)")
        }
        catch
        {
            print("Caught an error: \(error)")
        }

        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in

            if let realResponse = response as? HTTPURLResponse
            {
                if realResponse.statusCode != 200
                {
                    print("Not a 200 response")
                }
            }
            guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
                }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }

            let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
        }

        task.resume()
    }
}

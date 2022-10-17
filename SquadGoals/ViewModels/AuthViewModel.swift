//
//  LoginViewModel.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/15/21.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseAuth

/*
class AuthViewModel : ObservableObject {
    @Published var phoneNumber = ""
    @Published var verificationCode = ""
    
    private var verificationID : String? = ""
    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    
    private var user : User?

    
    func sendVerificationCode() {
        print("Send Verification code \(phoneNumber)")
        PhoneAuthProvider.provider()
          .verifyPhoneNumber("+1" + phoneNumber, uiDelegate: nil) { verificationID, error in
              
              // Sign in using the verificationID and the code sent to the user
              // ...
              self.verificationID = verificationID
          }
    }
    
    
    func verifyCode() {
        print("Verify Code")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID ?? "",
            verificationCode: verificationCode)
        
        
        auth.signIn(with : credential) {result, error in
            print(result)
            print(error)
        }
        
        self.user = auth.currentUser
        auth.apnsToken
        
        print(auth.currentUser?.phoneNumber)
        print(auth.currentUser?.uid)
    }
    
    func setUserName(userName : String) {
        print("Set User Name")
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = userName
        changeRequest?.commitChanges { error in
          print(error)
        }
        print(Auth.auth().currentUser?.displayName)
    }
    
    func getUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func getGroupName(groupId: String) {
        let docRef = db.collection("GroupInfo").document(groupId)
        var groupName : String = ""
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
}
 */

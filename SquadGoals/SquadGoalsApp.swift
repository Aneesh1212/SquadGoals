//
//  Goal2App.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/15/21.
//

import SwiftUI
import Firebase

@main
struct SquadGoalsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .light) // or .dark
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
        
        print("SwiftUI_2_Lifecycle_PhoneNumber_AuthApp application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
            print("YAAA")
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
                print(error.localizedDescription)
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserDefaults.standard.set(token, forKey: "fcmToken")
            }
        }
        
        print("YAAA")
        
        
        application.registerForRemoteNotifications()
        return true
    }
}

extension AppDelegate : MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // ...
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // ...
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
}

//
//  AppDelegate.swift
//  Checklist
//
//  Created by fredrick osuala on 15/09/2023.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
//            if granted {
//                print("We have permission")
//                center.delegate = self
//             } else {
//                 print("Permission denied")
//             }
//        }
//
//        let content = UNMutableNotificationContent()
//        content.title = "Hello"
//        content.body = "This is a test notification"
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//
//        let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)
//        center.add(request)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK: - UNNotification delegate
    //when notification is posted and the app is still running
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received local notification \(notification)")
    }


}


//
//  AppDelegate.swift
//  DanjamRenew
//
//  Created by jose Yun on 12/12/23.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  var notifDelegate = NotificationDelegate()
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = notifDelegate
    return true
  }
}

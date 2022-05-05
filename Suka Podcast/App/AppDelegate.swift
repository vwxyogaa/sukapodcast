//
//  AppDelegate.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UINavigationBar.appearance().barTintColor = .brand2
    UINavigationBar.appearance().tintColor = .neutral1
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.neutral1]
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.neutral1]
    UITabBar.appearance().barTintColor = .brand2
    IQKeyboardManager.shared.enable = true
    FirebaseApp.configure()
    let window = UIWindow(frame: UIScreen.main.bounds)
    if Auth.auth().currentUser == nil {
      window.rootViewController = FtuxViewController()
    } else {
      window.rootViewController = MainViewController()
    }
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
  
  // MARK: - UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

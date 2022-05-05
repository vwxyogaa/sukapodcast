//
//  SceneDelegate.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    // check if user is login or not
    if Auth.auth().currentUser == nil {
      window.rootViewController = FtuxViewController()
    } else {
      window.rootViewController = MainViewController()
    }
    window.makeKeyAndVisible()
    self.window = window
  }
}


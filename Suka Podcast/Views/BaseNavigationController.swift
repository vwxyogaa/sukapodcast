//
//  BaseNavigationController.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class BaseNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

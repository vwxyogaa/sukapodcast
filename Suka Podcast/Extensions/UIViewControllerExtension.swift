//
//  UIViewControllerExtension.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import Foundation
import UIKit

extension UIViewController {
  @objc func backButtonTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func closeButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func presentAlert(title: String?, message: String?, completion: @escaping (UIAlertAction) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
    present(alert, animated: true)
  }
}

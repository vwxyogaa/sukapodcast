//
//  SecondaryButton.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class SecondaryButton: UIButton {
  convenience init() {
    self.init(type: .system)
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  func setup() {
    tintColor = UIColor.brand1
    contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    layer.cornerRadius = 4
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.brand1.cgColor
  }
}

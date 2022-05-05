//
//  PrimaryButton.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class PrimaryButton: UIButton {
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
    tintColor = UIColor.neutral3
    backgroundColor = UIColor.brand1
    titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    layer.cornerRadius = 4
    layer.masksToBounds = true
  }
}

//
//  SmallPrimaryButton.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class SmallPrimaryButton: PrimaryButton {
  override func setup() {
    super.setup()
    titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    layer.cornerRadius = 3
  }
}

//
//  CustomTextField.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class CustomTextField: UITextField {
  enum InputType {
    case name
    case email
    case password
    case phone
    case undefined
  }
  
  private weak var underlineView: UIView!
  private weak var secureButton: UIButton?
  private var inputType: InputType = .undefined
  
  convenience init(inputType: InputType) {
    self.init(frame: .zero)
    self.inputType = inputType
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
  
  override var isSelected: Bool {
    didSet {
      update()
    }
  }
  
  override var text: String? {
    didSet {
      update()
    }
  }
  
  override var placeholder: String? {
    didSet {
      update()
    }
  }
  
  override var isSecureTextEntry: Bool {
    didSet {
      update()
    }
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let isUndefined = inputType == .undefined
    let isPassword = inputType == .password
    return bounds.inset(by: UIEdgeInsets(top: 0, left: isUndefined ? 8 : 36, bottom: 0, right: isPassword ? 36 : 8))
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    let isUndefined = inputType == .undefined
    let isPassword = inputType == .password
    return bounds.inset(by: UIEdgeInsets(top: 0, left: isUndefined ? 8 : 36, bottom: 0, right: isPassword ? 36 : 8))
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let isUndefined = inputType == .undefined
    let isPassword = inputType == .password
    return bounds.inset(by: UIEdgeInsets(top: 0, left: isUndefined ? 8 : 36, bottom: 0, right: isPassword ? 36 : 8))
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 96, height: 46)
  }
  
  func setup() {
    tintColor = UIColor.neutral1
    textColor = UIColor.neutral1
    font = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    // Setup underline view
    let underlineView = UIView(frame: .zero)
    addSubview(underlineView)
    self.underlineView = underlineView
    underlineView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      underlineView.heightAnchor.constraint(equalToConstant: 1),
      underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
      underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
      underlineView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
    // Setup left/right view
    switch inputType {
    case .name:
      textContentType = .name
      keyboardType = .default
      autocapitalizationType = .words
      
      // Add left view
      let imageView = UIImageView(image: UIImage(named: "icn_name"))
      leftView = imageView
      leftViewMode = .always
      
    case .email:
      textContentType = .emailAddress
      keyboardType = .emailAddress
      autocapitalizationType = .none
      
      // Add left view
      let imageView = UIImageView(image: UIImage(named: "icn_email"))
      leftView = imageView
      leftViewMode = .always
      
    case .password:
      if #available(iOS 11.0, *) {
        textContentType = .password
      }
      keyboardType = .default
      autocapitalizationType = .none
      isSecureTextEntry = true
      
      // Add left view
      let imageView = UIImageView(image: UIImage(named: "icn_password"))
      leftView = imageView
      leftViewMode = .always
      
      // Add right view
      let button = UIButton(type: .system)
      button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
      button.setTitle(nil, for: .normal)
      button.addTarget(self, action: #selector(self.secureButtonTapped(_:)), for: .touchUpInside)
      rightView = button
      self.secureButton = button
      rightViewMode = .always
      
    case .phone:
      textContentType = .telephoneNumber
      keyboardType = .phonePad
      autocapitalizationType = .none
      
      // Add left view
      let imageView = UIImageView(image: UIImage(named: "icn_phone"))
      leftView = imageView
      leftViewMode = .always
      
    case .undefined:
      textContentType = .none
      keyboardType = .default
      autocapitalizationType = .none
    }
    
    // Observe text field editing state
    let observeEditingEvents: () -> Void = { [unowned self] in
      self.addTarget(self, action: #selector(self.editingDidBegin(_:)), for: .editingDidBegin)
      self.addTarget(self, action: #selector(self.editingDidEnd(_:)), for: .editingDidEnd)
    }
    observeEditingEvents()
    
    // Just update after setup
    update()
  }
  
  func update() {
    attributedPlaceholder = NSAttributedString(
      string: placeholder ?? "",
      attributes: [
        .font: UIFont.systemFont(ofSize: 14, weight: .regular),
        .foregroundColor: UIColor(rgb: 0x9F9F9F)
      ]
    )
    underlineView.backgroundColor = isEditing ? UIColor.neutral1 : (text ?? "").count > 0 ? UIColor.neutral1 : UIColor.white.withAlphaComponent(0.2)
    secureButton?.setImage(UIImage(named: isSecureTextEntry ? "icn_secure" : "icn_unsecure")?.withRenderingMode(.alwaysOriginal), for: .normal)
  }
  
  @objc func secureButtonTapped(_ sender: Any) {
    isSecureTextEntry = !isSecureTextEntry
  }
  
  @objc func editingDidBegin(_ sender: Any) {
    update()
  }
  
  @objc func editingDidEnd(_ sender: Any) {
    update()
  }
}

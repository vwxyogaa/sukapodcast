//
//  SignUpViewController.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
  // MARK: - Views
  lazy var titleSignUpLabel: UILabel = {
    let titleSignUpLabel = UILabel()
    titleSignUpLabel.text = "Sign Up"
    titleSignUpLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
    titleSignUpLabel.textColor = .white
    return titleSignUpLabel
  }()
  
  lazy var nameTextField: CustomTextField = {
    let nameTextField = CustomTextField(inputType: .name)
    nameTextField.placeholder = "Name"
    return nameTextField
  }()
  
  lazy var emailTextField: CustomTextField = {
    let emailTextField = CustomTextField(inputType: .email)
    emailTextField.placeholder = "Email"
    return emailTextField
  }()
  
  lazy var passwordTextField: CustomTextField = {
    let passwordTextField = CustomTextField(inputType: .password)
    passwordTextField.placeholder = "Password"
    return passwordTextField
  }()
  
  lazy var signUpButton: PrimaryButton = {
    let signUpButton = PrimaryButton()
    signUpButton.setTitle("Sign Up", for: .normal)
    return signUpButton
  }()
  
  lazy var signInButton: GhostButton = {
    let signInButton = GhostButton()
    signInButton.setTitle("Sign In", for: .normal)
    signInButton.tintColor = UIColor.neutral1
    return signInButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupTitleSignUpLabel()
    setupNameTextField()
    setupEmailTextField()
    setupPasswordTextField()
    setupSignUpButton()
    setupSignInButton()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Helpers
  func setupViews() {
    view.backgroundColor = .brand2
  }
  
  private func setupTitleSignUpLabel() {
    view.addSubview(titleSignUpLabel)
    titleSignUpLabel.translatesAutoresizingMaskIntoConstraints = false
    titleSignUpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    titleSignUpLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
  }
  
  private func setupNameTextField() {
    view.addSubview(nameTextField)
    nameTextField.translatesAutoresizingMaskIntoConstraints = false
    nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    nameTextField.topAnchor.constraint(equalTo: titleSignUpLabel.bottomAnchor, constant: 60).isActive = true
  }
  
  private func setupEmailTextField() {
    view.addSubview(emailTextField)
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24).isActive = true
  }
  
  private func setupPasswordTextField() {
    view.addSubview(passwordTextField)
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24).isActive = true
  }
  
  private func setupSignUpButton() {
    view.addSubview(signUpButton)
    signUpButton.translatesAutoresizingMaskIntoConstraints = false
    signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 64).isActive = true
    signUpButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
    signUpButton.addTarget(self, action: #selector(self.signUpButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupSignInButton() {
    view.addSubview(signInButton)
    signInButton.translatesAutoresizingMaskIntoConstraints = false
    signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 12).isActive = true
    signInButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 24).isActive = true
    signInButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
    signInButton.addTarget(self, action: #selector(self.backButtonTapped(_:)), for: .touchUpInside)
  }
  
  func isValid() -> Bool {
    guard let name = nameTextField.text, name.count >= 3 else {
      let alert = UIAlertController(title: "Oops!", message: "Invalid name", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
      self.present(alert, animated: true)
      return false
    }
    
    guard let email = emailTextField.text, email.isValidEmail else {
      let alert = UIAlertController(title: "Oops!", message: "Invalid email", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
      self.present(alert, animated: true)
      return false
    }
    
    guard let password = passwordTextField.text, password.isValidPassword else {
      let alert = UIAlertController(title: "Oops!", message: "Invalid password", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
      self.present(alert, animated: true)
      return false
    }
    return true
  }
}

// MARK: - SignUp with Firebase
extension SignUpViewController {
  @objc func signUpButtonTapped(_ sender: Any) {
    if isValid() {
      signUpWithEmailPassword()
    }
  }
  
  func signUpWithEmailPassword() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let error = error as? NSError {
        switch AuthErrorCode(rawValue: error.code) {
        case .emailAlreadyInUse:
          print("The email address is already in use by another account")
          let alert = UIAlertController(title: "Oops", message: "The email address is already in use by another account", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
          self.present(alert, animated: true)
        default:
          print("Error: \(error.localizedDescription)")
        }
      } else {
        print("User signs up successfully")
        let request = authResult?.user.createProfileChangeRequest()
        request?.displayName = self.nameTextField.text ?? ""
        request?.commitChanges(completion: { error in
          if let error = error {
            print("Error: \(error.localizedDescription)")
          }
          self.navigationController?.popToRootViewController(animated: true)
        })
      }
    }
  }
}

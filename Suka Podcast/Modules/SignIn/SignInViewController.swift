//
//  SignInViewController.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
import CryptoKit

fileprivate var currentNonce: String?

class SignInViewController: UIViewController {
  // MARK: - Views
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    return scrollView
  }()
  
  lazy var contentView: UIView = {
    let contentView = UIView()
    return contentView
  }()
  
  lazy var titleSignInLabel: UILabel = {
    let titleSignInLabel = UILabel()
    titleSignInLabel.textColor = .white
    titleSignInLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
    titleSignInLabel.text = "Sign In"
    return titleSignInLabel
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
  
  lazy var forgotPasswordButton: SmallGhostButton = {
    let forgotPasswordButton = SmallGhostButton()
    forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
    forgotPasswordButton.setTitleColor(UIColor.neutral1, for: .normal)
    return forgotPasswordButton
  }()
  
  lazy var signInButton: PrimaryButton = {
    let signInButton = PrimaryButton()
    signInButton.setTitle("Sign In", for: .normal)
    return signInButton
  }()
  
  lazy var connectWithStackView: UIStackView = {
    let connectWithStackView = UIStackView()
    connectWithStackView.axis = .horizontal
    connectWithStackView.distribution = .fill
    connectWithStackView.alignment = .fill
    connectWithStackView.spacing = 16
    return connectWithStackView
  }()
  
  lazy var signInWithStackView: UIStackView = {
    let signInWithStackView = UIStackView()
    signInWithStackView.axis = .horizontal
    signInWithStackView.distribution = .fill
    signInWithStackView.alignment = .fill
    signInWithStackView.spacing = 12
    return signInWithStackView
  }()
  
  lazy var facebookButton: UIButton = {
    let facebookButton = UIButton(type: .system)
    facebookButton.setTitle(nil, for: .normal)
    facebookButton.setImage(UIImage(named: "iconFacebook")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return facebookButton
  }()
  
  lazy var googleButton: UIButton = {
    let googleButton = UIButton(type: .system)
    googleButton.setTitle(nil, for: .normal)
    googleButton.setImage(UIImage(named: "iconGoogle")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return googleButton
  }()
  
  lazy var twitterButton: UIButton = {
    let twitterButton = UIButton(type: .system)
    twitterButton.setTitle(nil, for: .normal)
    twitterButton.setImage(UIImage(named: "iconTwitter")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return twitterButton
  }()
  
  lazy var appleButton: ASAuthorizationAppleIDButton = {
    let appleButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
    return appleButton
  }()
  
  lazy var signUpStackView: UIStackView = {
    let signUpStackView = UIStackView()
    signUpStackView.axis = .horizontal
    signUpStackView.distribution = .fill
    signUpStackView.alignment = .fill
    signUpStackView.spacing = 4
    return signUpStackView
  }()
  
  lazy var signUpTitleLabel: UILabel = {
    let signUpTitleLabel = UILabel()
    signUpTitleLabel.text = "Don't have an account?"
    signUpTitleLabel.textColor = .white
    signUpTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    return signUpTitleLabel
  }()
  
  lazy var signUpButton: SmallGhostButton = {
    let signUpButton = SmallGhostButton()
    signUpButton.setTitle("Sign Up", for: .normal)
    signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    return signUpButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupScrollView()
    setupContentView()
    setupTitleSignInLabel()
    setupEmailTextField()
    setupPasswordTextField()
    setupForgotPasswordButton()
    setupSignInButton()
    setupOrConnectWith()
    setupIconSignInButton()
    setupSignUpButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Helpers
  func setupViews() {
    view.backgroundColor = .brand2
  }
  
  private func setupScrollView() {
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func setupContentView() {
    scrollView.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    ])
  }
  
  private func setupTitleSignInLabel() {
    contentView.addSubview(titleSignInLabel)
    titleSignInLabel.translatesAutoresizingMaskIntoConstraints = false
    titleSignInLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    titleSignInLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
  }
  
  private func setupEmailTextField() {
    contentView.addSubview(emailTextField)
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
    emailTextField.topAnchor.constraint(equalTo: titleSignInLabel.bottomAnchor, constant: 60).isActive = true
    
  }
  
  private func setupPasswordTextField() {
    contentView.addSubview(passwordTextField)
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
    passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24).isActive = true
  }
  
  private func setupForgotPasswordButton() {
    contentView.addSubview(forgotPasswordButton)
    forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
    forgotPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
    forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24).isActive = true
  }
  
  private func setupSignInButton() {
    contentView.addSubview(signInButton)
    signInButton.translatesAutoresizingMaskIntoConstraints = false
    signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
    signInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 40).isActive = true
    signInButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
    signInButton.addTarget(self, action: #selector(signInButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupOrConnectWith() {
    let lineOneContainer = UIView(frame: .zero)
    connectWithStackView.addArrangedSubview(lineOneContainer)
    lineOneContainer.backgroundColor = .clear
    
    let underlineOneView = UIView(frame: .zero)
    lineOneContainer.addSubview(underlineOneView)
    underlineOneView.backgroundColor = UIColor(rgb: 0x8D92A3)
    underlineOneView.translatesAutoresizingMaskIntoConstraints = false
    underlineOneView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    underlineOneView.leadingAnchor.constraint(equalTo: lineOneContainer.leadingAnchor).isActive = true
    underlineOneView.trailingAnchor.constraint(equalTo: lineOneContainer.trailingAnchor).isActive = true
    underlineOneView.centerYAnchor.constraint(equalTo: lineOneContainer.centerYAnchor).isActive = true
    
    let connectWithLabel = UILabel(frame: .zero)
    connectWithStackView.addArrangedSubview(connectWithLabel)
    connectWithLabel.text = "Or connect with"
    connectWithLabel.textColor = UIColor(rgb: 0x8D92A3)
    connectWithLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    connectWithLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
    let lineTwoContainer = UIView(frame: .zero)
    connectWithStackView.addArrangedSubview(lineTwoContainer)
    lineTwoContainer.backgroundColor = .clear
    
    let underlineTwoView = UIView(frame: .zero)
    lineTwoContainer.addSubview(underlineTwoView)
    underlineTwoView.backgroundColor = UIColor(rgb: 0x8D92A3)
    underlineTwoView.translatesAutoresizingMaskIntoConstraints = false
    underlineTwoView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    underlineTwoView.leadingAnchor.constraint(equalTo: lineTwoContainer.leadingAnchor).isActive = true
    underlineTwoView.trailingAnchor.constraint(equalTo: lineTwoContainer.trailingAnchor).isActive = true
    underlineTwoView.centerYAnchor.constraint(equalTo: lineTwoContainer.centerYAnchor).isActive = true
    
    lineTwoContainer.widthAnchor.constraint(equalTo: lineOneContainer.widthAnchor).isActive = true
    
    contentView.addSubview(connectWithStackView)
    connectWithStackView.translatesAutoresizingMaskIntoConstraints = false
    connectWithStackView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 60).isActive = true
    connectWithStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    connectWithStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
  }
  
  private func setupIconSignInButton() {
    signInWithStackView.addArrangedSubview(facebookButton)
    facebookButton.translatesAutoresizingMaskIntoConstraints = false
    facebookButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    facebookButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    signInWithStackView.addArrangedSubview(googleButton)
    googleButton.translatesAutoresizingMaskIntoConstraints = false
    googleButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    googleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    signInWithStackView.addArrangedSubview(twitterButton)
    twitterButton.translatesAutoresizingMaskIntoConstraints = false
    twitterButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    twitterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    signInWithStackView.addArrangedSubview(appleButton)
    appleButton.layer.cornerRadius = 20
    appleButton.layer.masksToBounds = true
    appleButton.translatesAutoresizingMaskIntoConstraints = false
    //            appleButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    appleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    appleButton.addTarget(self, action: #selector(self.appleButtonTapped(_:)), for: .touchUpInside)
    
    contentView.addSubview(signInWithStackView)
    signInWithStackView.translatesAutoresizingMaskIntoConstraints = false
    signInWithStackView.topAnchor.constraint(equalTo: connectWithStackView.bottomAnchor, constant: 8).isActive = true
    signInWithStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
  }
  
  private func setupSignUpButton() {
    signUpStackView.addArrangedSubview(signUpTitleLabel)
    signUpStackView.addArrangedSubview(signUpButton)
    signUpButton.addTarget(self, action: #selector(self.signUpButtonTapped(_:)), for: .touchUpInside)
    
    contentView.addSubview(signUpStackView)
    signUpStackView.translatesAutoresizingMaskIntoConstraints = false
    signUpStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    signUpStackView.topAnchor.constraint(equalTo: signInWithStackView.bottomAnchor, constant: 100).isActive = true
    signUpStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
  }
  
  func isValid() -> Bool {
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
  
  // MARK: - Actions
  @objc private func signUpButtonTapped(_ sender: Any) {
    let viewController = SignUpViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

// MARK: - Signin with Firebase
extension SignInViewController {
  @objc private func signInButtonTapped(_ sender: Any) {
    if isValid() {
      signInWithEmailFirebase()
    }
  }
  
  func signInWithEmailFirebase() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if let error = error as? NSError {
        switch AuthErrorCode(rawValue: error.code) {
        case .wrongPassword:
          let alert = UIAlertController(title: "Oops", message: "Invalid password", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
          self.present(alert, animated: true)
        default:
          print("Error: \(error.localizedDescription)")
          let alert = UIAlertController(title: "Oops", message: "This email may have been unverified or invalid password", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
          self.present(alert, animated: true)
        }
      } else {
        print("User signs in successfully")
        let viewController = MainViewController()
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = viewController
      }
    }
  }
}

// MARK: - Signin with Apple ID
extension SignInViewController {
  @objc func appleButtonTapped(_ sender: Any) {
    startSignInWithAppleFlow()
  }
  
  // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
          )
        }
        return random
      }
      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }
        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    return result
  }
  
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
  
  func startSignInWithAppleFlow() {
    let nonce = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
          print(error.localizedDescription)
          return
        }
        print("User is signed in to Firebase with Apple.")
        let viewController = MainViewController()
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = viewController
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Sign in with Apple errored: \(error)")
  }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return view.window!
  }
}

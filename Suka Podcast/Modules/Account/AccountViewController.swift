//
//  AccountViewController.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
  private var profileData: ProfileDataModel?
  private var id: Int = 0
  
  // MARK: - Views
  lazy var photoImageView: UIImageView = {
    let photoImageView = UIImageView()
    photoImageView.layer.borderColor = UIColor.neutral1.cgColor
    photoImageView.layer.borderWidth = 1
    photoImageView.layer.cornerRadius = 40
    photoImageView.layer.masksToBounds = true
    photoImageView.contentMode = .scaleAspectFill
    return photoImageView
  }()
  
  lazy var usernameLabel: UILabel = {
    let usernameLabel = UILabel()
    usernameLabel.textColor = .neutral1
    usernameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    return usernameLabel
  }()
  
  lazy var editProfileButton: UIButton = {
    let editProfileButton = UIButton(type: .system)
    editProfileButton.setTitle("Edit", for: .normal)
    editProfileButton.backgroundColor = .brand1
    editProfileButton.tintColor = .black
    editProfileButton.layer.cornerRadius = 4
    editProfileButton.layer.masksToBounds = true
    editProfileButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 24, bottom: 5, right: 24)
    return editProfileButton
  }()
  
  lazy var settingIcon: UIImageView = {
    let settingIcon = UIImageView()
    settingIcon.image = UIImage(named: "settingIcon")
    return settingIcon
  }()
  
  lazy var settingLabel: UILabel = {
    let settingLabel = UILabel()
    settingLabel.text = "Setting"
    settingLabel.textColor = .white
    settingLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return settingLabel
  }()
  
  lazy var settingChevron: UIImageView = {
    let settingChevron = UIImageView()
    settingChevron.image = UIImage(named: "chevronRight")
    return settingChevron
  }()
  
  lazy var historyIcon: UIImageView = {
    let historyIcon = UIImageView()
    historyIcon.image = UIImage(named: "historyIcon")
    return historyIcon
  }()
  
  lazy var historyLabel: UILabel = {
    let historyLabel = UILabel()
    historyLabel.text = "History"
    historyLabel.textColor = .white
    historyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return historyLabel
  }()
  
  lazy var historyChevron: UIImageView = {
    let historyChevron = UIImageView()
    historyChevron.image = UIImage(named: "chevronRight")
    return historyChevron
  }()
  
  lazy var downloadIcon: UIImageView = {
    let downloadIcon = UIImageView()
    downloadIcon.image = UIImage(named: "downloadIcon")
    return downloadIcon
  }()
  
  lazy var downloadLabel: UILabel = {
    let downloadLabel = UILabel()
    downloadLabel.text = "Download"
    downloadLabel.textColor = .white
    downloadLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return downloadLabel
  }()
  
  lazy var downloadChevron: UIImageView = {
    let downloadChevron = UIImageView()
    downloadChevron.image = UIImage(named: "chevronRight")
    return downloadChevron
  }()
  
  lazy var watchLaterIcon: UIImageView = {
    let watchLaterIcon = UIImageView()
    watchLaterIcon.image = UIImage(named: "watchLaterIcon")
    return watchLaterIcon
  }()
  
  lazy var watchLaterLabel: UILabel = {
    let watchLaterLabel = UILabel()
    watchLaterLabel.text = "Watch Later"
    watchLaterLabel.textColor = .white
    watchLaterLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return watchLaterLabel
  }()
  
  lazy var watchLaterChevron: UIImageView = {
    let watchLaterChevron = UIImageView()
    watchLaterChevron.image = UIImage(named: "chevronRight")
    return watchLaterChevron
  }()
  
  lazy var signOutButton: SecondaryButton = {
    let signOutButton = SecondaryButton()
    signOutButton.setTitle("Sign Out", for: .normal)
    return signOutButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupPhotoImageView()
    setupUsernameLabel()
    setupEditProfileButton()
    setupSettingIcon()
    setupSettingLabel()
    setupSettingChevron()
    setupHistoryIcon()
    setupHistoryLabel()
    setupHistoryChevron()
    setupDownloadIcon()
    setupDownloadLabel()
    setupDownloadChevron()
    setupWatchLaterIcon()
    setupWatchLaterLabel()
    setupWatchLaterChevron()
    setupSignOutButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupData()
  }
  
  // MARK: - Helpers
  private func setupViews() {
    title = "Account"
    navigationController?.navigationBar.prefersLargeTitles = true
    view.backgroundColor = .brand2
  }
  
  private func setupPhotoImageView() {
    view.addSubview(photoImageView)
    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoImageView.widthAnchor.constraint(equalToConstant: 80),
      photoImageView.heightAnchor.constraint(equalToConstant: 80),
      photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
    ])
  }
  
  private func setupUsernameLabel() {
    view.addSubview(usernameLabel)
    usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      usernameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
      usernameLabel.topAnchor.constraint(equalTo: photoImageView.topAnchor),
      usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
    ])
  }
  
  private func setupEditProfileButton() {
    view.addSubview(editProfileButton)
    editProfileButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      editProfileButton.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
      editProfileButton.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor)
    ])
    editProfileButton.addTarget(self, action: #selector(self.editProfileButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupSettingIcon() {
    view.addSubview(settingIcon)
    settingIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      settingIcon.widthAnchor.constraint(equalToConstant: 25),
      settingIcon.heightAnchor.constraint(equalToConstant: 25),
      settingIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      settingIcon.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 40)
    ])
  }
  
  private func setupSettingLabel() {
    view.addSubview(settingLabel)
    settingLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      settingLabel.leadingAnchor.constraint(equalTo: settingIcon.trailingAnchor, constant: 20),
      settingLabel.centerYAnchor.constraint(equalTo: settingIcon.centerYAnchor)
    ])
  }
  
  private func setupSettingChevron() {
    view.addSubview(settingChevron)
    settingChevron.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      settingChevron.widthAnchor.constraint(equalToConstant: 15),
      settingChevron.heightAnchor.constraint(equalToConstant: 15),
      settingChevron.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      settingChevron.leadingAnchor.constraint(equalTo: settingLabel.trailingAnchor, constant: 20),
      settingChevron.centerYAnchor.constraint(equalTo: settingIcon.centerYAnchor)
    ])
  }
  
  private func setupHistoryIcon() {
    view.addSubview(historyIcon)
    historyIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      historyIcon.widthAnchor.constraint(equalToConstant: 25),
      historyIcon.heightAnchor.constraint(equalToConstant: 25),
      historyIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      historyIcon.topAnchor.constraint(equalTo: settingIcon.bottomAnchor, constant: 20)
    ])
  }
  
  private func setupHistoryLabel() {
    view.addSubview(historyLabel)
    historyLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      historyLabel.leadingAnchor.constraint(equalTo: historyIcon.trailingAnchor, constant: 20),
      historyLabel.centerYAnchor.constraint(equalTo: historyIcon.centerYAnchor)
    ])
  }
  
  private func setupHistoryChevron() {
    view.addSubview(historyChevron)
    historyChevron.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      historyChevron.widthAnchor.constraint(equalToConstant: 15),
      historyChevron.heightAnchor.constraint(equalToConstant: 15),
      historyChevron.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      historyChevron.leadingAnchor.constraint(equalTo: historyLabel.trailingAnchor, constant: 20),
      historyChevron.centerYAnchor.constraint(equalTo: historyIcon.centerYAnchor)
    ])
  }
  
  private func setupDownloadIcon() {
    view.addSubview(downloadIcon)
    downloadIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      downloadIcon.widthAnchor.constraint(equalToConstant: 25),
      downloadIcon.heightAnchor.constraint(equalToConstant: 25),
      downloadIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      downloadIcon.topAnchor.constraint(equalTo: historyIcon.bottomAnchor, constant: 20)
    ])
  }
  
  private func setupDownloadLabel() {
    view.addSubview(downloadLabel)
    downloadLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      downloadLabel.leadingAnchor.constraint(equalTo: downloadIcon.trailingAnchor, constant: 20),
      downloadLabel.centerYAnchor.constraint(equalTo: downloadIcon.centerYAnchor)
    ])
  }
  
  private func setupDownloadChevron() {
    view.addSubview(downloadChevron)
    downloadChevron.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      downloadChevron.widthAnchor.constraint(equalToConstant: 15),
      downloadChevron.heightAnchor.constraint(equalToConstant: 15),
      downloadChevron.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      downloadChevron.leadingAnchor.constraint(equalTo: downloadLabel.trailingAnchor, constant: 20),
      downloadChevron.centerYAnchor.constraint(equalTo: downloadIcon.centerYAnchor)
    ])
  }
  
  private func setupWatchLaterIcon() {
    view.addSubview(watchLaterIcon)
    watchLaterIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      watchLaterIcon.widthAnchor.constraint(equalToConstant: 25),
      watchLaterIcon.heightAnchor.constraint(equalToConstant: 25),
      watchLaterIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      watchLaterIcon.topAnchor.constraint(equalTo: downloadIcon.bottomAnchor, constant: 20)
    ])
  }
  
  private func setupWatchLaterLabel() {
    view.addSubview(watchLaterLabel)
    watchLaterLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      watchLaterLabel.leadingAnchor.constraint(equalTo: watchLaterIcon.trailingAnchor, constant: 20),
      watchLaterLabel.centerYAnchor.constraint(equalTo: watchLaterIcon.centerYAnchor)
    ])
  }
  
  private func setupWatchLaterChevron() {
    view.addSubview(watchLaterChevron)
    watchLaterChevron.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      watchLaterChevron.widthAnchor.constraint(equalToConstant: 15),
      watchLaterChevron.heightAnchor.constraint(equalToConstant: 15),
      watchLaterChevron.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      watchLaterChevron.leadingAnchor.constraint(equalTo: watchLaterLabel.trailingAnchor, constant: 20),
      watchLaterChevron.centerYAnchor.constraint(equalTo: watchLaterIcon.centerYAnchor)
    ])
  }
  
  private func setupSignOutButton() {
    view.addSubview(signOutButton)
    signOutButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      signOutButton.topAnchor.constraint(equalTo: watchLaterIcon.bottomAnchor, constant: 40),
      signOutButton.heightAnchor.constraint(equalToConstant: 46),
      signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
    ])
    signOutButton.addTarget(self, action: #selector(self.signOutButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func showSignInViewController() {
    let viewController = SignInViewController()
    let navigationController = BaseNavigationController(rootViewController: viewController)
    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    window?.rootViewController = navigationController
  }
  
  private func setupData() {
    let user = Auth.auth().currentUser
    self.usernameLabel.text = user?.displayName
    ProfileProvider.shared.getProfile { profiles in
      DispatchQueue.main.async {
        if let image = profiles.image {
          self.photoImageView.image = UIImage(data: image)
        }
      }
    }
  }
  
  // MARK: - Actions
  @objc private func signOutButtonTapped(_ sender: Any) {
    let firebaseAuth = Auth.auth()
    let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
      do {
        PlayerProvider.shared.closePodcastPlayer()
        try firebaseAuth.signOut()
        self.showSignInViewController()
      } catch let signOutError as NSError {
        print("Error signing out: %@", signOutError)
      }
    }))
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in }))
    present(alert, animated: true, completion: nil)
  }
  
  @objc private func editProfileButtonTapped(_ sender: Any) {
    let viewController = EditProfileViewController()
    viewController.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(viewController, animated: true)
  }
}

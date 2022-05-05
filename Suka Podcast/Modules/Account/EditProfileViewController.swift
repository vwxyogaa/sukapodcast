//
//  EditProfileViewController.swift
//  Suka Podcast
//
//  Created by yxgg on 05/05/22.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
  private let imagePicker = UIImagePickerController()
  var id: Int = 0
  
  // MARK: - Views
  lazy var profileImage: UIImageView = {
    let profileImage = UIImageView()
    profileImage.layer.borderColor = UIColor.neutral1.cgColor
    profileImage.layer.borderWidth = 1
    profileImage.layer.cornerRadius = 100
    profileImage.layer.masksToBounds = true
    profileImage.contentMode = .scaleAspectFill
    return profileImage
  }()
  
  lazy var getImageButton: UIButton = {
    let getImageButton = UIButton(type: .system)
    getImageButton.setImage(UIImage(systemName: "camera"), for: .normal)
    getImageButton.layer.cornerRadius = 25
    getImageButton.layer.masksToBounds = true
    getImageButton.tintColor = .white
    getImageButton.backgroundColor = .black
    return getImageButton
  }()
  
  lazy var usernameTextField: UITextField = {
    let usernameTextField = UITextField()
    usernameTextField.attributedPlaceholder = NSAttributedString(
      string: "Username",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.neutral2]
    )
    usernameTextField.layer.borderColor = UIColor.neutral1.cgColor
    usernameTextField.layer.borderWidth = 1
    usernameTextField.layer.cornerRadius = 5
    usernameTextField.layer.masksToBounds = true
    usernameTextField.backgroundColor = .clear
    usernameTextField.textColor = .neutral1
    usernameTextField.tintColor = .neutral1
    usernameTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: usernameTextField.frame.height))
    usernameTextField.leftViewMode = .always
    return usernameTextField
  }()
  
  lazy var saveButton: UIButton = {
    let saveButton = UIButton(type: .system)
    saveButton.setTitle("Save", for: .normal)
    saveButton.backgroundColor = .brand1
    saveButton.tintColor = .black
    saveButton.layer.cornerRadius = 4
    saveButton.layer.masksToBounds = true
    saveButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 24, bottom: 5, right: 24)
    return saveButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupProfileImage()
    setupGetImageButton()
    setupUsernameTextField()
    setupSaveButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadProfile()
  }
  
  // MARK: - Helpers
  private func setupViews() {
    view.backgroundColor = .brand2
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    imagePicker.sourceType = .photoLibrary
  }
  
  private func setupProfileImage() {
    view.addSubview(profileImage)
    profileImage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      profileImage.widthAnchor.constraint(equalToConstant: 200),
      profileImage.heightAnchor.constraint(equalToConstant: 200)
    ])
  }
  
  private func setupGetImageButton() {
    view.addSubview(getImageButton)
    getImageButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      getImageButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
      getImageButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
      getImageButton.widthAnchor.constraint(equalToConstant: 50),
      getImageButton.heightAnchor.constraint(equalToConstant: 50)
    ])
    getImageButton.addTarget(self, action: #selector(self.getImageButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupUsernameTextField() {
    view.addSubview(usernameTextField)
    usernameTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      usernameTextField.heightAnchor.constraint(equalToConstant: 52),
      usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      usernameTextField.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24)
    ])
  }
  
  private func setupSaveButton() {
    view.addSubview(saveButton)
    saveButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      saveButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 24)
    ])
    saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func loadProfile() {
    let user = Auth.auth().currentUser
    self.usernameTextField.text = user?.displayName
    ProfileProvider.shared.getProfile { profiles in
      DispatchQueue.main.async {
        if let image = profiles.image {
          self.profileImage.image = UIImage(data: image)
        }
      }
    }
  }
  
  private func saveProfile() {
    guard let usernameProfile = usernameTextField.text, usernameProfile != "" else {
      print("username kosong")
      return
    }
    let user = Auth.auth().currentUser
    if let image = profileImage.image, let imageData = image.pngData() as NSData? {
      if id > 0 {
        ProfileProvider.shared.updateFavorite(id, imageData as Data) {
          DispatchQueue.main.async {
            let alert = UIAlertController(title: "Successful", message: "Profile updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
              self.navigationController?.popViewController(animated: true)
            })
            self.present(alert, animated: true, completion: nil)
          }
        }
      } else {
        ProfileProvider.shared.createProfile(id, imageData as Data) {
          DispatchQueue.main.async {
            let alert = UIAlertController(title: "Successful", message: "New Profile created.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
              self.navigationController?.popViewController(animated: true)
            })
            self.present(alert, animated: true, completion: nil)
          }
        }
      }
    }
    let changeRequest = user?.createProfileChangeRequest()
    changeRequest?.displayName = usernameProfile
    changeRequest?.commitChanges { error in }
  }
  
  // MARK: - Actiosn
  @objc private func saveButtonTapped(_ sender: Any) {
    saveProfile()
  }
  
  @objc private func getImageButtonTapped(_ sender: Any) {
    self.present(imagePicker, animated: true, completion: nil)
  }
}

// UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      self.profileImage.contentMode = .scaleAspectFill
      self.profileImage.image = result
      getImageButton.isEnabled = true
      dismiss(animated: true, completion: nil)
    } else {
      let alert = UIAlertController(title: "Failed", message: "Image can't be loaded.", preferredStyle: .actionSheet)
      alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
}

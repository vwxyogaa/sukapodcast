//
//  PodcastTableViewCell.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class PodcastTableViewCell: UITableViewCell {
  // MARK: - Views
  lazy var thumbImageView: UIImageView = {
    let thumbImageView = UIImageView()
    thumbImageView.contentMode = .scaleAspectFill
    thumbImageView.layer.cornerRadius = 3
    thumbImageView.layer.masksToBounds = true
    return thumbImageView
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = 4
    return stackView
  }()
  
  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.textColor = .neutral1
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return titleLabel
  }()
  
  lazy var subtitleLabel: UILabel = {
    let subtitleLabel = UILabel()
    subtitleLabel.textColor = .neutral2
    subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    return subtitleLabel
  }()
  
  lazy var moreButton: UIButton = {
    let moreButton = UIButton(type: .system)
    moreButton.tintColor = .white
    moreButton.setImage(UIImage(named: "chevronRight"), for: .normal)
    moreButton.setTitle(nil, for: .normal)
    return moreButton
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupThumbImageview()
    setupStackView()
    setupMoreButton()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
    setupThumbImageview()
    setupStackView()
    setupMoreButton()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupViews()
    setupThumbImageview()
    setupStackView()
    setupMoreButton()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Helpers
  private func setupViews() {
    backgroundColor = .clear
  }
  
  private func setupThumbImageview() {
    contentView.addSubview(thumbImageView)
    thumbImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      thumbImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      thumbImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      thumbImageView.widthAnchor.constraint(equalToConstant: 40),
      thumbImageView.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  private func setupStackView() {
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    contentView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: thumbImageView.trailingAnchor, constant: 20),
      stackView.topAnchor.constraint(equalTo: thumbImageView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: thumbImageView.bottomAnchor)
    ])
  }
  
  private func setupMoreButton() {
    contentView.addSubview(moreButton)
    moreButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      moreButton.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20),
      moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      moreButton.centerYAnchor.constraint(equalTo: thumbImageView.centerYAnchor),
      moreButton.widthAnchor.constraint(equalToConstant: 24)
    ])
  }
}

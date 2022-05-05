//
//  FtuxCollectionViewCell.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class FtuxCollectionViewCell: UICollectionViewCell {
  // MARK: - Views
  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 0
    return titleLabel
  }()
  
  lazy var subtitleLabel: UILabel = {
    let subtitleLabel = UILabel()
    subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    subtitleLabel.textColor = .white
    subtitleLabel.numberOfLines = 0
    return subtitleLabel
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupImageView()
    setupSubtitleLabel()
    setupTitleLabel()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
    setupImageView()
    setupSubtitleLabel()
    setupTitleLabel()
  }
  
  // MARK: - Helpers
  private func setupViews() {
    backgroundColor = .brand2
  }
  
  private func setupImageView() {
    contentView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  private func setupSubtitleLabel() {
    contentView.addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -280)
    ])
  }
  
  private func setupTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -4)
    ])
  }
}

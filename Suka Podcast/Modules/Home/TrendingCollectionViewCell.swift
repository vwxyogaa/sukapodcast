//
//  TrendingCollectionViewCell.swift
//  Suka Podcast
//
//  Created by yxgg on 03/05/22.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
  // MARK: - Views
  lazy var containerView: UIView = {
    let containerView = UIView()
    return containerView
  }()
  
  lazy var thumbImageView: UIImageView = {
    let thumbImageView = UIImageView()
    thumbImageView.contentMode = .scaleAspectFill
    thumbImageView.layer.cornerRadius = 10
    thumbImageView.layer.masksToBounds = true
    return thumbImageView
  }()
  
  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.textColor = .white
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    return titleLabel
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupContainerView()
    setupThumbImageView()
    setupTitleLabel()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupContainerView()
    setupThumbImageView()
    setupTitleLabel()
  }
  
  // MARK: - Helpers
  private func setupContainerView() {
    contentView.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  private func setupThumbImageView() {
    containerView.addSubview(thumbImageView)
    thumbImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      thumbImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      thumbImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      thumbImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
      thumbImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
  }
  
  private func setupTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
      titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
    ])
  }
}

//
//  PodcastDetailTableViewCell.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class PodcastDetailTableViewCell: UITableViewCell {
  lazy var artworkImageView: UIImageView = {
    let artworkImageView = UIImageView()
    artworkImageView.contentMode = .scaleAspectFill
    artworkImageView.layer.cornerRadius = 8
    artworkImageView.layer.masksToBounds = true
    return artworkImageView
  }()
  
  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.textColor = UIColor.neutral1
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    return titleLabel
  }()
  
  lazy var subtitleLabel: UILabel = {
    let subtitleLabel = UILabel()
    subtitleLabel.textColor = UIColor.neutral2
    subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 0
    return subtitleLabel
  }()
  
  lazy var descLabel: UITextView = {
    let descLabel = UITextView()
    descLabel.isScrollEnabled = false
    descLabel.isEditable = false
    descLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    descLabel.textColor = UIColor.neutral1
    descLabel.tintColor = UIColor.neutral1
    descLabel.backgroundColor = .clear
    return descLabel
  }()
  
  lazy var genreLabel: UILabel = {
    let genreLabel = UILabel()
    genreLabel.textColor = UIColor.neutral2
    genreLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    genreLabel.textAlignment = .left
    genreLabel.numberOfLines = 1
    return genreLabel
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupArtworkImageView()
    setupTitleLabel()
    setupSubtitleLabel()
    setupDescLabel()
    setupGenreLabel()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
    setupArtworkImageView()
    setupTitleLabel()
    setupSubtitleLabel()
    setupDescLabel()
    setupGenreLabel()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupViews()
    setupArtworkImageView()
    setupTitleLabel()
    setupSubtitleLabel()
    setupDescLabel()
    setupGenreLabel()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Helpers
  private func setupViews() {
    selectionStyle = .none
    backgroundColor = UIColor.clear
  }
  
  private func setupArtworkImageView() {
    contentView.addSubview(artworkImageView)
    artworkImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      artworkImageView.widthAnchor.constraint(equalToConstant: 200),
      artworkImageView.heightAnchor.constraint(equalToConstant: 200),
      artworkImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      artworkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44)
    ])
  }
  
  private func setupTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48),
      titleLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 24),
    ])
  }
  
  private func setupSubtitleLabel() {
    contentView.addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
      subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48),
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
    ])
  }
  
  private func setupDescLabel() {
    contentView.addSubview(descLabel)
    descLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      descLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24)
    ])
  }
  
  private func setupGenreLabel() {
    contentView.addSubview(genreLabel)
    genreLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      genreLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
      genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}

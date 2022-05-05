//
//  EpisodeTableViewCell.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

protocol EpisodeViewCellDelegate: NSObjectProtocol {
  func episodeViewCellPlayButtonTapped(_ cell: EpisodeTableViewCell)
}

class EpisodeTableViewCell: UITableViewCell {
  weak var delegate: EpisodeViewCellDelegate?
  
  // MARK: - Views
  lazy var episodeImageView: UIImageView = {
    let episodeImageView = UIImageView()
    episodeImageView.contentMode = .scaleAspectFill
    episodeImageView.layer.cornerRadius = 4
    episodeImageView.layer.masksToBounds = true
    return episodeImageView
  }()
  
  lazy var loadingView: UIActivityIndicatorView = {
    let loadingView = UIActivityIndicatorView()
    loadingView.style = .medium
    loadingView.color = .brand1
    loadingView.hidesWhenStopped = true
    return loadingView
  }()
  
  lazy var dateLabel: UILabel = {
    let dateLabel = UILabel()
    dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    dateLabel.textColor = .neutral2
    return dateLabel
  }()
  
  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    titleLabel.textColor = .neutral1
    titleLabel.numberOfLines = 2
    return titleLabel
  }()
  
  lazy var subtitleLabel: UITextView = {
    let subtitleLabel = UITextView()
    subtitleLabel.isScrollEnabled = false
    subtitleLabel.isEditable = false
    subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    subtitleLabel.textColor = .neutral2
    subtitleLabel.tintColor = .neutral2
    subtitleLabel.backgroundColor = .clear
    return subtitleLabel
  }()
  
  lazy var watchLaterButton: UIButton = {
    let watchLaterButton = UIButton(type: .system)
    watchLaterButton.tintColor = .neutral1
    watchLaterButton.setImage(UIImage(named: "buttonWatchLater")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return watchLaterButton
  }()
  
  lazy var downloadButton: UIButton = {
    let downloadButton = UIButton(type: .system)
    downloadButton.tintColor = .neutral1
    downloadButton.setImage(UIImage(named: "buttonDownload")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return downloadButton
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 8
    return stackView
  }()
  
  lazy var playButton: UIButton = {
    let playButton = UIButton(type: .system)
    playButton.tintColor = .neutral1
    playButton.setImage(UIImage(named: "buttonPlaySmall")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return playButton
  }()
  
  lazy var durationLabel: UILabel = {
    let durationLabel = UILabel()
    durationLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    durationLabel.textColor = .neutral1
    return durationLabel
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupEpisodeImageView()
    setupLoadingView()
    setupDateLabel()
    setupTitleLabel()
    setupSubtitleLabel()
    setupWatchLaterButton()
    setupDownloadButton()
    setupStackView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
    setupEpisodeImageView()
    setupLoadingView()
    setupDateLabel()
    setupTitleLabel()
    setupSubtitleLabel()
    setupWatchLaterButton()
    setupDownloadButton()
    setupStackView()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupViews()
    setupEpisodeImageView()
    setupLoadingView()
    setupDateLabel()
    setupTitleLabel()
    setupSubtitleLabel()
    setupWatchLaterButton()
    setupDownloadButton()
    setupStackView()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - Helpers
  private func setupViews() {
    backgroundColor = .clear
    selectionStyle = .none
  }
  
  private func setupEpisodeImageView() {
    contentView.addSubview(episodeImageView)
    episodeImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      episodeImageView.widthAnchor.constraint(equalToConstant: 60),
      episodeImageView.heightAnchor.constraint(equalToConstant: 60),
      episodeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      episodeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
    ])
    let bottomConstraint = episodeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    bottomConstraint.priority = .defaultLow
    bottomConstraint.isActive = true
  }
  
  private func setupLoadingView() {
    episodeImageView.addSubview(loadingView)
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loadingView.centerYAnchor.constraint(equalTo: episodeImageView.centerYAnchor),
      loadingView.centerXAnchor.constraint(equalTo: episodeImageView.centerXAnchor)
    ])
  }
  
  private func setupDateLabel() {
    contentView.addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 16),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      dateLabel.topAnchor.constraint(equalTo: episodeImageView.topAnchor)
    ])
  }
  
  private func setupTitleLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      titleLabel.bottomAnchor.constraint(equalTo: episodeImageView.bottomAnchor)
    ])
  }
  
  private func setupSubtitleLabel() {
    contentView.addSubview(subtitleLabel)
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      subtitleLabel.topAnchor.constraint(equalTo: episodeImageView.bottomAnchor, constant: 4)
    ])
  }
  
  private func setupWatchLaterButton() {
    contentView.addSubview(watchLaterButton)
    watchLaterButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      watchLaterButton.widthAnchor.constraint(equalToConstant: 30),
      watchLaterButton.heightAnchor.constraint(equalToConstant: 30),
      watchLaterButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      watchLaterButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
      watchLaterButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
    ])
  }
  
  private func setupDownloadButton() {
    contentView.addSubview(downloadButton)
    downloadButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      downloadButton.widthAnchor.constraint(equalToConstant: 30),
      downloadButton.heightAnchor.constraint(equalToConstant: 30),
      downloadButton.leadingAnchor.constraint(equalTo: watchLaterButton.trailingAnchor, constant: 8),
      downloadButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
      downloadButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
    ])
  }
  
  private func setupStackView() {
    contentView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
      stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
    ])
    
    stackView.addArrangedSubview(playButton)
    playButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      playButton.widthAnchor.constraint(equalToConstant: 30),
      playButton.heightAnchor.constraint(equalToConstant: 30)
    ])
    playButton.addTarget(self, action: #selector(self.playButtonTapped(_:)), for: .touchUpInside)
    
    stackView.addArrangedSubview(durationLabel)
  }
  
  // MARK: - Actions
  @objc private func playButtonTapped(_ sender: Any) {
    delegate?.episodeViewCellPlayButtonTapped(self)
  }
}

//
//  PodcastViewController.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit
import AVKit
import SafariServices
import FeedKit

class PodcastViewController: UIViewController {
  var podcast: Podcast!
  var rssFeed: RSSFeed?
  
  // MARK: - Views
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.backgroundColor = .clear
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    tableView.contentInsetAdjustmentBehavior = .never
    return tableView
  }()
  
  lazy var backButton: UIButton = {
    let backButton = UIButton(type: .system)
    backButton.setImage(UIImage(named: "buttonBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
    backButton.setTitle(nil, for: .normal)
    return backButton
  }()
  
  lazy var loadingView: UIActivityIndicatorView = {
    let loadingView = UIActivityIndicatorView()
    loadingView.style = .large
    loadingView.color = .brand1
    loadingView.hidesWhenStopped = true
    return loadingView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupTableView()
    setupBackButton()
    setupLoadingView()
    loadData()
    NotificationCenter.default.addObserver(self, selector: #selector(self.playerProviderStateDidChange(_:)), name: .PlayerProviderStateDidChange, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .PlayerProviderStateDidChange, object: nil)
  }
  
  // MARK: - Helpers
  private func setupViews() {
    view.backgroundColor = .brand2
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    tableView.register(PodcastDetailTableViewCell.self, forCellReuseIdentifier: "detailCellId")
    tableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "eposideCellId")
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func setupBackButton() {
    view.addSubview(backButton)
    backButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backButton.widthAnchor.constraint(equalToConstant: 24),
      backButton.heightAnchor.constraint(equalToConstant: 24),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24)
    ])
    backButton.addTarget(self, action: #selector(self.closeButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupLoadingView() {
    view.addSubview(loadingView)
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loadingView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
      loadingView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
    ])
  }
  
  private func loadData() {
    loadingView.startAnimating()
    tableView.isHidden = true
    iTunesProvider.shared.loadFromFeedUrl(podcast.feedUrl) { result in
      switch result {
      case .success(let rssFeed):
        self.rssFeed = rssFeed
        self.loadingView.stopAnimating()
        self.tableView.isHidden = false
        self.tableView.reloadData()
      case .failure(let error):
        self.presentAlert(title: "Oops!", message: error.localizedDescription) { _ in }
      }
    }
  }
  
  // MARK: - Actions
  @objc private func playerProviderStateDidChange(_ sender: Notification) {
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension PodcastViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }
    else {
      return rssFeed?.items?.count ?? 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "detailCellId", for: indexPath) as! PodcastDetailTableViewCell
      cell.artworkImageView.kf.setImage(with: URL(string: podcast.artworkUrl600))
      cell.titleLabel.text = podcast.collectionName
      cell.subtitleLabel.text = podcast.artistName
      cell.descLabel.attributedText = rssFeed?.description?
        .convertHtmlToAttributedStringWithCSS(
          font: UIFont.systemFont(ofSize: 14, weight: .regular),
          cssColor: "#EEEEEE",
          lineHeight: 18,
          cssTextAlign: "left"
        )
      cell.genreLabel.text = rssFeed?.iTunes?.iTunesCategories?
        .compactMap({ $0.attributes?.text })
        .joined(separator: " • ")
      
      return cell
    }
    else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "eposideCellId", for: indexPath) as! EpisodeTableViewCell
      let episode = rssFeed?.items?[indexPath.row]
      cell.loadingView.startAnimating()
      cell.episodeImageView.kf.setImage(with: URL(string: episode?.iTunes?.iTunesImage?.attributes?.href ?? "")) {_ in
        cell.loadingView.stopAnimating()
      }
      cell.dateLabel.text = episode?.pubDate?.string(format: "d MMM yyyy")
      cell.titleLabel.text = episode?.title
      cell.subtitleLabel.attributedText = episode?.description?
        .convertHtmlToAttributedStringWithCSS(
          font: UIFont.systemFont(ofSize: 12, weight: .regular),
          cssColor: "#EEEEEE",
          lineHeight: 16,
          cssTextAlign: "left"
        )
      cell.subtitleLabel.delegate = self
      cell.durationLabel.text = episode?.iTunes?.iTunesDuration?.string
      cell.delegate = self
      
      let playerProvider = PlayerProvider.shared
      if playerProvider.playlist == rssFeed,
         playerProvider.currentIndex == indexPath.row,
         playerProvider.isPodcastPlaying() {
        cell.playButton.setImage(UIImage(named: "buttonPauseSmall")?.withRenderingMode(.alwaysOriginal), for: .normal)
      } else {
        cell.playButton.setImage(UIImage(named: "buttonPlaySmall")?.withRenderingMode(.alwaysOriginal), for: .normal)
      }
      return cell
    }
  }
}

// MARK: - UITableViewDelegate
extension PodcastViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      return nil
    }
    else {
      let view = UIView(frame: .zero)
      view.backgroundColor = .clear
      
      let label = UILabel(frame: .zero)
      label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
      label.textColor = .neutral1
      label.text = "\(rssFeed?.items?.count ?? 0) Episode"
      view.addSubview(label)
      label.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
      ])
      return view
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0.0001
    }
    else {
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.0001
  }
}

// MARK: - EpisodeViewCellDelegate
extension PodcastViewController: EpisodeViewCellDelegate {
  func episodeViewCellPlayButtonTapped(_ cell: EpisodeTableViewCell) {
    if let indexPath = tableView.indexPath(for: cell), let playlist = rssFeed {
      let playerProvider = PlayerProvider.shared
      if playerProvider.playlist == playlist,
         playerProvider.currentIndex == indexPath.row {
        playerProvider.podcastPlay()
      } else {
        playerProvider.launchPodcastPlaylist(playlist: playlist, index: indexPath.row)
      }
    }
  }
}

// MARK: - UITextViewDelegate
extension PodcastViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    let viewController = SFSafariViewController(url: URL)
    present(viewController, animated: true, completion: nil)
    return false
  }
}

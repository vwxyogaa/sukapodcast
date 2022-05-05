//
//  MainViewController.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit
import MediaPlayer

class MainViewController: UITabBarController {
  // MARK: - Views
  lazy var playerView: UIView = {
    let playerView = UIView()
    playerView.backgroundColor = UIColor.brand1
    playerView.layer.cornerRadius = 8
    playerView.layer.masksToBounds = true
    playerView.isHidden = true
    return playerView
  }()
  
  lazy var episodeImageView: UIImageView = {
    let episodeImageView = UIImageView()
    episodeImageView.contentMode = .scaleAspectFill
    episodeImageView.backgroundColor = UIColor.white
    episodeImageView.layer.cornerRadius = 21
    episodeImageView.layer.masksToBounds = true
    return episodeImageView
  }()
  
  lazy var episodeTitleLabel: UILabel = {
    let episodeTitleLabel = UILabel()
    episodeTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    episodeTitleLabel.textColor = UIColor.neutral3
    episodeTitleLabel.text = "Episode"
    return episodeTitleLabel
  }()
  
  lazy var previousButton: UIButton = {
    let previousButton = UIButton(type: .system)
    previousButton.setImage(UIImage(named: "buttonPrevious")?.withRenderingMode(.alwaysOriginal), for: .normal)
    previousButton.setTitle(nil, for: .normal)
    previousButton.addTarget(self, action: #selector(self.previousButtonTapped(_:)), for: .touchUpInside)
    return previousButton
  }()
  
  lazy var playButton: UIButton = {
    let playButton = UIButton(type: .system)
    playButton.layer.cornerRadius = 16
    playButton.layer.masksToBounds = true
    playButton.layer.borderWidth = 1
    playButton.layer.borderColor = UIColor.neutral3.cgColor
    playButton.setImage(UIImage(named: "buttonPlay")?.withRenderingMode(.alwaysOriginal), for: .normal)
    playButton.setTitle(nil, for: .normal)
    playButton.addTarget(self, action: #selector(self.playButtonTapped(_:)), for: .touchUpInside)
    return playButton
  }()
  
  lazy var nextButton: UIButton = {
    let nextButton = UIButton(type: .system)
    nextButton.setImage(UIImage(named: "buttonNext")?.withRenderingMode(.alwaysOriginal), for: .normal)
    nextButton.setTitle(nil, for: .normal)
    nextButton.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
    return nextButton
  }()
  
  lazy var progressView: UIView = {
    let progressView = UIView()
    progressView.backgroundColor = UIColor.neutral3
    return progressView
  }()
  
  lazy var progressViewWidthConstraint: NSLayoutConstraint? = {
    let progressViewWidthConstraint = NSLayoutConstraint()
    return progressViewWidthConstraint
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBarController()
    setupViews()
    setupPlayerView()
    setupEpisodeImageView()
    setupEpisodeTitleLabel()
    setupPreviousButton()
    setupPlayButton()
    setupNextButton()
    setupProgressView()
    NotificationCenter.default.addObserver(self, selector: #selector(self.playerProviderStateDidChange(_:)), name: .PlayerProviderStateDidChange, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.playerProviderNowPlayingInfoDidChange(_:)), name: .PlayerProviderNowPlayingInfoDidChange, object: nil)
  }
  
  // MARK: - Helpers
  private func setupTabBarController() {
    let homeNavigationController = BaseNavigationController(rootViewController: HomeViewController())
    homeNavigationController.title = "Podcast"
    homeNavigationController.tabBarItem.image = UIImage(named: "tabHome")
    homeNavigationController.tabBarItem.selectedImage = UIImage(named: "tabHome")
    
    let searchNavigationController = BaseNavigationController(rootViewController: SearchViewController())
    searchNavigationController.title = "Search"
    searchNavigationController.tabBarItem.image = UIImage(named: "tabSearch")
    searchNavigationController.tabBarItem.selectedImage = UIImage(named: "tabSearch")
    
    let accountNavigationController = BaseNavigationController(rootViewController: AccountViewController())
    accountNavigationController.title = "Account"
    accountNavigationController.tabBarItem.image = UIImage(named: "tabAccount")
    accountNavigationController.tabBarItem.selectedImage = UIImage(named: "tabAccount")
    
    viewControllers = [homeNavigationController, searchNavigationController, accountNavigationController]
  }
  
  private func setupViews() {
    tabBar.tintColor = .brand1
    tabBar.unselectedItemTintColor = .neutral2
  }
  
  private func setupPlayerView() {
    view.addSubview(playerView)
    playerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
      playerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -8)
    ])
  }
  
  private func setupEpisodeImageView() {
    playerView.addSubview(episodeImageView)
    episodeImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      episodeImageView.widthAnchor.constraint(equalToConstant: 42),
      episodeImageView.heightAnchor.constraint(equalToConstant: 42),
      episodeImageView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 8),
      episodeImageView.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 8),
      episodeImageView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -8)
    ])
  }
  
  private func setupEpisodeTitleLabel() {
    playerView.addSubview(episodeTitleLabel)
    episodeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      episodeTitleLabel.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 16),
      episodeTitleLabel.centerYAnchor.constraint(equalTo: episodeImageView.centerYAnchor)
    ])
  }
  
  private func setupPreviousButton() {
    playerView.addSubview(previousButton)
    previousButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      previousButton.widthAnchor.constraint(equalToConstant: 24),
      previousButton.heightAnchor.constraint(equalToConstant: 24),
      previousButton.leadingAnchor.constraint(equalTo: episodeTitleLabel.trailingAnchor, constant: 20),
      previousButton.centerYAnchor.constraint(equalTo: episodeImageView.centerYAnchor)
    ])
  }
  
  private func setupPlayButton() {
    playerView.addSubview(playButton)
    playButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      playButton.widthAnchor.constraint(equalToConstant: 32),
      playButton.heightAnchor.constraint(equalToConstant: 32),
      playButton.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 16),
      playButton.centerYAnchor.constraint(equalTo: episodeImageView.centerYAnchor)
    ])
  }
  
  private func setupNextButton() {
    playerView.addSubview(nextButton)
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nextButton.widthAnchor.constraint(equalToConstant: 24),
      nextButton.heightAnchor.constraint(equalToConstant: 24),
      nextButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 16),
      nextButton.centerYAnchor.constraint(equalTo: episodeImageView.centerYAnchor),
      nextButton.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -8)
    ])
  }
  
  private func setupProgressView() {
    playerView.addSubview(progressView)
    progressView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      progressView.heightAnchor.constraint(equalToConstant: 4),
      progressView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
      progressView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor)
    ])
    let widthConstraint = progressView.widthAnchor.constraint(equalToConstant: 128)
    widthConstraint.isActive = true
    progressViewWidthConstraint = widthConstraint
  }
  
  func showPlayerView() {
    playerView.isHidden = false
    viewControllers?.forEach({ (viewController) in
      viewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: playerView.bounds.height + 8, right: 0)
    })
    
    let playerProvider = PlayerProvider.shared
    let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    playerProvider.podcastPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] (time) in
      guard let `self` = self, let currentItem = playerProvider.podcastPlayer.currentItem else {
        return
      }
      let currentSeconds = CMTimeGetSeconds(time)
      let totalSeconds = CMTimeGetSeconds(currentItem.duration)
      let progress: CGFloat = max(0.0001, CGFloat(currentSeconds / totalSeconds))
      
      self.progressViewWidthConstraint?.constant = self.playerView.bounds.width * progress
      self.view.setNeedsLayout()
    }
  }
  
  func hidePlayerView() {
    playerView.isHidden = true
    viewControllers?.forEach({ (viewController) in
      viewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    })
  }
  
  // MARK: - Actions
  @objc func previousButtonTapped(_ sender: Any) {
    PlayerProvider.shared.podcastPrevious()
  }
  
  @objc func playButtonTapped(_ sender: Any) {
    PlayerProvider.shared.podcastPlay()
  }
  
  @objc func nextButtonTapped(_ sender: Any) {
    PlayerProvider.shared.podcastNext()
  }
  
  @objc func playerProviderStateDidChange(_ sender: Notification) {
    showPlayerView()
    playerProviderNowPlayingInfoDidChange(sender)
  }
  
  @objc func playerProviderNowPlayingInfoDidChange(_ sender: Notification) {
    let playerProvider = PlayerProvider.shared
    if let episode = playerProvider.playlist?.items?[playerProvider.currentIndex] {
      episodeImageView.kf.setImage(with: URL(string: episode.pictureUrl ?? ""))
      episodeTitleLabel.text = episode.title
      playButton.setImage(
        UIImage(named: playerProvider.isPodcastPlaying() ? "buttonPause" : "buttonPlay")?.withRenderingMode(.alwaysOriginal),
        for: .normal
      )
    }
  }
}

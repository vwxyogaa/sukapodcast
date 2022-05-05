//
//  PlayerProvider.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import Foundation
import AVKit
import MediaPlayer
import FeedKit
import Kingfisher

extension NSNotification.Name {
  static let PlayerProviderStateDidChange: NSNotification.Name = NSNotification.Name(rawValue: "kPlayerProviderStateDidChange")
  static let PlayerProviderNowPlayingInfoDidChange: NSNotification.Name = NSNotification.Name(rawValue: "kPlayerProviderNowPlayingInfoDidChange")
}

// MARK: - State enum
extension PlayerProvider {
  enum State {
    case playing
    case paused
    case loading(Bool)
  }
}

class PlayerProvider: NSObject {
  var playlist: Playlist?
  var currentIndex: Int = 0
  var podcastPlayer: AVPlayer!
  
  private var playbackLikelyToKeepUpContext: Int = 0
  private var podcastNowPlayingInfo: [String: Any] = [:]
  private var isAVAudioSessionActive: Bool = false
  private var state: State = State.paused {
    didSet {
      stateDidChange()
    }
  }
  
  // MARK: - Singleton
  static var shared: PlayerProvider = PlayerProvider()
  
  // MARK: - Lifecycle
  private override init() {
    do {
      // This is necessary if you want to have audio in the app !
      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
    } catch {
      print("Unable to set AVAudioSession Category: \(error)")
    }
    podcastPlayer = AVPlayer()
    podcastPlayer.automaticallyWaitsToMinimizeStalling = false
  }
  
  deinit {
    self.podcastPlayer.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
    NotificationCenter.default.removeObserver(self)
  }
  
  func launchPodcastPlaylist(playlist: Playlist, index: Int = 0) {
    self.podcastPlayer.automaticallyWaitsToMinimizeStalling = false
    self.playlist = playlist
    self.currentIndex = index
    self.setupAVAudioSession()
    guard let playlistSafe = self.playlist,
          let audios = playlistSafe.items else { return }
    let audioSafe = audios[index]
    self.loadPodcast(audio: audioSafe)
  }
  
  func closePodcastPlayer() {
    self.stopPodcast()
    self.podcastPlayer.replaceCurrentItem(with: nil)
    self.removeAVAudioSession()
  }
  
  private func loadPodcast(audio: Audio, andPlay shouldPlay: Bool = true) {
    guard let stringUrl = audio.url, let safeUrl = URL(string: stringUrl) else { return }
    self.podcastPlayer.replaceCurrentItem(with: AVPlayerItem(url: safeUrl))
    // Register for notification
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.playerItemDidReadyToPlay(_:)),
                                           name: .AVPlayerItemNewAccessLogEntry,
                                           object: self.podcastPlayer.currentItem)
    self.podcastPlayer.addObserver(self,
                                   forKeyPath: "currentItem.playbackLikelyToKeepUp",
                                   options: .new,
                                   context: &playbackLikelyToKeepUpContext)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.playerItemDidReachEnd(_:)),
                                           name: .AVPlayerItemDidPlayToEndTime,
                                           object: self.podcastPlayer.currentItem)
    self.updateInfoCenter(with: audio)
    self.updateCommandCenter()
    if shouldPlay {
      self.playPodcast()
    }
  }
  
  private func stateDidChange() {
    switch state {
    case .playing, .paused:
      NotificationCenter.default.post(name: .PlayerProviderStateDidChange, object: self)
    case .loading(let isLoading):
      NotificationCenter.default.post(name: .PlayerProviderStateDidChange, object: self, userInfo: ["isLoading": isLoading])
    }
  }
  
  private func updateInfoCenter(with audio: Audio) {
    guard let pictureUrl = audio.pictureUrl, let url = URL(string: pictureUrl) else { return }
    ImageDownloader.default.downloadImage(with: url) { [weak self] (result) in
      guard let `self` = self else { return }
      switch result {
      case .success(let imageLoadingResult):
        let downloadedImage = imageLoadingResult.image
        let artwork = MPMediaItemArtwork(boundsSize: downloadedImage.size, requestHandler: { _ -> UIImage in
          return downloadedImage
        })
        self.setupNowPlayingInfo(with: artwork, for: audio)
      case .failure:
        break
      }
    }
  }
  
  private func setupNowPlayingInfo(with artwork: MPMediaItemArtwork, for audio: Audio) {
    guard let safeCurrentItem = self.podcastPlayer.currentItem else { return }
    self.podcastNowPlayingInfo[MPMediaItemPropertyTitle] = audio.title ?? ""
    self.podcastNowPlayingInfo[MPMediaItemPropertyArtist] = audio.author ?? ""
    self.podcastNowPlayingInfo[MPMediaItemPropertyAlbumTitle] = ""
    self.podcastNowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
    self.podcastNowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.podcastPlayer.rate
    self.podcastNowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(safeCurrentItem.duration)
    self.podcastNowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(safeCurrentItem.currentTime())
    
    // Set the metadata
    MPNowPlayingInfoCenter.default().nowPlayingInfo = self.podcastNowPlayingInfo
  }
  
  private func updateNowPlayingInfo() {
    guard let safeCurrentItem = self.podcastPlayer.currentItem else { return }
    self.podcastNowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.podcastPlayer.rate
    self.podcastNowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(safeCurrentItem.duration)
    self.podcastNowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(self.podcastPlayer.currentTime())
    MPNowPlayingInfoCenter.default().nowPlayingInfo = self.podcastNowPlayingInfo
  }
  
  private func clearNowPlayingInfo() {
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
  }
}

// MARK: - Setup
extension PlayerProvider {
  private func setupAVAudioSession() {
    if !self.isAVAudioSessionActive {
      do {
        try AVAudioSession.sharedInstance().setActive(true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleInterruption(_:)),
                                               name: AVAudioSession.interruptionNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleSecondaryAudio(_:)),
                                               name: AVAudioSession.silenceSecondaryAudioHintNotification,
                                               object: AVAudioSession.sharedInstance())
        print("AVAudioSession is Active and Category Playback is set")
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.setupCommandCenter()
        self.isAVAudioSessionActive = true
      } catch {
        print("Unable to activate audio session: \(error.localizedDescription)")
      }
    }
  }
  
  private func removeAVAudioSession() {
    if self.isAVAudioSessionActive {
      do {
        try AVAudioSession.sharedInstance().setActive(false)
        print("AVAudioSession is deactivate")
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.removeCommandCenter()
        self.isAVAudioSessionActive = false
      } catch {
        print("Unable to deactivate audio session: \(error)")
      }
    }
  }
}

// MARK: - Podcast Controls
extension PlayerProvider {
  private func playPodcast() {
    self.podcastPlayer.play()
    state = .playing
  }
  
  private func pausePodcast() {
    self.podcastPlayer.pause()
    state = .paused
  }
  
  private func stopPodcast() {
    self.podcastPlayer.seek(to: CMTime.zero)
    self.pausePodcast()
  }
}

// MARK: - Getters
extension PlayerProvider {
  func isPodcastPlaying() -> Bool {
    return self.podcastPlayer.rate != 0.0
  }
  
  func isNextPodcastAvailable() -> Bool {
    guard let playlistSafe = self.playlist,
          let audios = playlistSafe.items else {
      return false
    }
    return self.currentIndex < audios.count - 1
  }
}

// MARK: - Actions
extension PlayerProvider {
  func podcastGoTo(time: Float) {
    self.podcastPlayer.seek(to: CMTime(seconds: Double(time), preferredTimescale: self.podcastPlayer.currentTime().timescale)) {_ in
      self.updateNowPlayingInfo()
      NotificationCenter.default.post(name: .PlayerProviderNowPlayingInfoDidChange, object: self)
    }
  }
  
  private func podcastSeekTo(time: CMTime) {
    self.podcastPlayer.seek(to: time) {_ in
      self.updateNowPlayingInfo()
      NotificationCenter.default.post(name: .PlayerProviderNowPlayingInfoDidChange, object: self)
    }
  }
  
  func podcastPrevious() {
    let newCurrentIndex = currentIndex - 1
    if newCurrentIndex < 0 {
      self.podcastSeekTo(time: CMTime(seconds: 0, preferredTimescale: self.podcastPlayer.currentTime().timescale))
    } else {
      guard let playlistSafe = self.playlist,
            let audios = playlistSafe.items else { return }
      self.currentIndex = newCurrentIndex
      self.loadPodcast(audio: audios[newCurrentIndex])
    }
  }
  
  func podcastPlay() {
    isPodcastPlaying() ? pausePodcast() : playPodcast()
  }
  
  func podcastNext() {
    let newCurrentIndex = currentIndex + 1
    guard let playlistSafe = self.playlist,
          let audios = playlistSafe.items,
          newCurrentIndex <= audios.count - 1 else { return }
    self.currentIndex = newCurrentIndex
    self.loadPodcast(audio: audios[newCurrentIndex])
  }
  
  private func pausePodcastAndRemoveAudioSession() {
    self.pausePodcast()
    if self.isAVAudioSessionActive {
      self.clearNowPlayingInfo()
      self.removeAVAudioSession()
    }
  }
}

// MARK: - Command Center
extension PlayerProvider {
  private func updateCommandCenter() {
    MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = isNextPodcastAvailable()
  }
  
  private func setupCommandCenter() {
    MPRemoteCommandCenter.shared().playCommand.isEnabled = true
    MPRemoteCommandCenter.shared().pauseCommand.isEnabled = true
    MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = true
    MPRemoteCommandCenter.shared().playCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
      self?.podcastPlay()
      return .success
    }
    MPRemoteCommandCenter.shared().pauseCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
      self?.podcastPlay()
      return .success
    }
    MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
      self?.podcastPrevious()
      return .success
    }
    MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
      self?.podcastNext()
      return .success
    }
  }
  
  private func removeCommandCenter() {
    MPRemoteCommandCenter.shared().playCommand.isEnabled = false
    MPRemoteCommandCenter.shared().pauseCommand.isEnabled = false
    MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = false
    MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = false
    MPRemoteCommandCenter.shared().playCommand.removeTarget(nil)
    MPRemoteCommandCenter.shared().pauseCommand.removeTarget(nil)
    MPRemoteCommandCenter.shared().previousTrackCommand.removeTarget(nil)
    MPRemoteCommandCenter.shared().nextTrackCommand.removeTarget(nil)
  }
}

// MARK: - Observers
extension PlayerProvider {
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey: Any]?,
                             context: UnsafeMutableRawPointer?) {
    if context == &playbackLikelyToKeepUpContext {
      guard let safeItem = self.podcastPlayer.currentItem else { return }
      self.state = .loading(!safeItem.isPlaybackLikelyToKeepUp)
    }
  }
  
  @objc private func playerItemDidReachEnd(_ sender: NSNotification) {
    if isNextPodcastAvailable() {
      self.podcastNext()
    } else {
      self.pausePodcast()
      if let playlistSafe = self.playlist,
         let audios = playlistSafe.items,
         self.currentIndex == audios.count - 1,
         let audioSafe = audios.first {
        self.currentIndex = 0
        self.loadPodcast(audio: audioSafe, andPlay: false)
        self.podcastPlayer.seek(to: CMTime.zero)
      } else {
        self.podcastPlayer.seek(to: CMTime.zero)
      }
    }
  }
  
  @objc private func playerItemDidReadyToPlay(_ sender: Notification) {
    if let item = sender.object as? AVPlayerItem {
      if item.status == .readyToPlay {
        self.updateNowPlayingInfo()
        self.updateCommandCenter()
        NotificationCenter.default.post(name: .PlayerProviderNowPlayingInfoDidChange, object: self)
      } else if item.status == .failed {
        print("something went wrong. player.error should contain some information")
      }
    }
  }
  
  @objc private func handleSecondaryAudio(_ sender: Notification) {
    // Determine hint type
    guard let userInfo = sender.userInfo,
          let typeValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
          let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: typeValue) else { return }
    if type == .begin {
      // Other app audio started playing - mute secondary audio
      self.pausePodcast()
    } else {
      // Other app audio stopped playing - restart secondary audio
      self.playPodcast()
    }
  }
  
  @objc private func handleInterruption(_ sender: Notification) {
    guard let userInfo = sender.userInfo,
          let typeInt = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
          let type = AVAudioSession.InterruptionType(rawValue: typeInt) else { return }
    switch type {
    case .began:
      self.pausePodcast()
    case .ended:
      if let optionInt = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
        let options = AVAudioSession.InterruptionOptions(rawValue: optionInt)
        if options.contains(.shouldResume) {
          self.playPodcast()
        }
      }
      // do nothing (here if other case are added in future versions)
    @unknown default: break
    }
  }
}

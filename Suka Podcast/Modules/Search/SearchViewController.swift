//
//  SearchViewController.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class SearchViewController: UIViewController {
  var podcasts: [Podcast]?
  
  // MARK: - Views
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.backgroundColor = .clear
    return tableView
  }()
  
  lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search"
    searchController.searchBar.tintColor = .neutral1
    searchController.searchBar.barStyle = .black
    return searchController
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
    setupSearchController()
    setupLoadingView()
  }
  
  // MARK: - Helpers
  func setupViews() {
    title = "Search"
    navigationController?.navigationBar.prefersLargeTitles = true
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
    tableView.register(PodcastTableViewCell.self, forCellReuseIdentifier: "podcastCellId")
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func setupSearchController() {
    navigationItem.searchController = searchController
    searchController.searchBar.delegate = self
  }
  
  private func setupLoadingView() {
    view.addSubview(loadingView)
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loadingView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
      loadingView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
    ])
  }
  
  func search(_ term: String) {
    loadingView.startAnimating()
    iTunesProvider.shared.search(term) { (result) in
      switch result {
      case .success(let data):
        self.podcasts = data
        self.loadingView.stopAnimating()
        self.tableView.reloadData()
      case .failure(let error):
        self.presentAlert(title: "Error", message: error.localizedDescription) { _ in }
      }
    }
  }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    search(searchBar.text ?? "")
  }
  
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let string = NSString(string: searchBar.text ?? "").replacingCharacters(in: range, with: text)
    if string.count >= 1 {
      search(string)
    }
    return true
  }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcasts?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCellId", for: indexPath) as! PodcastTableViewCell
    let podcast = podcasts![indexPath.row]
    let scale = UIScreen.main.scale
    let imageUrl: String
    switch scale {
    case 1:
      imageUrl = podcast.artworkUrl30
    case 2:
      imageUrl = podcast.artworkUrl60
    default:
      imageUrl = podcast.artworkUrl100
    }
    cell.thumbImageView.kf.setImage(with: URL(string: imageUrl))
    cell.titleLabel.text = podcast.trackName
    cell.subtitleLabel.text = podcast.artistName
    return cell
  }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let podcast = podcasts?[indexPath.row] {
      let viewController = PodcastViewController()
      viewController.podcast = podcast
      present(viewController, animated: true, completion: nil)
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if podcasts != nil {
      let view = UIView(frame: .zero)
      view.backgroundColor = .clear
      
      let label = UILabel(frame: .zero)
      label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
      label.textColor = .neutral1
      label.text = "Search Result"
      view.addSubview(label)
      label.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
      ])
      return view
    }
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if podcasts != nil {
      return 56
    }
    return 0.0001
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.0001
  }
}


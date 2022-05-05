//
//  HomeViewController.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class HomeViewController: UIViewController {
  // MARK: - Views
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  let data: [CategoryPodcast] = [
    CategoryPodcast(imageView: "dummyImage", name: "Books"),
    CategoryPodcast(imageView: "dummyImage", name: "Sports"),
    CategoryPodcast(imageView: "dummyImage", name: "Technology"),
    CategoryPodcast(imageView: "dummyImage", name: "Books"),
    CategoryPodcast(imageView: "dummyImage", name: "Sports"),
    CategoryPodcast(imageView: "dummyImage", name: "Technology"),
    CategoryPodcast(imageView: "dummyImage", name: "Books"),
    CategoryPodcast(imageView: "dummyImage", name: "Sports"),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupCollectionView()
  }
  
  // MARK: - Helpers
  private func setupViews() {
    title = "Podcast"
    navigationController?.navigationBar.prefersLargeTitles = true
    view.backgroundColor = .brand2
  }
  
  private func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    collectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: "trendingCellId")
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCellId", for: indexPath) as! TrendingCollectionViewCell
    let data = data[indexPath.item]
    cell.thumbImageView.image = UIImage(named: data.imageView)
    cell.titleLabel.text = data.name
    return cell
  }
}

// MARK: - UICollectionViewFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 150, height: 150)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 24
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 24
  }
}

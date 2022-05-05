//
//  FtuxViewController.swift
//  Suka Podcast
//
//  Created by yxgg on 01/05/22.
//

import UIKit

class FtuxViewController: UIViewController {
  // MARK: - Views
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .black
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()
  
  lazy var pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.numberOfPages = data.count
    pageControl.currentPage = 0
    pageControl.currentPageIndicatorTintColor = UIColor.brand1
    pageControl.pageIndicatorTintColor = UIColor.neutral2
    pageControl.backgroundStyle = .minimal
    pageControl.allowsContinuousInteraction = false
    return pageControl
  }()
  
  lazy var getStartedButton: PrimaryButton = {
    let getStartedButton = PrimaryButton()
    getStartedButton.setTitle("Get Started", for: .normal)
    return getStartedButton
  }()
  
  let data: [Ftux] = [
    Ftux(image: "dummyImage", title: "Welcome To Suka Podcast", subtitle: "Hear your favorite podcast from everywhere anywhere everytime for free"),
    Ftux(image: "dummyImage", title: "Welcome To Suka Podcast", subtitle: "Hear your favorite podcast from everywhere anywhere everytime for free")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupCollectionView()
    setupGetStartedButton()
    setupPageControl()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Helpers
  private func setupViews() {
    view.backgroundColor = .brand2
  }
  
  private func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    collectionView.register(FtuxCollectionViewCell.self, forCellWithReuseIdentifier: "ftuxCell")
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  private func setupGetStartedButton() {
    view.addSubview(getStartedButton)
    getStartedButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
      getStartedButton.heightAnchor.constraint(equalToConstant: 46)
    ])
    getStartedButton.addTarget(self, action: #selector(self.getStartedButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupPageControl() {
    view.addSubview(pageControl)
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      pageControl.leadingAnchor.constraint(equalTo: getStartedButton.leadingAnchor),
      pageControl.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -100),
      pageControl.heightAnchor.constraint(equalToConstant: 26)
    ])
  }
  
  // MARK: - Actions
  @objc private func getStartedButtonTapped(_ sender: Any) {
    let viewController = SignInViewController()
    let navigationController = BaseNavigationController(rootViewController: viewController)
    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    window?.rootViewController = navigationController
  }
}

// MARK: - UICollectionViewDataSource
extension FtuxViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ftuxCell", for: indexPath) as! FtuxCollectionViewCell
    let ftux = data[indexPath.item]
    cell.imageView.image = UIImage(named: ftux.image)
    cell.titleLabel.text = ftux.title
    cell.subtitleLabel.text = ftux.subtitle
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FtuxViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenSize = UIScreen.main.bounds.size
    return CGSize(width: screenSize.width, height: screenSize.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

// MARK: - UICollectionViewDelegate
extension FtuxViewController: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView == collectionView {
      let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
      pageControl.currentPage = page
    }
  }
}

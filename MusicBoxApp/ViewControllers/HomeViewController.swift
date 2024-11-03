//
//  HomeViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import RxSwift
import MusicBox
import Swinject

class HomeViewController: UIViewController {
  private let homeMusicViewModel = Container.sharedContainer.resolve(BrowsingViewModel.self)!
  private let disposeBag = DisposeBag()
  private let musicItemsTableView = MusicItemsTableView()
  private lazy var recentlyPlayedMusicCollectionView = RecentlyPlayedMusicCollectionView(
    frame: .zero,
    collectionViewLayout: configureLayout()
  )
  private lazy var dataSource = makeDataSource()
  
  enum CollectionViewSection {
    case main
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<CollectionViewSection, MusicItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, MusicItem>
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(recentlyPlayedMusicCollectionView)
    applySnapshot()
    
    musicItemsTableView.actionDelegate = self
    
//    setupMusicItemsTableViewConstraints()
    setupMusicItemsCollectionViewConstraints()
    navigationItem.title = "Welcome"
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(
        image: UIImage(systemName: "magnifyingglass"),
        style: .plain,
        target: self,
        action: #selector(navigateToSearchViewController)
      )
    ]
    musicItemsTableView.bindWithViewModel(
      viewModel: homeMusicViewModel
    )
    homeMusicViewModel
      .setMusicListQuery(.withSearchQuery(query: "Ed sheeran"))
  }
  
  @objc func navigateToSearchViewController() {
    let searchViewController = SearchViewController()
    navigationController?.pushViewController(searchViewController, animated: true)
  }
  
  func setupMusicItemsTableViewConstraints() {
    musicItemsTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: musicItemsTableView.topAnchor),
      view.leadingAnchor.constraint(equalTo: musicItemsTableView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: musicItemsTableView.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: musicItemsTableView.bottomAnchor),
    ])
  }
  
  func setupMusicItemsCollectionViewConstraints() {
    recentlyPlayedMusicCollectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      recentlyPlayedMusicCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      view.leadingAnchor.constraint(equalTo: recentlyPlayedMusicCollectionView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: recentlyPlayedMusicCollectionView.trailingAnchor),
      recentlyPlayedMusicCollectionView.heightAnchor.constraint(equalToConstant: 180)
    ])
  }
  
  func makeDataSource() -> DataSource {
    let dataSource = DataSource(collectionView: recentlyPlayedMusicCollectionView) { (collectionView, indexPath, video) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RecentlyPlayedMusicCollectionView.reusableIdentifier,
        for: indexPath
      ) as? RecentlyPlayedMusicItemCollectionViewCell
      return cell
    }
    return dataSource
  }
  
  func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems([
      MusicItem(
        title: "",
        publisherTitle: "fff",
        runningDurationInSeconds: 100,
        musicId: "f7ff88"
      ),
      MusicItem(
        title: "",
        publisherTitle: "fff",
        runningDurationInSeconds: 100,
        musicId: "ffdfss"
      )
    ])
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }

  private func configureLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      
      let size = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.absolute(120),
        heightDimension: NSCollectionLayoutDimension.absolute(160)
      )
      let itemCount = 1
      let item = NSCollectionLayoutItem(layoutSize: size)
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: size,
        repeatingSubitem: item,
        count: itemCount
      )
      
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
      return section
    })
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = .horizontal
    layout.configuration = configuration
    return layout
  }
}

extension UIViewController: MusicItemTableViewActionDelegate {
  func navigateToAddToPlaylistScreen(for musicItem: MusicItem) {
    let musicViewModel = Container.sharedContainer.resolve(BrowsingViewModel.self)!
    musicViewModel.addMusicToPlaylist(controller: self, musicItem: musicItem)
  }
  
  func startDownload(for musicItem: MusicItem) {
    // TODO: -
  }
}

extension MusicItem: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(musicId)
  }
  
}

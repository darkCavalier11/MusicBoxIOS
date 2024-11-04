//
//  SettingsViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import CoreData
import RxCocoa
import RxSwift

class DownloadsViewController: UIViewController {
  private let noDownloadsFoundView = NoDownloadsFoundView()
  private lazy var coreDataStack = CoreDataStack()
  private let hideEmptyDownloadsView = BehaviorRelay<Bool>(value: true)
  private let downloadTableView = DownloadTableView()
  private let disposeBag = DisposeBag()
  
  private lazy var fetchedResultController: NSFetchedResultsController<MusicItemModel> = {
    let fetchRequest = MusicItemModel.fetchRequest()
    let sort = NSSortDescriptor(key: #keyPath(MusicItemModel.title), ascending: true)
    fetchRequest.sortDescriptors = [sort]
    fetchRequest.predicate = NSPredicate(format: "%K != NULL", #keyPath(MusicItemModel.localStorageURL))
    
    return NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: "com.MusicApp.DownloadTableView"
    )
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Downloads"
    
    view.addSubview(downloadTableView)
    view.addSubview(noDownloadsFoundView)
    
    NSLayoutConstraint.activate([
      noDownloadsFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      noDownloadsFoundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noDownloadsFoundView.widthAnchor.constraint(equalToConstant: 250)
    ])
    
    hideEmptyDownloadsView
      .bind(to: noDownloadsFoundView.rx.isHidden)
      .disposed(by: disposeBag)
    
    do {
      try fetchedResultController.performFetch()
      guard let downloadsCount = fetchedResultController.sections?.first?.numberOfObjects, downloadsCount > 0 else {
        hideEmptyDownloadsView.accept(false)
        return
      }
    } catch {
      print("Error NSFetchResultsController \(error.localizedDescription)")
    }
  }
}

extension DownloadsViewController: UITableViewDelegate {
  
}

extension DownloadsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sectionInfo =
            fetchedResultController.sections?[section] else {
      return 0
    }
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DownloadTableView.reusableIdentifier, for: indexPath) as? DownloadTableViewCell else {
      return UITableViewCell()
    }
    
    return cell
  }
}

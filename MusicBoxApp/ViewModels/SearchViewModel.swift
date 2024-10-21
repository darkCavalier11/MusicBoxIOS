//
//  AppModel.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import MusicBox

protocol SearchViewModel {
  var hideSearchView: Observable<Bool> { get }
  var showingHUD: Observable<Bool> { get }
  var typeAheadSearchResult: Observable<[String]> { get }
  func becomeFirstResponder()
  func resignFirstResponder()
  func searchTextDidChange(_ text: String)
}

final class HomeSearchViewModel: SearchViewModel {
  private let mb = MusicBox()
  private let hideSearchViewRelay = BehaviorRelay(value: true)
  private let showingHUDRelay = BehaviorRelay(value: false)
  private let searchTextRelay = BehaviorRelay(value: "")
  
  var typeAheadSearchResult: Observable<[String]> {
    searchTextRelay
      .debounce(.milliseconds(600), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .flatMap { [weak self] query -> Observable<[String]> in
        guard let self = self else {
          return Observable.just([])
        }
        return self.getTypeAheadSearchResult(query: query)
      }
      .subscribe(on: MainScheduler.instance)
  }
  
  var hideSearchView: Observable<Bool> {
    hideSearchViewRelay.asObservable()
  }
  
  var showingHUD: Observable<Bool> {
    showingHUDRelay.asObservable()
  }
  
  func becomeFirstResponder() {
    hideSearchViewRelay.accept(false)
  }
  
  func resignFirstResponder() {
    hideSearchViewRelay.accept(true)
    searchTextRelay.accept("")
  }
  
  func searchTextDidChange(_ text: String) {
    searchTextRelay.accept(text)
  }
  
  private func getTypeAheadSearchResult(query: String) -> Observable<[String]> {
    Observable.create { observer in
      let task = Task { [weak self] in
        self?.showingHUDRelay.accept(true)
        defer { self?.showingHUDRelay.accept(false) }
        guard let results = await self?.mb.musicSession.getTypeAheadSearchResult(query: query) else {
          return
        }
        observer.onNext(results)
      }
      return Disposables.create {
        task.cancel()
      }
    }
  }
}

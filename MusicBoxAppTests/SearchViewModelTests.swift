//
//  SearchViewModelTests.swift
//  MusicBoxAppTests
//
//  Created by Sumit Pradhan on 20/10/24.
//

import Testing
import XCTest
import RxSwift
import RxCocoa
@testable import MusicBoxApp

final class TestSearchViewModel: SearchViewModel {
  private let testHideSearchViewRelay = BehaviorRelay(value: false)
  private let testTypeAheadRelay = BehaviorRelay(value: [String]())
  private let testShowingHUDRelay = BehaviorRelay(value: false)
  var hideSearchView: Observable<Bool> {
    testHideSearchViewRelay.asObservable()
  }
  
  var typeAheadSearchResult: Observable<[String]> {
    testTypeAheadRelay.asObservable()
  }
  
  var showingHUD: Observable<Bool> {
    testShowingHUDRelay.asObservable()
  }
  
  func becomeFirstResponder() {
    testHideSearchViewRelay.accept(true)
  }
  
  func resignFirstResponder() {
    testHideSearchViewRelay.accept(false)
  }
  
  func searchTextDidChange(_ text: String) {
    testShowingHUDRelay.accept(true)
    defer { testShowingHUDRelay.accept(false) }
    sleep(1)
    testTypeAheadRelay.accept(
        [
          text, "1","2","3","4","5"
        ]
    )
  }
}


class SearchViewModelTests: XCTestCase {
  var viewModel: TestSearchViewModel!
  var disposeBag: DisposeBag!
  
  override func setUp() async throws {
    viewModel = TestSearchViewModel()
    disposeBag = DisposeBag()
  }
  
  override func tearDown() async throws {
    viewModel = nil
    disposeBag = nil
  }
  
  func testSearchBarBecameFirstResponder() {
    let expectation = XCTestExpectation(description: "Becoming the first responder should make the focus state to true")
    viewModel.hideSearchView
      .bind { state in
        if state {
          expectation.fulfill()
        }
      }
      .disposed(by: disposeBag)
    viewModel.becomeFirstResponder()
    wait(for: [expectation], timeout: 0.1)
  }
  
  func testSearchBarResignFirstResponder() {
    let expectation = XCTestExpectation(description: "Resigning the first responder should make the focus state to false")
    viewModel.becomeFirstResponder()
    viewModel.hideSearchView
      .bind { state in
        if !state {
          expectation.fulfill()
        }
      }
      .disposed(by: disposeBag)
    viewModel.resignFirstResponder()
    wait(for: [expectation], timeout: 0.1)
  }
  
  func testTypeAheadResults() {
    let expectation = XCTestExpectation(description: "when added some text the result should be there.")
    viewModel.becomeFirstResponder()
    viewModel.typeAheadSearchResult.bind { searchResults in
      if !searchResults.isEmpty {
        expectation.fulfill()
      }
    }
    .disposed(by: disposeBag)
    viewModel.searchTextDidChange("Odia songs")
    wait(for: [expectation], timeout: 2)
  }
  
  func testShowingLoadingHUD() {
    let expectation = XCTestExpectation(description: "When fetching the search results the state of showing HUD should be true")
    viewModel.becomeFirstResponder()
    viewModel.showingHUD.bind { state in
      if state {
        expectation.fulfill()
      }
    }
    .disposed(by: disposeBag)
    viewModel.searchTextDidChange("Odia songs")
    wait(for: [expectation], timeout: 2)
  }
}

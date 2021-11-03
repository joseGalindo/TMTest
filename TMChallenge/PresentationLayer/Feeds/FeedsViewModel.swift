//
//  FeedViewModel.swift
//  TMChallenge
//
//  Created by Jose Galindo Martinez on 02/11/21.
//

import Foundation
import Combine

public enum ListViewModelState: Equatable {
    case idle
    case loading
    case finished
    case error
}

protocol FeedsViewModel: AnyObject {
    
    // Input
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
    var didScrollToTheBottom: PassthroughSubject<Void, Never> { get }
    
    // Output
    var feeds: [GenericResponse<FeedData>] { get }
    var state: CurrentValueSubject<ListViewModelState, Never> { get }
}

class FeedsViewModelImplementation: FeedsViewModel {

    // Input
    var viewDidLoad = PassthroughSubject<Void, Never>()
    var didScrollToTheBottom = PassthroughSubject<Void, Never>()
    
    // Output
    var feeds = [GenericResponse<FeedData>]()
    var state = CurrentValueSubject<ListViewModelState, Never>(.idle)
    
    // private properties
    private var cancelables = Set<AnyCancellable>()
    private var afterLink = ""
    
    init() {
        bindOnDidLoad()
    }
    
    private func bindOnDidLoad() {
        viewDidLoad.sink { [weak self] _ in
            self?.getFeeds()
        }.store(in: &cancelables)
        
        didScrollToTheBottom.sink { [weak self] _ in
            self?.getFeeds()
        }.store(in: &cancelables)
    }
    
    private func getFeeds() {
        var params: APIClient.Parameters = [:]
        if !afterLink.isEmpty {
            params["after"] = afterLink
        }
        self.state.send(.loading)
        APIClient.shared.get(endpoint: .feeds, parameters: params)
            .map { [unowned self] (result: Result<GenericResponse<FeedResponseData>, APIError>) -> Result<[GenericResponse<FeedData>], Error> in
                switch result {
                case .success(let response):
                    self.afterLink = response.data.after
                    return .success(response.data.children)
                case .failure(let error):
                    return .failure(error)
                }
            }
            .map({ (result: Result<[GenericResponse<FeedData>], Error>) -> [GenericResponse<FeedData>] in
                switch result {
                case .success(let newFeeds): return newFeeds
                case .failure: return []
                }
            })
            .sink(receiveValue: { [unowned self] (newFeeds) in
                // Add newly fetched feeds to the array
                self.feeds.append(contentsOf: newFeeds)
                self.state.send(.finished)
            }).store(in: &cancelables)
    }
}

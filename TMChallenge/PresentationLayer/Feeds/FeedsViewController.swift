//
//  FeedsViewController.swift
//  TMChallenge
//
//  Created by Jose Galindo Martinez on 02/11/21.
//

import UIKit
import Combine

class FeedsViewController: UITableViewController {
    
    // MARK: - UI
    lazy var loadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blur)
        NSLayoutConstraint.activate([
            blur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blur.topAnchor.constraint(equalTo: view.topAnchor),
            blur.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .white
        activity.translatesAutoresizingMaskIntoConstraints = false
        blur.contentView.addSubview(activity)
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: blur.contentView.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: blur.contentView.centerYAnchor),
            activity.widthAnchor.constraint(equalToConstant: 20),
            activity.heightAnchor.constraint(equalToConstant: 20),
        ])
        return view
    }()
    
    private let viewModel: FeedsViewModel
    private var bindings = Set<AnyCancellable>()
    
    init(viewModel: FeedsViewModel = FeedsViewModelImplementation()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        viewModel.viewDidLoad.send()
        
        self.view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            loadingView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        ])
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell  else {
            return UITableViewCell()
        }
        cell.feed = viewModel.feeds[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfItems = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == numberOfItems - 1 {
            viewModel.didScrollToTheBottom.send()
        }
    }
}

extension FeedsViewController {
    func setupBindings() {
        viewModel.state
            .receive(on: RunLoop.main)
            .sink { [weak self] (state) in
                if state == .finished {
                    self?.tableView.reloadData()
                }
            }.store(in: &bindings)
    }
}

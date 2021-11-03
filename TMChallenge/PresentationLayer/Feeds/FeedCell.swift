//
//  FeedCell.swift
//  TMChallenge
//
//  Created by Jose Galindo Martinez on 02/11/21.
//

import UIKit
import SDWebImage

class FeedCell: UITableViewCell {
    
    // UI
    lazy var feedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var numComments: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var commentsImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "comments")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var rateImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rate")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Properties
    var feed: GenericResponse<FeedData>? {
        didSet {
            updateValues()
        }
    }

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


// UI Extension
extension FeedCell {
    
    func setupUI() {
        self.contentView.addSubview(title)
        self.contentView.addSubview(feedImage)
        self.contentView.addSubview(stackView)
        let leftContainer = UIView()
        leftContainer.translatesAutoresizingMaskIntoConstraints = false
        let rightContainer = UIView()
        rightContainer.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(leftContainer)
        stackView.addArrangedSubview(rightContainer)
        leftContainer.addSubview(commentsImg)
        leftContainer.addSubview(numComments)
        rightContainer.addSubview(rateImg)
        rightContainer.addSubview(rate)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            commentsImg.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor, constant: 10),
            commentsImg.widthAnchor.constraint(equalToConstant: 20),
            commentsImg.heightAnchor.constraint(equalToConstant: 20),
            commentsImg.centerYAnchor.constraint(equalTo: leftContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            numComments.leadingAnchor.constraint(equalTo: commentsImg.trailingAnchor, constant: 5),
            numComments.trailingAnchor.constraint(equalTo: leftContainer.trailingAnchor, constant: 5),
            numComments.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            numComments.bottomAnchor.constraint(equalTo: leftContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rateImg.leadingAnchor.constraint(equalTo: rightContainer.leadingAnchor),
            rateImg.widthAnchor.constraint(equalToConstant: 20),
            rateImg.heightAnchor.constraint(equalToConstant: 20),
            rateImg.centerYAnchor.constraint(equalTo: rightContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rate.leadingAnchor.constraint(equalTo: rateImg.trailingAnchor, constant: 5),
            rate.trailingAnchor.constraint(equalTo: rightContainer.trailingAnchor, constant: 5),
            rate.topAnchor.constraint(equalTo: rightContainer.topAnchor),
            rate.bottomAnchor.constraint(equalTo: rightContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            feedImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            feedImage.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -5),
            feedImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            feedImage.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            title.bottomAnchor.constraint(equalTo: feedImage.topAnchor, constant: -5)
        ])
    }
    
    func updateValues() {
        guard let feed = feed else { return }
        title.text = feed.data.title
        numComments.text = "Comments: \(feed.data.numComments)"
        rate.text = "Score: \(feed.data.score)"
        
        if feed.data.thumbnail == "self" ||
            feed.data.thumbnail == "default" {
            feedImage.image = UIImage(named: "placeholder")
            return
        }
        guard let url = URL(string: feed.data.thumbnail) else {
            return
        }
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self] (image, data, error, cacheTYpe, finished, url) in
            self?.feedImage.image = image
        }
    }
}

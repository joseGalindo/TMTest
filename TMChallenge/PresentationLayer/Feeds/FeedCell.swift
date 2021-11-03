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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var imageConstraint: NSLayoutConstraint!
    
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
        setupUI()
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
        stackView.addArrangedSubview(commentsImg)
        stackView.addArrangedSubview(numComments)
        stackView.addArrangedSubview(rateImg)
        stackView.addArrangedSubview(rate)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: feedImage.topAnchor)
        ])
        
        imageConstraint = feedImage.heightAnchor.constraint(equalToConstant: 120)
        NSLayoutConstraint.activate([
            feedImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedImage.bottomAnchor.constraint(equalTo: stackView.topAnchor),
            feedImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageConstraint
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func updateValues() {
        guard let feed = feed else { return }
        title.text = feed.data.title
        numComments.text = String(feed.data.numComments)
        rate.text = String(feed.data.score)
        guard let url = URL(string: feed.data.thumbnail) else {
//            imageConstraint.constant = 0
            return
        }
        feedImage.sd_setImage(with: url, completed: nil)
    }
}

protocol ReuseIdentifiable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { .init(describing: self) }
}

extension UITableViewCell: ReuseIdentifiable {}

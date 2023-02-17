//
//  TweetHeader.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/02/14.
//

import UIKit

protocol TweetheaderDelegate: class {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    
    weak var delegate: TweetheaderDelegate?
    
    var tweet: Tweet? {
        didSet{
            configure()
        }
    }
    
    //MARK: Properties
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.text = "Piter Parker"
        return lb
    }()
    
    private let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .lightGray
        lb.text = "spiderman"
        return lb
    }()
    
    private let captionLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 20)
        lb.numberOfLines = 0
        lb.text = "Some test Caption from Spiderman for now"
        return lb
    }()
    private let dateLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 14)
        lb.text = "6:29 PM - 2/14/2023"
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var optionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .lightGray
        btn.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        btn.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return btn
    }()
    
    private lazy var retweetsLabel = UILabel()
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        return view
    }()
    
    private lazy var commentButton: UIButton = {
       let btn = createButton(withImageName: "comment")
        btn.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var retweetButton: UIButton = {
       let btn = createButton(withImageName: "retweet")
        btn.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var likeButton: UIButton = {
       let btn = createButton(withImageName: "like")
        btn.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var shareButton: UIButton = {
       let btn = createButton(withImageName: "share")
        btn.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.spacing = -6
        labelStack.axis = .vertical
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionButton)
        optionButton.centerY(inView: stack)
        optionButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.spacing = 72
//        actionStack.axis = .horizontal
//        actionStack.distribution = .fillEqually
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top: statsView.bottomAnchor, paddingTop: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Selectors
    @objc func handleProfileImageTapped() {
        
    }
    
    @objc func showActionSheet() {
        self.delegate?.showActionSheet()
    }
    
    @objc func handleRetweetsTapped() {
        
    }
    
    @objc func handleLikesTapped() {
        
    }
    
    @objc func handleCommentTapped() {
        
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
    }
    
    @objc func handleShareTapped() {
        
    }
    
    
    //MARK: Helpers
    func createButton(withImageName imageName: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.tintColor = .darkGray
        btn.setDimensions(width: 20, height: 20)
        return btn
    }
    
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestemp
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
    }
}

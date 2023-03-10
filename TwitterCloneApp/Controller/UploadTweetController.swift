//
//  UploadTweetController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/10.
//

import UIKit

class UploadTweetController: UIViewController {
    
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    //MARK: Properties
    private lazy var actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .twitterBlue
        btn.setTitle("Tweet", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 32 / 2
        btn.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        btn.addTarget(self, action: #selector(handleUploadTweet) , for: .touchUpInside)
        return btn
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private lazy var replyLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14)
        lb.textColor = .lightGray
        lb.text = "replying to @spiderman"
        lb.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return lb
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK: LifeCycle
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    //MARK: API
    
    
    //MARK: Selectors
    @objc func handleCancle() {
        self.dismiss(animated: true)
    }
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shard.uploadTweet(caption: caption, type: config) { ref, error in
//            print("seccessfully upload Tweet")
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
            }
            self.dismiss(animated: true)
        }
    }
    
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor ,paddingTop: 16,paddingLeft: 16, paddingRight: 16)
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.standardAppearance = Utilities().configureNavigationBar()
        navigationController?.navigationBar.scrollEdgeAppearance = Utilities().configureNavigationBar()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }

}

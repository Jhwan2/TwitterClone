//
//  UploadTweetController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/10.
//

import UIKit

class UploadTweetController: UIViewController {
    
    private let user: User
    
    
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
    
    //MARK: LifeCycle
    init(user: User) {
        self.user = user
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
        print(#function)
    }
    
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,paddingTop: 16,paddingLeft: 16)
        profileImageView.sd_setImage(with: user.profileImageUrl)
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

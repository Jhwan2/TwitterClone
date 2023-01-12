//
//  FeedController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/02.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    
    //MARK: Properties
    
    var user: User? {
        didSet{
            configureLeftBarButton()
        }
    }
    
    
    //MARK: API
    func fetchTweets() {
        TweetService.shard.fetchTweets { tweet in
            print(tweet)
        }
    }

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
//        view.addSubview(collectionView)
//        collectionView.backgroundColor = .red
//        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func configureLeftBarButton() {
        guard let user = self.user else { return }
        let profileImageView = UIImageView()
//        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

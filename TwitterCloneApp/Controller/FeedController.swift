//
//  FeedController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/02.
//

import UIKit
import SDWebImage
private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {
    
    
    //MARK: Properties
    var user: User? {
        didSet{
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: API
    func fetchTweets() {
        TweetService.shard.fetchTweets { tweet in
            self.tweets = tweet
        }
    }

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: Helpers
    func configureUI() {
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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

//MARK: CollectionView/ DataSource
extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TweetContoller(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UICollectionViewFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(withWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 80)
    }
}

//MARK: TweetCellDelegate
extension FeedController: TweetCellDelegate {
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let cv = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: cv)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

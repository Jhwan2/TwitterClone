//
//  ProfileController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/02/02.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    //MARK: Properties
    private var user: User
    
    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replies = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets:
            return tweets
        case .replies:
            return replies
        case .likes:
            return likedTweets
        }
    }
    

    
    //MARK: LifeCycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweet()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchLikedTweets()
        fetchReplies()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    //MARK: API
    func fetchTweet() {
        TweetService.shard.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shard.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikedTweets() {
        TweetService.shard.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets
        }
    }
    
    func fetchReplies() {
        TweetService.shard.fetchReplies(forUser: user) { tweets in
            self.replies = tweets
        }
    }
    
    func fetchUserStats() {
        UserService.shard.fetchUserStats(uid: user.uid) {stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    //MARK: Helper
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
}

//MARK: CollectionView Delegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        
        return header
    }
}

//MARK: UICollectionViewData Source
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
}

//MARK: UICollectionViewFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        let height = viewModel.size(withWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 80)
    }
}

//MARK: ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
    
    func handleEditProfileFollow(_ Header: ProfileHeader) {
        if user.isCurrentUser {
            print("DEBUG: my profile..")
            return
        }
        if user.isFollowed {
            UserService.shard.unfollowUser(uid: user.uid) { (ref, error) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                
                
            }
        } else {
            UserService.shard.followUser(uid: user.uid) { (ref, error) in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
            }
        }
    }
    
    func handleDissmissal() {
        navigationController?.popViewController(animated: true)
    }
}

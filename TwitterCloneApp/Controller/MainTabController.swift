//
//  MainTabController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/02.
//
import Firebase
import UIKit

class MainTabController: UITabBarController {
    
    //MARK: Properties
    var user: User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .twitterBlue
        btn.tintColor = .white
        btn.setImage(UIImage(named: "new_tweet"), for: .normal)
        btn.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserLogOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    //MARK: API
    func fetchUser() {
        UserService.shard.fetchUser { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            configureUI()
            configureViewController()
            fetchUser()
        }
    }
    
    func UserLogOut() {
        do {
            print("User log out ..")
            try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    //MARK: Selectors
    @objc func actionButtonTapped() {
        guard let user = self.user else { return }
        let con = UploadTweetController(user: user)
        let nav = UINavigationController(rootViewController: con)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    
    //MARK: Helpers
    func configureUI(){
        tabBar.layer.applyShadow()
        view.backgroundColor = .white
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewController() {
        self.tabBar.backgroundColor = .white
        let feed = FeedController()
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let exploer = ExploerController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: exploer)
        
        let notifi = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifi)
        
        let conv = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conv)
        
        self.viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.backgroundColor = .white
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = navigationBarAppearance
        nav.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        return nav
    }
    
    
}

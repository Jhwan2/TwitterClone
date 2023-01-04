//
//  FeedController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/02.
//

import UIKit

class FeedController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}

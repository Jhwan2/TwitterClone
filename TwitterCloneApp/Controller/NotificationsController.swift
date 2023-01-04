//
//  NotificationsController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/02.
//

import UIKit

class NotificationsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }

}

//
//  User.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/10.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullname: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }

    
    init(uid: String, dic: [String:AnyObject]) {
        self.uid = uid
        self.email = dic["email"] as? String ?? ""
        self.fullname = dic["fullname"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
        if let profileImageUrlString = dic["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

//
//  UserService.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/10.
//

import Foundation
import Firebase

struct UserService {
    static let shard = UserService()
    
    func fetchUser(uid: String, completion:@escaping(User) -> Void) {

        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dic = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User.init(uid: uid, dic: dic)
            completion(user)
        }
    }
}

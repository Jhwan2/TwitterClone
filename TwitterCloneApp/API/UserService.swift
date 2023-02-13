//
//  UserService.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/10.
//

import Foundation
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shard = UserService()
    
    func fetchUser(uid: String, completion:@escaping(User) -> Void) {

        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dic = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User.init(uid: uid, dic: dic)
            completion(user)
        }
    }
    
    func fetchUser(completion:@escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dic: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion:@escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { error, ref in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion:@escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUid).removeValue { (err,ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion:@escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}

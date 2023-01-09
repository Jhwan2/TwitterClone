//
//  AuthService.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/09.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let username: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthService {
    static let shard = AuthService()
    
    func registerUser(credentail: AuthCredentials, completion: @escaping(Error?, DatabaseReference)-> Void) {
        let email = credentail.email
        let pw = credentail.password
        let fullname = credentail.fullname
        let username = credentail.username
        
        guard let imageData = credentail.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData) { meta, error in
            storageRef.downloadURL { url, error in
                
                guard let profileImageUrl = url?.absoluteString else { return }
                Auth.auth().createUser(withEmail: email, password: pw) { result, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let uid = result?.user.uid else { return }
                    let values = ["email":email, "username":username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}

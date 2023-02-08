//
//  ProfileHeaderViewModel.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/02/06.
//

import Foundation
import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    var followersString: NSAttributedString? {
        return attributedText(withValue: 0, text: "followers")
    }
    var followingString: NSAttributedString? {
        return attributedText(withValue: 2, text: "following")
    }
    
    init(user: User) {
        self.user = user
    }
    private func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSMutableAttributedString(string: "\(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
//
//  ProfileHeader.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/02/02.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    //MARK: Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        var img = #imageLiteral(resourceName: "baseline_arrow_back_white_24dp")
        button.setImage(img, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Selectors
    @objc func handleDismissal() {
        
    }
    
}

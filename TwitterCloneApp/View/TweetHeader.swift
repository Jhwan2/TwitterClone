//
//  TweetHeader.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/02/14.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    
    //MARK: Properties
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.text = "Piter Parker"
        return lb
    }()
    
    private let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .lightGray
        lb.text = "spiderman"
        return lb
    }()
    
    private let captionLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 20)
        lb.numberOfLines = 0
        lb.text = "Some test Caption from Spiderman for now"
        return lb
    }()
    private let dateLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 14)
        lb.text = "6:29 PM - 2/14/2023"
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var optionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .lightGray
        btn.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        btn.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return btn
    }()
    
    
    //MARK: 2/14 요까지 14:32
    private lazy var statsView: UIView = {
        let view = UIView()
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        return view
    }()
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.spacing = -6
        labelStack.axis = .vertical
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionButton)
        optionButton.centerY(inView: stack)
        optionButton.anchor(right: rightAnchor, paddingRight: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Helpers
    @objc func handleProfileImageTapped() {
        
    }
    
    @objc func showActionSheet() {
        
    }
}

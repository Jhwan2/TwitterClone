//
//  ProfileFilterCell.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/02/06.
//

import UIKit

class ProfileFileterCell: UICollectionViewCell {
    
    
    //MARK: Properties
    var option: ProfileFilterOptions! {
        didSet{
            titleLabel.text = option.description
        }
    }
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "Test !"
        return lb
    }()
    
    override var isSelected: Bool {
        didSet{
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  LoginController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/04.
//

import UIKit

class LoginController: UIViewController {
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private var emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "email")
        return tf
    }()
    private var passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Log In", for: .normal)
        btn.setTitleColor(.twitterBlue, for: .normal)
        btn.backgroundColor = .white
        btn.anchor(height: 50)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingLeft: 32,paddingRight: 32)
    }
    
}

//
//  RegistrationController.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/04.
//

import UIKit
import Firebase

final class RegistrationController: UIViewController {

    //MARK: Properties
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(handleProfilePhoto), for: .touchUpInside)
        return btn
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private var emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "email")
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private var passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
        return view
    }()
    
    private var fullNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private lazy var userNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: userNameTextField)
        return view
    }()
    
    private var userNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "User name")
        return tf
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let btn = Utilities().attributedButton("Already have an account?", " Log In")
        btn.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return btn
    }()
    
    private let RegistrationButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.twitterBlue, for: .normal)
        btn.backgroundColor = .white
        btn.anchor(height: 50)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return btn
    }()

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Selecters
    @objc func handleProfilePhoto() {
        present(imagePicker, animated: false)
    }
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    @objc func handleRegistration(){
        
        guard let profileImage = profileImage else { return
            print("select your profileImage plz ..")
        }
        guard let email = emailTextField.text else { return }
        guard let pw = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = userNameTextField.text?.lowercased() else { return }
        
        let credential = AuthCredentials(email: email, password: pw, username: username, fullname: fullname, profileImage: profileImage)
        
        AuthService.shard.registerUser(credentail: credential) { error, ref in
            print("Scccessfully update user information. ")
            
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true)
        }
    }
    
    //MARK: Helpers
    func configureUI() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView, fullNameContainerView, userNameContainerView, RegistrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor, paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 16)
        alreadyHaveAccountButton.centerX(inView: view)
        
    }
}


//MARK: UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let safeImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = safeImage
        
        plusPhotoButton.layer.cornerRadius = 128/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(safeImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
}

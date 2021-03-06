//
//  LoginViewController.swift
//  Messenger
//
//  Created by Jh's MacbookPro on 2020/06/20.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD
class LoginViewController: UIViewController {
    
    private let spiiner = JGProgressHUD(style: .dark)
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "messenger")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "이메일 주소를 입력해주세요"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "비밀번호를 입력해주세요"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginBtn : UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight:.bold)
        return button
    }()
    private let registerBtn : UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight:.bold)
        return button
    }()
    
    private let facebookloginButton : FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email,public_profile"]
        return button
    }()
    private let googleLoginButton = GIDSignInButton()
    
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: Notification.Name.didLoginNotification, object: nil, queue: .main, using: {[weak self] _ in
        guard let strongSelf = self else{return}
        strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        GIDSignIn.sharedInstance()?.presentingViewController = self
        title = "로그인"
        view.backgroundColor = .white
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "회원가입", style: .done, target: self, action: #selector(didTapRegister))
        
        loginBtn.addTarget(self, action: #selector(loginBtnEvent), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        facebookloginButton.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginBtn)
        scrollView.addSubview(registerBtn)
        scrollView.addSubview(facebookloginButton)
        scrollView.addSubview(googleLoginButton)
    }
    
    deinit {
        if let observer = loginObserver{
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 2, y: 20, width: size, height: size)
        emailField.frame = CGRect(x: 30, y: imageView.bottom + 30, width: scrollView.width - 60, height: 52)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: scrollView.width - 60, height: 52)
        loginBtn.frame = CGRect(x: 30, y: passwordField.bottom + 20, width: scrollView.width - 60, height: 52)
        facebookloginButton.frame = CGRect(x: 40, y: loginBtn.bottom + 10, width: scrollView.width - 80, height: 35)
        googleLoginButton.frame = CGRect(x: 40, y: facebookloginButton.bottom + 10, width: scrollView.width - 80, height: 35)
        registerBtn.frame = CGRect(x: 40, y: googleLoginButton.bottom + 20, width: scrollView.width - 80, height: 35)
    }
    
    @objc func loginBtnEvent(){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        spiiner.show(in: view)
        //Firebase LogIn
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult, error in
            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                strongSelf.spiiner.dismiss()
            }
            guard let result = authResult, error == nil else{
                print("error")
                return
            }
            let user = result.user
            print("logged in user : \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
    }
    func alertUserLoginError(){
        let alert = UIAlertController(title: "에러", message: "모든 로그인 정보는 필수입니다", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @objc func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "회원가입"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginBtnEvent()
        }
        
        return true
    }
    
}

extension LoginViewController : LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else{
            print("User failed to log in with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, picture.type(large)"], tokenString: token, version: nil, httpMethod: .get)
        facebookRequest.start(completionHandler: {_, result, error in
            guard let result = result as? [String : Any],
                error == nil
                else{
                    print("failed to make facebook graph request")
                    return
            }
            print("\(result)")
            guard let firstName = result["first_name"] as? String,
                let lastName = result["last_name"] as? String,
                let email = result["email"] as? String,
                let picture = result["picture"] as? [String : Any?],
                let data = picture["data"] as? [String : Any],
            let pictureUrl = data["url"] as? String
            else {
                    print("failed to get email and name from fb result")
                    return
            }
            
            DatabaseManager.shared.userExists(with: email, completion: {exists in
                
                if !exists{
                    let chatUser = ChatAppUser(firstName: String(firstName), lastName: String(lastName), emailAddress: email)

                    DatabaseManager.shared.insertUser(with: chatUser,completion: {success in
                        if success{
                            guard let url = URL(string: pictureUrl) else{
                                return
                            }
                            print("Downloading data from facebook image")
                            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
                                guard let data = data else{
                                    print("failed to get data from facebook")
                                    return
                                }
                                print("got data from FB, uploading...")
                                let fileName =  chatUser.profilePictureFileURL
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: {result in
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("storage manager error : \(error)")
                                    }
                                })
                                }).resume()
                        }
                    })
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                
                guard let strongSelf = self else{
                    return
                }
                guard authResult != nil, error == nil else {
                    if let error = error{
                        print("facebook credential login failed, MFA may be need - \(error)")
                    }
                    return
                }
                print("successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
            })
        })
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no operation
    }
    
    
}


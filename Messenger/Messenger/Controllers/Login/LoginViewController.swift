//
//  LoginViewController.swift
//  Messenger
//
//  Created by Jh's MacbookPro on 2020/06/20.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "로그인"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "회원가입", style: .done, target: self, action: #selector(didTapRegister))
        
        loginBtn.addTarget(self, action: #selector(loginBtnEvent), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginBtn)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 2, y: 20, width: size, height: size)
        emailField.frame = CGRect(x: 30, y: imageView.bottom + 30, width: scrollView.width - 60, height: 52)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: scrollView.width - 60, height: 52)
        loginBtn.frame = CGRect(x: 30, y: passwordField.bottom + 20, width: scrollView.width - 60, height: 52)
    }
    
    @objc func loginBtnEvent(){
        
        emailField.resignFirstResponder()
         passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
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
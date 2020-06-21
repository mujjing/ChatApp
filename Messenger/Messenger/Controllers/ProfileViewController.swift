//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Jh's MacbookPro on 2020/06/20.
//  Copyright © 2020 JH. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let data = ["Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
      
    }

}
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let actionSheet = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: {[weak self] _ in
            
            guard let strongSelf = self else{ return }
            
            do{
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                
                nav.modalPresentationStyle = .fullScreen
                
                strongSelf.present(nav, animated: false)
                print("log out success")
            }catch{
                print("log out failed")
            }
        })
        )
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil ))
        present(actionSheet, animated: true)
    
    }
}

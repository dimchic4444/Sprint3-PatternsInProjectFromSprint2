//
//  AuthorizationViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 08/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let picture = UIImageView(image: UIImage(named: "logo"))
        picture.frame = CGRect(x: 0, y: 0, width: 256, height: 256)
        picture.center = CGPoint(x: view.center.x, y: view.center.y - 150)
        
        let signInButton = UIButton(type: .system)
        signInButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        signInButton.backgroundColor = UIColor(named: "Purple")
        signInButton.center = CGPoint(x: view.center.x, y: view.center.y + 10)
        signInButton.setTitle("Sign IN", for: .normal)
        signInButton.addTarget(self, action: #selector(signInFunc), for: .touchUpInside)
        signInButton.tintColor = .white
        
        let signUpButton = UIButton(type: .system)
        signUpButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        signUpButton.backgroundColor = UIColor(named: "Purple")
        signUpButton.center = CGPoint(x: view.center.x, y: view.center.y + 80)
        signUpButton.setTitle("Sign UP", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpFunc), for: .touchUpInside)
        signUpButton.tintColor = .white
        
        
        view.addSubview(picture)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc
    func signInFunc() {
        let signInVC = SignInViewController()
        signInVC.title = "Login"
        navigationController?.pushViewController(signInVC, animated: true)
        
    }
    @objc
    func signUpFunc() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    

    

}

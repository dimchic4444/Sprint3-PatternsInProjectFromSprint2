//
//  SignInViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 08/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

let apiKey = "c9b74e8786c06b03e09f8cbf7fa60bd9"


class SignInViewController: UIViewController {
    
    let targetURL = "https://trello.com/1/token/approve"
    
    var continueButton : UIButton!
    var loginButton : UIButton!
    
    var loginLink : String {
        return "https://trello.com/1/authorize?expiration=1day&name=PurpleTeam&scope=read,write&response_type=token&key=\(apiKey)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        continueButton = UIButton(type: .roundedRect)
        continueButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        continueButton.backgroundColor = UIColor(named: "Purple")
        continueButton.center = view.center
        continueButton.setTitle("Continue", for: .normal)
        continueButton.addTarget(self, action: #selector(openAppFunc), for: .touchUpInside)
        continueButton.tintColor = .white
        
        loginButton = UIButton(type: .roundedRect)
        loginButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        loginButton.backgroundColor = UIColor(named: "Purple")
        loginButton.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButttonTapped), for: .touchUpInside)
        loginButton.tintColor = .white
        
        
        view.addSubview(continueButton)
        view.addSubview(loginButton)
    }
    
    
    
    @objc
    func loginButttonTapped() {
        let webVC = WebViewController()
        webVC.link = loginLink
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    @objc
    func openAppFunc() {
        if UserDefaults.standard.string(forKey: "token") != "" {
            let loadingVC = LoadingViewController()
            loadingVC.modalPresentationStyle = .fullScreen
            self.present(loadingVC, animated: true, completion: nil)
        } else {
            continueButton.backgroundColor = .red
            sleep(1)
            continueButton.backgroundColor = UIColor(named: "Purple")
        }
    }

    

}

//
//  SettingsViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 08/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settings-selected"))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let signOut = UIButton(type: .roundedRect)
        signOut.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        signOut.backgroundColor = UIColor(named: "Purple")
        signOut.center = view.center
        signOut.setTitle("Sign OUT", for: .normal)
        signOut.addTarget(self, action: #selector(signOutFunc), for: .touchUpInside)
        signOut.tintColor = .white
        
        view.addSubview(signOut)
    }
    
    @objc
    func signOutFunc() {

        UserDefaults.standard.set("", forKey: "token")
        Navigator.backToAuth()
        }

    

}

//
//  ViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 08/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
let startButton = UIButton(type: .roundedRect)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if (UserDefaults.standard.string(forKey: "token") == nil) {
            UserDefaults.standard.set("", forKey: "token")
        }
        
        startButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        startButton.backgroundColor = UIColor(named: "Purple")
        startButton.center = view.center
        startButton.setTitle("Начать!", for: .normal)
        startButton.tintColor = .white
        startButton.addTarget(self, action: #selector(startFunc), for: .touchUpInside)
        
        let helloLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
        helloLabel.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        helloLabel.text = "Добро пожаловать!"
        
        view.addSubview(startButton)
        view.addSubview(helloLabel)


    }
    
    @objc
    func startFunc() {
        UIView.animate(withDuration: 0.2, animations: {
            self.startButton.frame.size = CGSize(width: 0.7 * self.startButton.frame.width, height: 0.7 * self.startButton.frame.height)
            self.startButton.center = self.view.center
        }) { (true) in
            UIView.animate(withDuration: 0.3, animations: {
                self.startButton.frame.size = CGSize(width: 100.1 * self.startButton.frame.width, height: 100.1 * self.startButton.frame.height)
                self.startButton.center = self.view.center
            }, completion: { (true) in
                if (UserDefaults.standard.string(forKey: "token") == "")
                {
                    self.present(TabBarControllerBuilder.openAuthorizationWindow(), animated: true, completion: nil)
                } else {
                    let loadingVC = LoadingViewController()
                    loadingVC.modalPresentationStyle = .fullScreen
                    self.present(loadingVC, animated: true, completion: nil)
                }
            })
        }
    }
}


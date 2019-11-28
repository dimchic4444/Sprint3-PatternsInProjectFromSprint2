//
//  SignUpViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 08/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let warningLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
        warningLabel.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        warningLabel.text = "Извините, данная функция сейчас недоступна.\n Зарегистрируйтесь через сайт"
        warningLabel.textAlignment = .center
        warningLabel.numberOfLines = 0
        
        view.addSubview(warningLabel)
        
    }
    

   

}

//
//  LoadingViewController.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 16/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var squares : [UIView] = []
        
        self.view.backgroundColor = .white
        
        let squareNumber = 4
        
        let animateView = UIView()
        animateView.frame = CGRect(x: view.center.x, y: view.center.y, width: 150, height: 150)
        animateView.center = view.center
        
        for i in 1...squareNumber {
            let square = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
            square.backgroundColor = i % 2 == 0 ? .lightGray : .orange
            squares.append(square)
            
            animateView.addSubview(square)
        }
        
        var orbites : [CAKeyframeAnimation] = []
        
        let time : Float = 1.5
        
        for i in 1...squareNumber {
            let orbit = CAKeyframeAnimation(keyPath: "position")
            let orbitBounds = CGRect(x: 0, y: 0, width: 30.0 + Double(i) * 30.0, height: 30.0 + Double(i) * 30.0)
            orbit.path = CGPath(ellipseIn: orbitBounds, transform: nil)
            orbit.duration = Double(i)
            orbit.isAdditive = true
            orbit.repeatCount = time / Float(orbit.duration) // количество повторений
            orbit.calculationMode = .paced // постоянная скорость
            orbit.rotationMode = nil //
            orbites.append(orbit)
            squares[i - 1].layer.add(orbit, forKey: "orbit")
        }
        
        view.addSubview(animateView)
        
        let mockView = UIView()
        mockView.alpha = 0
        view.addSubview(mockView)
        
        UIView.animate(withDuration: 0.0, delay: Double(time), animations: {
                    mockView.layer.opacity = 1
        }, completion: { (true) in self.present(TabBarControllerBuilder.makeAuthorizationAndOpenApp(), animated: true)})
        
        
    }

}

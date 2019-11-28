//
//  Navigator.swift
//  Sprint2-Carkas
//
//  Created by Aleksey Shepelev on 10/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import Foundation
import UIKit

class Navigator {
    static  func backToAuth() {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(
            animated: false,
            completion: {() in UIApplication.shared.keyWindow?.rootViewController?.present(TabBarControllerBuilder.openAuthorizationWindow(), animated: true, completion: nil)}
        )
    }
}

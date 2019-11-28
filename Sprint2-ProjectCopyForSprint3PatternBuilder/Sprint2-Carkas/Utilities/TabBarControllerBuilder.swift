//
//  TabBarViewControllerBuilder.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 08/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class TabBarControllerBuilder {
    
    public static func makeAuthorizationAndOpenApp() -> UITabBarController
    {
        let builderMenuScreens = BuilderMenuScreens()
        let directorOfBuilderMenuScreens = Director(builder: builderMenuScreens)
//        let noteScreenVC = NotesViewController()  //перенесем в builder
//        let settingVC = SettingsViewController()  //перенесем в builder
//        let tasksVC = TasksViewController()  //перенесем в builder
        directorOfBuilderMenuScreens.buildMakeAuthorizationAndOpenAppScreens()
        let tabBar = UITabBarController()
//        let navVCForNotes = UINavigationController() //перенесем в builder
//        navVCForNotes.viewControllers = [noteScreenVC] //перенесем в builder
        
        tabBar.viewControllers = builderMenuScreens.getScreensAndReset()
        tabBar.modalPresentationStyle = .fullScreen
        return tabBar
    }
    
    public static func openAuthorizationWindow() -> UINavigationController
    {
        let builderMenuScreens = BuilderMenuScreens()
        let directorOfBuilderMenuScreens = Director(builder: builderMenuScreens)
//        let regVC = LoginViewController()  //перенесем в builder
        directorOfBuilderMenuScreens.buildOpenAuthorizationWindowScreens()
        let navVCForReg = UINavigationController(rootViewController: builderMenuScreens.getScreensAndReset()[0])
        navVCForReg.modalPresentationStyle = .fullScreen
        return navVCForReg
    }
}

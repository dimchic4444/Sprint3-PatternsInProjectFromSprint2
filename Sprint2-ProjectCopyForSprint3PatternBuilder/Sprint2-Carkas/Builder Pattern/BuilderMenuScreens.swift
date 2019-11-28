//
//  BuilderMenuScreens.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 28/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit


protocol BuilderMenuScreensProtocol {
    func addNoteVCWrappedNavVC()
    func addSettingsVC()
    func addTasksVC()
    func addLoginVC()
    
}

class heapOfScreens {
    private var screens = [UIViewController]()
    func add(screen: UIViewController) {
        self.screens.append(screen)
    }
    func returnHeapOfScreens() -> [UIViewController]
    {
        return self.screens
    }
}

class BuilderMenuScreens: BuilderMenuScreensProtocol {
    private var screensHeap = heapOfScreens()
    func reset() {
        screensHeap = heapOfScreens()
    }
    func addNoteVCWrappedNavVC() {
        let navVCForNotes = UINavigationController()
        navVCForNotes.viewControllers = [NotesViewController()]
        screensHeap.add(screen: navVCForNotes)
    }
    
    func addSettingsVC() {
        screensHeap.add(screen: SettingsViewController())

    }
    
    func addTasksVC() {
        screensHeap.add(screen: TasksViewController())

    }
    
    func addLoginVC() {
        screensHeap.add(screen: LoginViewController())

    }
    
    func getScreensAndReset() -> [UIViewController]
    {
        let result = self.screensHeap.returnHeapOfScreens()
        reset()
        return result
    }
    
}

class Director {
    private var builder: BuilderMenuScreensProtocol?
    
    init(builder: BuilderMenuScreensProtocol) {
        self.builder = builder
    }
    
    func buildMakeAuthorizationAndOpenAppScreens() {
        builder?.addNoteVCWrappedNavVC()
        builder?.addSettingsVC()
        builder?.addTasksVC()
    }
    func buildOpenAuthorizationWindowScreens() {
        builder?.addLoginVC()
    }
}

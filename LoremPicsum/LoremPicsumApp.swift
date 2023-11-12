//
//  LoremPicsumApp.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootScene = PhotoScene()
        
        let viewController = rootScene.viewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        window.backgroundColor = .red
        self.window = window
        return true
    }
}

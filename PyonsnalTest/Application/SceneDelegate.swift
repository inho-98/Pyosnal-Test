//
//  SceneDelegate.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/04.
//

import UIKit
import ModernRIBs

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var launchRouter: LaunchRouting?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        
        let window: UIWindow = .init(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        
        let appRootBuilder: AppRootBuilder = .init(dependency: AppComponent())
        let launchRouter: LaunchRouting = appRootBuilder.build()
        self.launchRouter = launchRouter
        
        launchRouter.launch(from: window)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}


//
//  SceneDelegate.swift
//  Fortune telling and memes
//
//  Created by Надежда Капацина on 02.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MemsViewController()
        window?.makeKeyAndVisible()
    }




}


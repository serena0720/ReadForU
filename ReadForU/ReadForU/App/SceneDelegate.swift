//
//  SceneDelegate.swift
//  ReadForU
//
//  Created by Serena on 2023/10/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        setNavigationAppearance()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    private func setNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .mainPink
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

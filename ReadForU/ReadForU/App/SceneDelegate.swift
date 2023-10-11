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
        
        let loadingViewController = LoadingViewController()
        let navigationController = UINavigationController(rootViewController: loadingViewController)
        
        setNavigationAppearance()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    private func setNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 255/255, green: 90/255, blue: 93/255, alpha: 90/100)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

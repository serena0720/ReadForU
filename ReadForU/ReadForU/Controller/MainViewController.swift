//
//  MainViewController.swift
//  ReadForU
//
//  Created by Serena on 2023/10/09.
//

import UIKit

final class MainViewController: UIViewController {
    private let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    private let mainView = MainView(frame: .zero)
    
    
    override func loadView() {
        view = mainView
        print("loadview")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoadingViewController()
        setUpNavigationBar()
        setUpNavigationBackBarButton()
        assignDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.buttonView.checkLanguage()
    }
    
    private func setUpNavigationBar() {
        let titleImageView = UIImageView()
        
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = UIImage(named: "title")
        
        navigationItem.titleView = titleImageView
        navigationItem.hidesBackButton = true
    }
    
    private func setUpNavigationBackBarButton() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        backBarButtonItem.tintColor = .white
        
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // MARK: - Private
    private func startLoadingViewController() {
        if !launchedBefore {
            let loadingViewController = LoadingViewController()
            
            navigationController?.pushViewController(loadingViewController, animated: true)
            
            UserDefaults.standard.setValue(true, forKey: "launchedBefore")
        }
    }
}

// MARK: - Delegate
extension MainViewController: MainViewDelegate {
    private func assignDelegate() {
        mainView.delegate = self
    }
    
    func showBasicTranslateViewController() {
        let basicTranslateViewController = BasicTranslateViewController()
        
        navigationController?.pushViewController(basicTranslateViewController, animated: true)
    }
    
    func showRealTimeTranslateViewController() {
        let realTimeTranslateViewController = RealTimeTranslateViewController()
        
        navigationController?.pushViewController(realTimeTranslateViewController, animated: true)
    }
}

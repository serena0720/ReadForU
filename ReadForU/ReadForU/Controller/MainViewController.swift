//
//  MainViewController.swift
//  ReadForU
//
//  Created by Serena on 2023/10/09.
//

import UIKit

final class MainViewController: UIViewController {
    private let mainView = MainView(frame: .zero)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        assignDelegate()
    }
    
    private func setUpNavigationBar() {
        let titleImageView = UIImageView()
        
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = UIImage(named: "title")
        
        navigationItem.titleView = titleImageView
        navigationItem.hidesBackButton = true
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

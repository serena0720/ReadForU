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
    }
    
    private func setUpNavigationBar() {
        let titleImageView = UIImageView()
        
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = UIImage(named: "title")
        
        navigationItem.titleView = titleImageView
        navigationItem.hidesBackButton = true
    }
}

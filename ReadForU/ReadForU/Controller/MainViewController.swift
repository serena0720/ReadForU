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
    }
}

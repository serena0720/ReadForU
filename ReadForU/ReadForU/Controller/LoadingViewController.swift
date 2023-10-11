//
//  LoadingViewController.swift
//  ReadForU
//
//  Created by Serena on 2023/10/10.
//

import UIKit

final class LoadingViewController: UIViewController {
    private let loadingView = LoadingView(frame: .zero)
    
    override func loadView() {
        view = loadingView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    }
}

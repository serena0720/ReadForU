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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

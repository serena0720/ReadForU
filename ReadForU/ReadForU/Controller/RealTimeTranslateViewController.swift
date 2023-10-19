//
//  RealTimeTranslateViewController.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit

final class RealTimeTranslateViewController: UIViewController {
    private let realTimeView = RealTimeTranslateView(frame: .zero)
    
    override func loadView() {
        view = realTimeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//
//  BasicTranslateViewController.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit

final class BasicTranslateViewController: UIViewController {
    private let basicView = BasicTranslateView(frame: .zero)
    
    override func loadView() {
        view = basicView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicView.buttonView.checkLanguage()
    }
}

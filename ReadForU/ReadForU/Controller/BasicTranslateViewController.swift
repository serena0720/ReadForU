//
//  BasicTranslateViewController.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit

final class BasicTranslateViewController: UIViewController, AlertControllerShowable {
    private let basicView = BasicTranslateView(frame: .zero)
    private let translateService = TranslateService()
    private var timer: Timer?
    
    override func loadView() {
        view = basicView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicView.buttonView.checkLanguage()
        self.hideKeyboardWhenTappedAround()
        DispatchQueue.main.async {
            self.startTimer()
        }
    }
    
    // Private
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(notifyRequestTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    
    @objc
    private func notifyRequestTime() {
        if basicView.sourceLanguageTextField.text != nil {
            print("1초마다 호출")
        }
    }
}

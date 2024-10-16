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
        hideKeyboardWhenTappedAround()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
    
    // MARK: - Private
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2,
                                     target: self,
                                     selector: #selector(notifyRequestTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func translateSourceLanguage() {
        guard let resultText = basicView.sourceLanguageTextField.text else { return }
        translateService.postPapagoRequest(source: LanguageInfo.shared.source.code,
                                     target: LanguageInfo.shared.target.code,
                                           text: resultText) { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    let result = result.message.result.translatedText
                    
                    self.basicView.targetLanguageLabel.text = result
                }
            case .failure:
                DispatchQueue.main.async {
                    let cancel = UIAlertAction(title: "뒤돌아가기", style: .cancel) { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
                    self.showAlertController(title: "네트워크 오류", message: "네트워크 문제가 발생하였습니다.", style: .alert, actions: [cancel])
                    self.timer?.invalidate()
                }
            }
        }
    }
    
    @objc
    private func notifyRequestTime() {
        if basicView.sourceLanguageTextField.text != nil,
           basicView.sourceLanguageTextField.text != "",
           basicView.sourceLanguageTextField.text != "번역할 내용을 입력하세요." {
            translateSourceLanguage()
        }
    }
}

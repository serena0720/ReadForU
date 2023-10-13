//
//  LaunguageChangeButtonView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/13.
//

import UIKit

class LanguageChangeButtonView: UIView {
    // TODO: - 전체 앱에서 공유
    var sourceLanguage: String = "ko"
    var targetLanguage: String = "en"
    
    private lazy var sourceLanguageButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = UIMenu(title: "원어", children: [
            UIAction(title: "ko", state: .on, handler: selectLanguageAction),
            UIAction(title: "en", handler: selectLanguageAction),
            UIAction(title: "일본어", handler: selectLanguageAction),
            UIAction(title: "중국어 간체", handler: selectLanguageAction),
            UIAction(title: "중국어 번체", handler: selectLanguageAction)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.tintColor = .reversedBackground
        button.configuration = .borderless()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var targetLanguageButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = UIMenu(title: "번역어", children: [
            UIAction(title: "ko", handler: selectLanguageAction),
            UIAction(title: "en", state: .on, handler: selectLanguageAction),
            UIAction(title: "일본어", handler: selectLanguageAction),
            UIAction(title: "중국어 간체", handler: selectLanguageAction),
            UIAction(title: "중국어 번체", handler: selectLanguageAction)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.tintColor = .reversedBackground
        button.configuration = .borderless()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var selectLanguageAction = { (action: UIAction) in
        self.changeToSelectedLanguage(title: action.title)
    }
    
    private let changeLanguageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "change")
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setUpConstraints()
        addReverseLanguageGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(sourceLanguageButton)
        addSubview(targetLanguageButton)
        addSubview(changeLanguageView)
    }
    
    private func setUpConstraints() {
        setUpOriginalLanguageButtonConstraints()
        setUpTranslatedLanguageButtonConstraints()
        setUpChangeLanguageViewConstraints()
    }
    
    private func setUpOriginalLanguageButtonConstraints() {
        NSLayoutConstraint.activate([
            sourceLanguageButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            sourceLanguageButton.trailingAnchor.constraint(equalTo: changeLanguageView.leadingAnchor, constant: -30),
            sourceLanguageButton.centerYAnchor.constraint(equalTo: changeLanguageView.centerYAnchor)
        ])
    }
    
    private func setUpTranslatedLanguageButtonConstraints() {
        NSLayoutConstraint.activate([
            targetLanguageButton.leadingAnchor.constraint(equalTo: changeLanguageView.trailingAnchor),
            targetLanguageButton.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -30),
            targetLanguageButton.centerYAnchor.constraint(equalTo: changeLanguageView.centerYAnchor)
        ])
    }
    
    private func setUpChangeLanguageViewConstraints() {
        NSLayoutConstraint.activate([
            changeLanguageView.widthAnchor.constraint(equalToConstant: 20),
            changeLanguageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            changeLanguageView.topAnchor.constraint(equalTo: topAnchor),
            changeLanguageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Private
    private func changeToSelectedLanguage(title: String) {
        sourceLanguage = title
    }
    
    private func addReverseLanguageGesture() {
        changeLanguageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reverseLanguage)))
    }
    
    @objc
    private func reverseLanguage() {
        rotateButton()
        
        let tempLanguage = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = tempLanguage
        
        sourceLanguageButton.menu?.children.forEach({ action in
            guard let action = action as? UIAction else { return }
            
            if action.title == targetLanguage {
                action.state = .off
            } else if action.title == sourceLanguage {
                action.state = .on
            }
        })
        
        targetLanguageButton.menu?.children.forEach({ action in
            guard let action = action as? UIAction else { return }
            
            if action.title == sourceLanguage {
                action.state = .off
            } else if action.title == targetLanguage {
                action.state = .on
            }
        })
    }
    
    private func rotateButton() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 0.1
        animation.fromValue = 0
        animation.toValue = Double.pi * 200
        animation.repeatCount = 1
        changeLanguageView.layer.add(animation, forKey: "rotation")
    }
}

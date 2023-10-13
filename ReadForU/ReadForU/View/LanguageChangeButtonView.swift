//
//  LaunguageChangeButtonView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/13.
//

import UIKit

class LanguageChangeButtonView: UIView {
    private lazy var sourceLanguageButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = UIMenu(title: "원어", children: [
            UIAction(title: "한글", state: .on, handler: reverseLanguageAction),
            UIAction(title: "영어", handler: reverseLanguageAction),
            UIAction(title: "중국어", handler: reverseLanguageAction),
            UIAction(title: "일본어", handler: reverseLanguageAction)
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
            UIAction(title: "한글", handler: reverseLanguageAction),
            UIAction(title: "영어", state: .on, handler: reverseLanguageAction),
            UIAction(title: "중국어", handler: reverseLanguageAction),
            UIAction(title: "일본어", handler: reverseLanguageAction)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.tintColor = .reversedBackground
        button.configuration = .borderless()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var reverseLanguageAction = { (action: UIAction) in
        self.changeLanguage(title: action.title)
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
        addChangeLanguageGesture()
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
    private func changeLanguage(title: String) {
        print("\(title)로 바꾸겠습니다.")
    }
    
    private func addChangeLanguageGesture() {
        changeLanguageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reverseLanguage)))
    }
    
    @objc
    private func reverseLanguage() {
        rotateButton()
        
        print("언어를 교환합니다.")
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

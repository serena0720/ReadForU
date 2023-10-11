//
//  MainView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/10.
//

import UIKit

final class MainView: UIView {
    private lazy var originalLanguageButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = UIMenu(title: "원어", children: [
            UIAction(title: "한글", state: .on, handler: languageAction),
            UIAction(title: "영어", handler: languageAction),
            UIAction(title: "중국어", handler: languageAction),
            UIAction(title: "일본어", handler: languageAction)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var translatedLanguageButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = UIMenu(title: "번역어", children: [
            UIAction(title: "한글", handler: languageAction),
            UIAction(title: "영어", state: .on, handler: languageAction),
            UIAction(title: "중국어", handler: languageAction),
            UIAction(title: "일본어", handler: languageAction)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var languageAction = { (action: UIAction) in
        self.changeLanguage(title: action.title)
    }
    
    private let changeLanguageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "change")
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpBackgroundColor()
        configureUI()
        setUpButtonStackViewConstraints()
        addChangeLanguageGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
    private func configureUI() {
        addSubview(buttonStackView)
        
        [originalLanguageButton, changeLanguageView, translatedLanguageButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    // MARK: - Constraints
    private func setUpButtonStackViewConstraints() {
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            buttonStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            buttonStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            
            changeLanguageView.widthAnchor.constraint(equalTo: buttonStackView.heightAnchor, multiplier: 0.5),
            changeLanguageView.heightAnchor.constraint(equalTo: changeLanguageView.widthAnchor, multiplier: 1)
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

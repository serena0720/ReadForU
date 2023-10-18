//
//  LanguageChangeButtonView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/13.
//

import UIKit

final class LanguageChangeButtonView: UIView {
    private lazy var sourceLanguageButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = UIMenu(title: "원어", children: [
            UIAction(title: Language.korean.inKorean,
                     image: UIImage(named: Language.korean.code),
                     state: .on,
                     handler: selectSourceLanguageAction),
            UIAction(title: Language.english.inKorean,
                     image: UIImage(named: Language.english.code),
                     handler: selectSourceLanguageAction),
            UIAction(title: Language.japanese.inKorean, 
                     image: UIImage(named: Language.japanese.code),
                     handler: selectSourceLanguageAction),
            UIAction(title: Language.chinese.inKorean, 
                     image: UIImage(named: Language.chinese.code),
                     handler: selectSourceLanguageAction),
            UIAction(title: Language.traditionalChineseCharacters.inKorean, 
                     image: UIImage(named: Language.traditionalChineseCharacters.code),
                     handler: selectSourceLanguageAction)
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
            UIAction(title: Language.korean.inKorean,
                     image: UIImage(named: Language.korean.code),
                     handler: selectTargetLanguageAction),
            UIAction(title: Language.english.inKorean,
                     image: UIImage(named: Language.english.code),
                     state: .on,
                     handler: selectTargetLanguageAction),
            UIAction(title: Language.japanese.inKorean,
                     image: UIImage(named: Language.japanese.code),
                     handler: selectTargetLanguageAction),
            UIAction(title: Language.chinese.inKorean,
                     image: UIImage(named: Language.chinese.code),
                     handler: selectTargetLanguageAction),
            UIAction(title: Language.traditionalChineseCharacters.inKorean,
                     image: UIImage(named: Language.traditionalChineseCharacters.code),
                     handler: selectTargetLanguageAction)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.tintColor = .reversedBackground
        button.configuration = .borderless()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var selectSourceLanguageAction = { [weak self] (action: UIAction) in
        guard let self else { return }
        
        self.changeToSelectedLanguage(title: action.title, languageType: LanguageInfo.shared.source)
    }
    
    private lazy var selectTargetLanguageAction = { [weak self] (action: UIAction) in
        guard let self else { return }
        
        self.changeToSelectedLanguage(title: action.title, languageType: LanguageInfo.shared.target)
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
        
        checkLanguage()
        configureUI()
        setUpConstraints()
        addReverseLanguageGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkLanguage() {
        sourceLanguageButton.menu?.children.forEach({ action in
            guard let action = action as? UIAction else { return }
            
            if action.title == LanguageInfo.shared.source.inKorean {
                action.state = .on
            } else {
                action.state = .off
            }
        })
        
        targetLanguageButton.menu?.children.forEach({ action in
            guard let action = action as? UIAction else { return }
            
            if action.title == LanguageInfo.shared.target.inKorean {
                action.state = .on
            } else {
                action.state = .off
            }
        })
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
    private func changeToSelectedLanguage(title: String, languageType: Language) {
        if languageType == LanguageInfo.shared.source {
            LanguageInfo.shared.source = Language(text: title)
        } else {
            LanguageInfo.shared.target = Language(text: title)
        }
        print("타이틀\(title) 원어 \(LanguageInfo.shared.source.code) 번어 \(LanguageInfo.shared.target.code))")
    }
    
    private func addReverseLanguageGesture() {
        changeLanguageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reverseLanguage)))
    }
    
    @objc
    private func reverseLanguage() {
        rotateButton()
        
        if LanguageInfo.shared.source != LanguageInfo.shared.target {
            let tempLanguage = LanguageInfo.shared.source
            LanguageInfo.shared.source = LanguageInfo.shared.target
            LanguageInfo.shared.target = tempLanguage
            
            sourceLanguageButton.menu?.children.forEach({ action in
                guard let action = action as? UIAction else { return }
                
                if action.title == LanguageInfo.shared.target.inKorean {
                    action.state = .off
                } else if action.title == LanguageInfo.shared.source.inKorean {
                    action.state = .on
                }
            })
            
            targetLanguageButton.menu?.children.forEach({ action in
                guard let action = action as? UIAction else { return }
                
                if action.title == LanguageInfo.shared.source.inKorean {
                    action.state = .off
                } else if action.title == LanguageInfo.shared.target.inKorean {
                    action.state = .on
                }
            })
        }
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

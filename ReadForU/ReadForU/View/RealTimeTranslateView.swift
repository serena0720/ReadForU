//
//  RealTimeTranslateView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit

final class RealTimeTranslateView: UIView {
    private lazy var originalLanguageButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = UIMenu(title: "원어", children: [
            UIAction(title: "한글", state: .on, handler: reverseLanguageAction),
            UIAction(title: "영어", handler: reverseLanguageAction),
            UIAction(title: "중국어", handler: reverseLanguageAction),
            UIAction(title: "일본어", handler: reverseLanguageAction)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var translatedLanguageButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.menu = UIMenu(title: "번역어", children: [
            UIAction(title: "한글", handler: reverseLanguageAction),
            UIAction(title: "영어", state: .on, handler: reverseLanguageAction),
            UIAction(title: "중국어", handler: reverseLanguageAction),
            UIAction(title: "일본어", handler: reverseLanguageAction)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var reverseLanguageAction = { (action: UIAction) in
        self.changeLanguage(title: action.title)
    }
    
    private let changeLanguageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "change")
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let languageButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightPinkGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let scannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpBackgroundColor()
        configureUI()
        setUpLanguageButtonStackViewConstraints()
        setUpSeparatorViewConstraints()
        setUpScannerViewConstraints()
        addChangeLanguageGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
    private func configureUI() {
        addSubview(languageButtonStackView)
        addSubview(separatorView)
        addSubview(scannerView)
        
        [originalLanguageButton, changeLanguageView, translatedLanguageButton].forEach {
            languageButtonStackView.addArrangedSubview($0)
        }
    }
    
    // MARK: - Constraints
    private func setUpLanguageButtonStackViewConstraints() {
        NSLayoutConstraint.activate([
            languageButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            languageButtonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            languageButtonStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            languageButtonStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            
            changeLanguageView.widthAnchor.constraint(equalTo: languageButtonStackView.heightAnchor, multiplier: 0.5),
            changeLanguageView.heightAnchor.constraint(equalTo: changeLanguageView.widthAnchor, multiplier: 1)
        ])
    }
    
    private func setUpSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: languageButtonStackView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setUpScannerViewConstraints() {
        NSLayoutConstraint.activate([
            scannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scannerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scannerView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            scannerView.bottomAnchor.constraint(equalTo: bottomAnchor)
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

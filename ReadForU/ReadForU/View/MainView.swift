//
//  MainView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/10.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func showBasicTranslateViewController()
    func showRealTimeTranslateViewController()
}

final class MainView: UIView {
    weak var delegate: MainViewDelegate?
    
    // TODO: View마다 곂치는 요소 고민해보기
    private let buttonView: LanguageChangeButtonView = {
        let view = LanguageChangeButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var basicTranslateButton: UIButton = {
        let button = UIButton(primaryAction: basicTranslateAction)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .systemBackground
        
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightPinkGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var basicTranslateAction = UIAction(title: "번역할 내용을 입력하세요.") { _ in
        self.delegate?.showBasicTranslateViewController()
    }
    
    private lazy var realTimeTranslateButton: UIButton = {
        let button = UIButton(primaryAction: realTimeTranslateAction)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .lightPinkGrey
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return button
    }()
    
    private lazy var realTimeTranslateAction = UIAction(title: "실시간 번역") { _ in
        self.delegate?.showRealTimeTranslateViewController()
    }
    
    private lazy var captureTranslateButton: UIButton = {
        let button = UIButton(primaryAction: captureTranslateAction)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .lightPink
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return button
    }()
    
    private let captureTranslateAction = UIAction(title: "캡쳐 번역") { _ in
        print("TODO: 캡쳐 번역 구현하기")
    }
    
    private let translateButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpBackgroundColor()
        configureUI()
        setUpButtonViewConstraints()
        setUpSeparatorViewConstraints()
        setUpTranslateButtonStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
    private func configureUI() {
        addSubview(buttonView)
        addSubview(separatorView)
        addSubview(translateButtonStackView)
        
        [basicTranslateButton, realTimeTranslateButton, captureTranslateButton].forEach {
            translateButtonStackView.addArrangedSubview($0)
        }
    }
    
    // MARK: - Constraints
    private func setUpButtonViewConstraints() {
        NSLayoutConstraint.activate([
            buttonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            buttonView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func setUpSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: buttonView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setUpTranslateButtonStackViewConstraints() {
        NSLayoutConstraint.activate([
            translateButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            translateButtonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            translateButtonStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            translateButtonStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            basicTranslateButton.heightAnchor.constraint(equalTo: translateButtonStackView.heightAnchor, multiplier: 0.6),
            basicTranslateButton.widthAnchor.constraint(equalTo: translateButtonStackView.widthAnchor, multiplier: 1),
            realTimeTranslateButton.heightAnchor.constraint(equalTo: translateButtonStackView.heightAnchor, multiplier: 0.2),
            realTimeTranslateButton.widthAnchor.constraint(equalTo: translateButtonStackView.widthAnchor, multiplier: 1),
            captureTranslateButton.heightAnchor.constraint(equalTo: translateButtonStackView.heightAnchor, multiplier: 0.2),
            captureTranslateButton.widthAnchor.constraint(equalTo: translateButtonStackView.widthAnchor, multiplier: 1)
        ])
    }
}

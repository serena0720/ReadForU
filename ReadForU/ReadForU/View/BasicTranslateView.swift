//
//  BasicTranslateView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit

final class BasicTranslateView: UIView {
    let buttonView: LanguageChangeButtonView = {
        let view = LanguageChangeButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightPinkGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var sourceLanguageTextField: UITextView = {
        let textView = UITextView()
        textView.text = "번역할 내용을 입력하세요."
        textView.textColor = .lightGray
        textView.tintColor = .mainPink
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        
        return textView
    }()
    
    private let separatorLanguageView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightPinkGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let targetLanguageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .reversedBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpBackgroundColor()
        configureUI()
        setUpButtonViewConstraints()
        setUpSeparatorViewConstraints()
        setUpSourceLanguageTextFieldConstraints()
        setUpSeparatorLanguageViewConstraints()
        setUpTargetLanguageLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
    private func configureUI() {
        [buttonView, separatorView, sourceLanguageTextField, separatorLanguageView, targetLanguageLabel].forEach {
            addSubview( $0 )
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
    
    private func setUpSourceLanguageTextFieldConstraints() {
        NSLayoutConstraint.activate([
            sourceLanguageTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sourceLanguageTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sourceLanguageTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            sourceLanguageTextField.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)
        ])
    }
    
    private func setUpSeparatorLanguageViewConstraints() {
        NSLayoutConstraint.activate([
            separatorLanguageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLanguageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLanguageView.topAnchor.constraint(equalTo: sourceLanguageTextField.bottomAnchor),
            separatorLanguageView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setUpTargetLanguageLabelConstraints() {
        NSLayoutConstraint.activate([
            targetLanguageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            targetLanguageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            targetLanguageLabel.topAnchor.constraint(equalTo: separatorLanguageView.bottomAnchor),
            targetLanguageLabel.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        ])
    }
}

extension BasicTranslateView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            if textView.text == "번역할 내용을 입력하세요." {
                textView.text = nil
                textView.textColor = .reversedBackground
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                textView.text = "번역할 내용을 입력하세요."
                textView.textColor = .lightGray
            }
        }
    }
}

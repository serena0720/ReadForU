//
//  BasicTranslateView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit

final class BasicTranslateView: UIView {
    private let buttonView: LaunguageChangeButtonView = {
        let view = LaunguageChangeButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightPinkGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpBackgroundColor()
        configureUI()
        setUpButtonViewConstraints()
        setUpSeparatorViewConstraints()
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
    }}

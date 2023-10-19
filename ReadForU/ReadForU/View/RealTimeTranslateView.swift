//
//  RealTimeTranslateView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit

protocol RealTimeTranslateViewDelegate: AnyObject {
    func togglePauseAndRunButton()
    func toggleBackLightButton()
}

final class RealTimeTranslateView: UIView {
    weak var delegate: RealTimeTranslateViewDelegate?
    
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
    
    let scannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let pauseAndRunView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pause")
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let backLightView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lightbulb.circle")
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpBackgroundColor()
        configureUI()
        setUpButtonViewConstraints()
        setUpSeparatorViewConstraints()
        setUpScannerViewConstraints()
        setUpPauseAndRunViewConstraints()
        setUpBackLightViewConstraints()
        addPauseAndRunViewGesture()
        addBackLightViewGesture()
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
        addSubview(scannerView)
        addSubview(pauseAndRunView)
        addSubview(backLightView)
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
    
    private func setUpScannerViewConstraints() {
        NSLayoutConstraint.activate([
            scannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scannerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scannerView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            scannerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpPauseAndRunViewConstraints() {
        NSLayoutConstraint.activate([
            pauseAndRunView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pauseAndRunView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pauseAndRunView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.12),
            pauseAndRunView.heightAnchor.constraint(equalTo: pauseAndRunView.widthAnchor, multiplier: 1)
        ])
    }
    
    private func setUpBackLightViewConstraints() {
        NSLayoutConstraint.activate([
            backLightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            backLightView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backLightView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.12),
            backLightView.heightAnchor.constraint(equalTo: backLightView.widthAnchor, multiplier: 1)
        ])
    }
    
    // MARK: - Private
    private func addPauseAndRunViewGesture() {
        pauseAndRunView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedPauseAndRun)))
    }
    
    private func addBackLightViewGesture() {
        backLightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedBackLight)))
    }
    
    @objc
    private func didTappedPauseAndRun() {
        scalePauseAndRunButton()
        
        delegate?.togglePauseAndRunButton()
    }
    
    @objc
    private func didTappedBackLight() {
        scaleBackLight()
        
        delegate?.toggleBackLightButton()
    }
    
    private func scalePauseAndRunButton() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.1
        animation.fromValue = 0.5
        animation.repeatCount = 1
        pauseAndRunView.layer.add(animation, forKey: "scale")
    }
    
    private func scaleBackLight() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.1
        animation.fromValue = 0.5
        animation.repeatCount = 1
        backLightView.layer.add(animation, forKey: "scale")
    }
}

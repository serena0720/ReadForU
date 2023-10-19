//
//  LoadingView.swift
//  ReadForU
//
//  Created by Serena on 2023/10/10.
//

import UIKit
import Gifu

final class LoadingView: UIView {
//    private lazy var gifImageView = GIFImageView(frame: CGRect(x: 0,
//                                                               y: 0,
//                                                               width: self.frame.size.width,
//                                                               height: self.frame.size.height))
    private let gifImageView: GIFImageView = {
        let image = GIFImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpBackgroundColor()
        configureUI()
        setUpGifImage()
        animateGifImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
    private func configureUI() {
        addSubview(gifImageView)
    }
    
    // MARK: - Constraints
    private func setUpGifImage() {
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Private
    private func animateGifImage() {
        gifImageView.animate(withGIFNamed: "ReadForU",
                             loopCount: 1,
                             loopBlock: {
            NotificationCenter.default.post(name: NSNotification.Name("isGifDone"),
                                            object: nil)
        })
    }
}

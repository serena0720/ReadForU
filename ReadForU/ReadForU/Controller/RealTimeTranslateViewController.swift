//
//  RealTimeTranslateViewController.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit
import VisionKit
import AVFoundation

final class RealTimeTranslateViewController: UIViewController {
    private let translateService = TranslateService()
    
    private let dataScanner = DataScannerViewController(recognizedDataTypes: [.text()],
                                                        qualityLevel: .fast,
                                                        recognizesMultipleItems: true,
                                                        isHighFrameRateTrackingEnabled: true,
                                                        isPinchToZoomEnabled: true,
                                                        isGuidanceEnabled: true,
                                                        isHighlightingEnabled: true)
    
    private let realTimeView = RealTimeTranslateView(frame: .zero)
    
    private var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }
    
    private var isRunning: Bool = true
    private var isTimeToRequest: Bool = true
    
    private var tempView: [UIView] = []
    
    private var timer: Timer?
    
    override func loadView() {
        view = realTimeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController()
        startTimer()
        assignRealTimeTranslateViewDelegate()
        assignDataScannerDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if scannerAvailable {
            startDataScanner()
        } else {
            print("현재 디바이스는 지원 불가합니다.")
        }
    }
    
    // MARK: - Private
    private func addChildViewController() {
        addChild(dataScanner)
        dataScanner.didMove(toParent: self)
        realTimeView.scannerView.addSubview(dataScanner.view)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(notifyRequestTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func startDataScanner() {
        dataScanner.view.frame = realTimeView.scannerView.bounds
        try? dataScanner.startScanning()
    }
    
    @objc
    private func notifyRequestTime() {
        isTimeToRequest = true
    }
}

// MARK: - Delegate
extension RealTimeTranslateViewController: RealTimeTranslateViewDelegate {
    private func assignRealTimeTranslateViewDelegate() {
        realTimeView.delegate = self
    }
    
    func togglePauseAndRunButton() {
        if isRunning {
            isRunning = false
            realTimeView.pauseAndRunView.image = .init(named: "run")
            dataScanner.stopScanning()
            tempView.forEach {
                $0.removeFromSuperview()
            }
        } else {
            isRunning = true
            realTimeView.pauseAndRunView.image = .init(named: "pause")
            try? dataScanner.startScanning()
        }
    }
    
    func toggleBackLightButton() {
        // TODO: - DataScannerViewController와 AVCaptureDevice충돌로 인하여 backflash 작동 시 화면이 멈추는 문제
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            DispatchQueue.main.async { [self] in
                do {
                    try device.lockForConfiguration()
                    if device.torchMode == AVCaptureDevice.TorchMode.on {
                        self.realTimeView.backLightView.image = .init(systemName: "lightbulb.circle")
                        device.torchMode = AVCaptureDevice.TorchMode.off
                    } else {
                        do {
                            realTimeView.backLightView.image = .init(systemName: "lightbulb.circle.fill")
                            try device.setTorchModeOn(level: 1.0)
                        } catch {
                            print(error)
                        }
                    }
                    device.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension RealTimeTranslateViewController: DataScannerViewControllerDelegate {
    private func assignDataScannerDelegate() {
        dataScanner.delegate = self
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController,
                     didAdd addedItems: [RecognizedItem],
                     allItems: [RecognizedItem]) {
        if isTimeToRequest {
            tempView.forEach {
                $0.removeFromSuperview()
            }
            allItems.forEach { item in
                switch item {
                case .text(let text):
                    let bounds = item.bounds
                    let scannerY = self.realTimeView.scannerView.frame.origin.y
                    let textInset: Double = 20
                    let textButton = UIButton()
                    
                    textButton.titleLabel?.numberOfLines = 0
                    textButton.titleLabel?.adjustsFontSizeToFitWidth = true
                    textButton.titleLabel?.textAlignment = .center
                    textButton.addTarget(self, action: #selector(pasteText(_:)), for: .touchUpInside)
                    
                    let blur = UIBlurEffect(style: .regular)
                    let visualEffectView = UIVisualEffectView(effect: blur)
                    let vibrancyEffect = UIVibrancyEffect(blurEffect: blur)
                    let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
                    
                    visualEffectView.frame = CGRect(x: bounds.topLeft.x - textInset/2,
                                                    y: scannerY + bounds.topLeft.y - textInset/2,
                                                    width: bounds.topRight.x - bounds.topLeft.x + textInset,
                                                    height: bounds.bottomLeft.y - bounds.topLeft.y + textInset)
                    textButton.frame = visualEffectView.bounds
                    vibrancyEffectView.frame = visualEffectView.bounds
                    
                    vibrancyEffectView.contentView.addSubview(textButton)
                    visualEffectView.contentView.addSubview(vibrancyEffectView)
                    view.addSubview(visualEffectView)
                    
                    tempView.append(visualEffectView)
                    
                    let textContent = text.transcript
                    translateService.postRequest(source: LanguageInfo.shared.source.code,
                                                 target: LanguageInfo.shared.target.code,
                                                 text: textContent) { result in
                        print("원어\(LanguageInfo.shared.source.code) 번역어\(LanguageInfo.shared.target.code) 내용 \(result.message.result.translatedText)")
                        DispatchQueue.main.async {
                            let result = result.message.result.translatedText
                            textButton.setTitle(result, for: .normal)
                        }
                    }
                    
                    showToast(message: "터치 시 내용이 복사됩니다.", font: .preferredFont(forTextStyle: .body))
                    
                    isTimeToRequest = false
                case .barcode(let code):
                    print("코드 : \(code)")
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Private
    @objc
    private func pasteText(_ sender: UIButton) {
        UIPasteboard.general.string = sender.titleLabel?.text
        showToast(message: "클립보드에 복사되었습니다.", font: .preferredFont(forTextStyle: .body))
    }
    
    private func showToast(message: String, font: UIFont) {
        let toastLabel = PaddingLabel()
        
        toastLabel.backgroundColor = .mainPink
        toastLabel.textColor = .white
        toastLabel.font = font
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4
        toastLabel.clipsToBounds = true
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: realTimeView.pauseAndRunView.topAnchor, constant: -20)
        ])
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

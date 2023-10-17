//
//  RealTimeTranslateViewController.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit
import VisionKit
import AVFoundation

final class RealTimeTranslateViewController: UIViewController, AlertControllerShowable {
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
        
        realTimeView.buttonView.checkLanguage()
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
            refuseAdmission()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
    
    // MARK: - Private
    private func addChildViewController() {
        addChild(dataScanner)
        dataScanner.didMove(toParent: self)
        realTimeView.scannerView.addSubview(dataScanner.view)
        
        dataScanner.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataScanner.view.leadingAnchor.constraint(equalTo: realTimeView.scannerView.leadingAnchor),
            dataScanner.view.trailingAnchor.constraint(equalTo: realTimeView.scannerView.trailingAnchor),
            dataScanner.view.topAnchor.constraint(equalTo: realTimeView.scannerView.topAnchor),
            dataScanner.view.bottomAnchor.constraint(equalTo: realTimeView.scannerView.bottomAnchor)
        ])
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
    
    private func refuseAdmission() {
        let cancel = UIAlertAction(title: "뒤돌아가기", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        guard presentedViewController != nil else {
            return showAlertController(title: "미지원 기기", message: "실시간 번역 지원 가능 기기가 아닙니다.", style: .alert, actions: [cancel])
        }
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
            isTimeToRequest = false
            realTimeView.pauseAndRunView.image = .init(named: "run")
            dataScanner.stopScanning()
            tempView.forEach {
                $0.removeFromSuperview()
            }
        } else {
            isRunning = true
            isTimeToRequest = true
            realTimeView.pauseAndRunView.image = .init(named: "pause")
            try? dataScanner.startScanning()
        }
    }
    
    func toggleBackLightButton() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            DispatchQueue.main.async {
                try? device.lockForConfiguration()
                
                if device.torchMode == AVCaptureDevice.TorchMode.on {
                    self.realTimeView.backLightView.image = .init(systemName: "lightbulb.circle")
                    device.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    self.realTimeView.backLightView.image = .init(systemName: "lightbulb.circle.fill")
                    try? device.setTorchModeOn(level: 1.0)
                }
                device.unlockForConfiguration()
            }
        }
    }
}

extension RealTimeTranslateViewController: DataScannerViewControllerDelegate {
    private func assignDataScannerDelegate() {
        dataScanner.delegate = self
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        if isTimeToRequest {
            tempView.forEach {
                $0.removeFromSuperview()
            }
            
            allItems.forEach { item in
                switch item {
                case .text(let text):
                    let textButton = makeTranslateTextButton()
                    
                    setUpTranslateTextButton(item: item, button: textButton)
                    
                    translateService.postPapagoRequest(source: LanguageInfo.shared.source.code,
                                                       target: LanguageInfo.shared.target.code,
                                                       text: text.transcript) { result in
                        DispatchQueue.main.async {
                            self.inputTextInTranslateButton(result: result, button: textButton)
                        }
                    }
                    showToast(message: "터치 시 내용이 복사됩니다.", font: .preferredFont(forTextStyle: .body))
                    
                    isTimeToRequest = false
                case .barcode:
                    showToast(message: "지원하지 않는 코드입니다.", font: .preferredFont(forTextStyle: .body))
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
    
    private func makeTranslateTextButton() -> UIButton {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(pasteText(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func setUpTranslateTextButton(item: RecognizedItem, button: UIButton) {
        let bounds = item.bounds
        let scannerY = realTimeView.scannerView.frame.origin.y
        let textInset: Double = 20
        let blur = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blur)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blur)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        
        visualEffectView.frame = CGRect(x: bounds.topLeft.x - textInset/2,
                                        y: scannerY + bounds.topLeft.y - textInset/2,
                                        width: bounds.topRight.x - bounds.topLeft.x + textInset,
                                        height: bounds.bottomLeft.y - bounds.topLeft.y + textInset)
        button.frame = visualEffectView.bounds
        vibrancyEffectView.frame = visualEffectView.bounds
        
        vibrancyEffectView.contentView.addSubview(button)
        visualEffectView.contentView.addSubview(vibrancyEffectView)
        view.addSubview(visualEffectView)
        tempView.append(visualEffectView)
    }
    
    private func inputTextInTranslateButton(result: Result<PapagoTranslate, APIError>, button: UIButton) {
        switch result {
        case .success(let result):
            let result = result.message.result.translatedText
            
            button.setTitle(result, for: .normal)
        case .failure:
            DispatchQueue.main.async {
                let cancel = UIAlertAction(title: "뒤돌아가기", style: .cancel) { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }
                guard self.presentedViewController != nil else {
                    return self.showAlertController(title: "네트워크 오류", message: "네트워크 문제가 발생하였습니다.", style: .alert, actions: [cancel])
                }
            }
        }
    }
}

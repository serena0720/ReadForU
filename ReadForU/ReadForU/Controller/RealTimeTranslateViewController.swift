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
    
    override func viewWillDisappear(_ animated: Bool) {
        dataScanner.stopScanning()
        dataScanner.dismiss(animated: true)
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
                    let textLabel = UILabel()
                    
                    textLabel.numberOfLines = 0
                    textLabel.adjustsFontSizeToFitWidth = true
                    textLabel.textAlignment = .center
                    
                    let blur = UIBlurEffect(style: .regular)
                    let visualEffectView = UIVisualEffectView(effect: blur)
                    let vibrancyEffect = UIVibrancyEffect(blurEffect: blur)
                    let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
                    
                    visualEffectView.frame = CGRect(x: bounds.topLeft.x - textInset/2,
                                                    y: scannerY + bounds.topLeft.y - textInset/2,
                                                    width: bounds.topRight.x - bounds.topLeft.x + textInset,
                                                    height: bounds.bottomLeft.y - bounds.topLeft.y + textInset)
                    textLabel.frame = visualEffectView.bounds
                    vibrancyEffectView.frame = visualEffectView.bounds
                    
                    vibrancyEffectView.contentView.addSubview(textLabel)
                    visualEffectView.contentView.addSubview(vibrancyEffectView)
                    view.addSubview(visualEffectView)
                    
                    tempView.append(visualEffectView)
                    
                    let textContent = text.transcript
                    translateService.postRequset(source: realTimeView.buttonView.sourceLanguage.code,
                                                 target: realTimeView.buttonView.targetLanguage.code,
                                                 text: textContent) { result in
                        DispatchQueue.main.async {
                            textLabel.text = result.message.result.translatedText
                        }
                    }
                    
                    isTimeToRequest = false
                case .barcode(let code):
                    print("코드 : \(code)")
                default:
                    break
                }
            }
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let text):
            // TODO: - 복사 붙여넣기 기능 구현
            UIPasteboard.general.string = text.transcript
            print(text.transcript)
        case .barcode(let code):
            print("코드 : \(code)")
        default:
            break
        }
    }
}

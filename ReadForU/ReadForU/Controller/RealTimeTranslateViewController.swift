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
    private let scannerVC = DataScannerViewController(recognizedDataTypes: [.text()],
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
    
    override func loadView() {
        view = realTimeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController()
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
        addChild(scannerVC)
        scannerVC.didMove(toParent: self)
        realTimeView.scannerView.addSubview(scannerVC.view)
    }
    
    private func startDataScanner() {
        scannerVC.view.frame = realTimeView.scannerView.bounds
        try? scannerVC.startScanning()
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
            scannerVC.stopScanning()
        } else {
            isRunning = true
            realTimeView.pauseAndRunView.image = .init(named: "pause")
            try? scannerVC.startScanning()
        }
    }
    
    func toggleBackLightButton() {
        // TODO: - DataScannerViewController와 AVCaptureDevice충돌로 인하여 backflash 작동 시 화면이 멈추는 문제
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            DispatchQueue.main.async {
                do {
                    try device.lockForConfiguration()
                    if device.torchMode == AVCaptureDevice.TorchMode.on {
                        device.torchMode = AVCaptureDevice.TorchMode.off
                    } else {
                        do {
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
        scannerVC.delegate = self
    }
}

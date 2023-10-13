//
//  RealTimeTranslateViewController.swift
//  ReadForU
//
//  Created by Serena on 2023/10/11.
//

import UIKit
import VisionKit

final class RealTimeTranslateViewController: UIViewController {
    private let scannerVC = DataScannerViewController(recognizedDataTypes: [.text()],
                                                      qualityLevel: .fast,
                                                      recognizesMultipleItems: true, 
                                                      isHighFrameRateTrackingEnabled: true,
                                                      isPinchToZoomEnabled: true,
                                                      isGuidanceEnabled: true,
                                                      isHighlightingEnabled: true)
    
    private let realTimeView = RealTimeTranslateView(frame: .zero)
    
    override func loadView() {
        view = realTimeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startDataScanner()
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

//
//  ScannerProcessor.swift
//  CortexScanner
//
//  Created by Yury Ramazanov on 10.06.2020.
//  Copyright © 2020 Yury Ramazanov. All rights reserved.
//

import Foundation

enum ScannerError: LocalizedError {
    
    case liciense(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .liciense(let message): return message
        }
    }
}

protocol ScannerProcessorProtocol: class {
    
    func onCodeDecoded(with result: String)
    func scannerFailed(with error: Error)
}

class ScannerProcessor: NSObject {

    private let config = ["customerID" : "SWI090520190001",
                          "configurationKey" : "dITJSoNavvjJ80Ba0tr8zisy5ztx+fi9CzWBNXvo8BT+a7x8EhGnBzKaRuGtTm/XVaLpvM3Yva8pKtJ8wL3OOPIIHW00t0+Oj78bWGAKHCN+KndlW8UmWK4uWrCA91UevBULUcUg9yKMiHWuQ8skwDGjV40gDDw+vZAgYq0/kmNwzCFhe3HF9EAh6I5dJ7+h2cLTDyzGEUX4BzlXpYo3qDWxuhGw3Mlfp8CmUkSBRvEyzmbmNEDtj2eZPTEn2uqtJ2yW81TpR42dYUdhAnl8Uv0YGVmNilQ6a8G5kQG5u5qtrvQJxiPMngo/nsZKEX1iEFMBBoiN7UgKutgguiCZ/wXzBndyTC1NYipMZpTKTjmmeRCixsy7qf36awAE417Xq8kyXezt1ObiUI3uf+NrTA=="]
    
    weak var delegate: ScannerProcessorProtocol?
    
    let decoder: ScanResultDecoder
    
    lazy var scanner: CortexDecoderLibrary = {
        
        let cortex = CortexDecoderLibrary.sharedObject()!
        cortex.delegate = self
        return cortex
    }()
    
    init(decoder: ScanResultDecoder) {
        
        self.decoder = decoder
        super.init()
    }
    
    func getCameraPreview(for rect: CGRect) -> UIView {
        
        return self.scanner.previewView(withFrame: rect)
    }
    
    func start() {
        
        self.configureScanner()
        self.startScanner()
    }
    
    func stop() {
        
        self.stopScanner()
    }
    
    private func configureScanner() {
        
        self.scanner.setCameraType(CD_CameraType_BackFacing)
        self.scanner.setTorch(CD_Torch_Auto)
        self.scanner.setTorchBrightness(1.0)
        self.scanner.setDecoderResolution(CD_Resolution_1280x720)
        self.scanner.setFocus(CD_Focus_Smooth_Auto)
        self.scanner.setNumberOfDecodes(1)
        self.scanner.lowContrastDecodingEnabled(true)
        self.scanner.enableVibrate(onScan: true)
        self.scanner.enableBeepPlayer(true)
        self.scanner.matchDecodeCountExactly(true)
        self.scanner.setDecoderToleranceLevel(10)
        self.scanner.ensureRegion(ofInterest: false)
        self.scanner.resetTestDataForFrame()
        self.scanner.enableMultiFrameDecoding(false)
    }
    
    private func startScanner() {

        DispatchQueue.global(qos: .default).async {
            self.scanner.enableVideoCapture(true)
            self.scanner.enableDecoding(true)
        }
    }
    
    private func stopScanner() {
        
        DispatchQueue.global(qos: .default).async {
            self.scanner.enableDecoding(false)
            self.scanner.enableVideoCapture(false)
        }
    }
}

extension ScannerProcessor: CortexDecoderLibraryDelegate {
    
    func receivedMultiDecodedData(_ data: [Any]!, andType type: [Any]!) {
        
        let data = data.first as! Data
        let type = CD_SymbologyType(rawValue: type.first as! UInt32)
        self.receivedDecodedData(data, andType: type)
    }
    
    func receivedDecodedData(_ data: Data!, andType type: CD_SymbologyType) {
        
        let result = self.decoder.decode(data)
        self.delegate?.onCodeDecoded(with: result)
    }
    
    func configurationKeyData(_ requestedData: String!) -> String! {
    
        return self.config[requestedData]
    }
    
    func receivedConfigFileActivationResult(_ licenseActivated: Bool) {
        
        if licenseActivated {
            self.start()
        } else {
            self.stop();
        }
    }
    
    func receivedConfigFileError(_ error: String!) {
        
        self.delegate?.scannerFailed(with: ScannerError.liciense(message: error))
    }
}

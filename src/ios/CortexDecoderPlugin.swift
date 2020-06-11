//
//  CortexDecoderPlugin.swift
//  CortexScanner
//
//  Created by Yury Ramazanov on 11.06.2020.
//  Copyright © 2020 Yury Ramazanov. All rights reserved.
//

import Foundation

@objc(CortexDecoderPlugin) class CortexDecoderPlugin : CDVPlugin {
    
    var scannerController: ScanViewController?
    var callbackId: String?
    
    @objc(startScanner:)
    func startScanner(command: CDVInvokedUrlCommand) {
        
        callbackId = command.callbackId;
        
        let scanner = ScannerProcessor(decoder: DefaultDecoder())
        scanner.delegate = self
        scannerController = ScanViewController(with: scanner)
        self.viewController.present(scannerController!, animated: true, completion: nil)
    }
    
    @objc(stopScanner:)
    func stopScanner(command: CDVInvokedUrlCommand) {
        
        let callbackId = command.callbackId
        
        guard let scanner = scannerController else {
            
            let errorResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Scanner is not running.");
            self.commandDelegate!.send(errorResult, callbackId: callbackId);
            return
        }
        
        scanner.dismiss(animated: true, completion: {
            
            let successResult = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate!.send(successResult, callbackId: callbackId);
        })
    }
}

extension CortexDecoderPlugin: ScannerProcessorProtocol {
    
    func onCodeDecoded(with result: String) {
        scannerController?.lblResult.text = result
        
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result);
        self.commandDelegate!.send(pluginResult, callbackId: callbackId);
    }
    
    func scannerFailed(with error: Error) {
        let errorString = error.localizedDescription
        scannerController?.lblResult.text = errorString
        
        let pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: errorString);
        self.commandDelegate!.send(pluginResult, callbackId: callbackId);
    }
}

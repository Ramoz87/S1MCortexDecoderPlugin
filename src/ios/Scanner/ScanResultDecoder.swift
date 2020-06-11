//
//  ScanResultDecoder.swift
//  Ethistock New
//
//  Created by Yury Ramazanov on 03/09/2019.
//  Copyright © 2019 Swiss1mobile. All rights reserved.
//

import Foundation

protocol ScanResultDecoder {
    func decode(_ data: Data) -> String
}

struct DefaultDecoder: ScanResultDecoder {
    
    func decode(_ data: Data) -> String {
        
        guard let result = String(data: data, encoding: .utf8) else { return "" }
        return result
    }
}

//
//  ScanViewController.swift
//  Ethistock New
//
//  Created by Yury Ramazanov on 29/05/2019.
//  Copyright © 2019 Swiss1mobile. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {

    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var lblResult: UILabel!
    
    let scanner: ScannerProcessor
    
    init(with scanner: ScannerProcessor) {
        
        self.scanner = scanner;
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            let preview = self.scanner.getCameraPreview(for: self.cameraPreview.bounds)
            self.cameraPreview.addSubview(preview)
            
            preview.translatesAutoresizingMaskIntoConstraints = false;
            preview.leftAnchor.constraint(equalTo: self.cameraPreview.leftAnchor).isActive = true
            preview.rightAnchor.constraint(equalTo: self.cameraPreview.rightAnchor).isActive = true
            preview.bottomAnchor.constraint(equalTo: self.cameraPreview.bottomAnchor).isActive = true
            preview.topAnchor.constraint(equalTo: self.cameraPreview.topAnchor).isActive = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scanner.start()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.scanner.stop()
    }
    
    deinit {
        self.scanner.stop()
    }
}

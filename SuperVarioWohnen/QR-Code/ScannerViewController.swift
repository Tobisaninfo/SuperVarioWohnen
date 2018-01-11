//
//  ScannerViewController.swift
//  SuperVarioWohnen
//
//  Created by Max Bause on 11.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

//
//  ScannerViewController.swift
//  CookNow
//
//  Created by Tobias on 12.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: BarcodeController, BarcodeControllerDelegate {
    
    @IBOutlet weak var flashlightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        view.bringSubview(toFront: flashlightButton)
    }
    
    func barcodeDidDetect(code: String, frame: CGRect) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        
        DispatchQueue.global().async {
            //TODO Fetch data
        }
    }
    
    @IBAction func flashlightHandler(_ sender: Any) {
        isTorchEnable = !isTorchEnable
        flashlightButton.setImage(isTorchEnable ? #imageLiteral(resourceName: "Flash-Filled") : #imageLiteral(resourceName: "Flash"), for: .normal)
    }
}


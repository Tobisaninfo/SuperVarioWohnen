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

class ScannerViewController: QRcodeController, QRcodeControllerDelegate {
    
    @IBOutlet weak var flashlightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        view.bringSubview(toFront: flashlightButton)
    }
    
    func QRcodeDidDetect(code: String, frame: CGRect) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        DispatchQueue.global().async {
            self.checkCode(code: code)
        }
    }
    
    func checkCode(code: String) -> Void {
        let url : URL = URL(string:"https://thecodelabs.de:2530/validation")!
        var request = URLRequest(url: url )
        request.setValue(code, forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if  response.statusCode == 200 {
                    self.writeCode(code: code)
                }
            }
        }
    }
    
    func writeCode(code : String){
        let defaults = UserDefaults.standard
        defaults.set(code, forKey: "qr")
    }
    
    @IBAction func flashlightHandler(_ sender: Any) {
        isTorchEnable = !isTorchEnable
        flashlightButton.setImage(isTorchEnable ? #imageLiteral(resourceName: "Flash-Filled") : #imageLiteral(resourceName: "Flash"), for: .normal)
    }
}


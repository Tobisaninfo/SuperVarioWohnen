//
//  KontakteViewController.swift
//  SuperVarioWohnen
//
//  Created by Max Bause on 11.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import UIKit
import MessageUI

class KontakteViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var management : Management?
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var mailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let code: String? = defaults.string(forKey: "qr")
        getManagementFromAuth(code: code)
        // For development purposes; Remove later !!!
        management = Management(id: "1",name: "Howoge", postcode: "13055", place: "Berlin", street: "Testgasse 1",
                                phone: "03011223344", mail: "howoge@test.de",
                                openings_weekdays: "Mo-Fr: 8:00 - 17:00?", openings_weekends: "")
        if self.management != nil{
            if self.management?.mail == nil {
                mailBtn.isEnabled=false
            }
            if self.management?.phone == nil {
                callBtn.isEnabled = false
            }
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getManagementFromAuth(code : String?){
        if code == nil {return}
        let url : URL = URL(string:"https://thecodelabs.de:2530/management")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(code, forHTTPHeaderField: "auth")
        
        // Setting up URLSession for Communication with REST-API
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder
                let parsedManagement = try JSONDecoder().decode(Management.self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    //print(articlesData)
                    self.management = parsedManagement
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
        
    }
    
    @IBAction func call(_ sender: Any) {
        let tel: URL = URL(string: "telprompt://\((self.management?.phone)!)")!
        UIApplication.shared.open(tel);
    }

    @IBAction func sendEmail(sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([(self.management?.mail)!])
            mailVC.setSubject("Mieteranfrage Objekt: \((self.management?.id)!)")
            mailVC.setMessageBody("", isHTML: false)
            present(mailVC, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Email Delegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

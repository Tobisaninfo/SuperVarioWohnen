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
    @IBOutlet weak var websiteBtn: UIButton!
    @IBOutlet weak var AddressField: UITextView!
    @IBOutlet weak var openingsField: UITextView!
    @IBOutlet weak var managementImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getManagementFromAuth() { m in
            self.management = m
            DispatchQueue.main.async {
                self.setManagementImage()
                self.populateTextFields()
                self.setButtonStates()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getManagementFromAuth(completion:@escaping (Management)->()){
        let code = try? getQrCode()
        if let code = code {
        let url = "https://thecodelabs.de:2530/management"
        var request = URLRequest(url: URL(string: url)!)
        
        //Setting the Header
        request.httpMethod = "GET"
        request.setValue(code, forHTTPHeaderField: "auth")
        
        // Setting up the Session
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let m = try? JSONDecoder().decode([Management].self, from: data)
                if let m = m{
                    completion(m.first!)
                }
            }
        }
        session.resume()
    }
    }
    
    func setManagementImage(){
        if self.management == nil {return}
        let id: Int = self.management!.id
        let url = "https://thecodelabs.de:2530/app/img/\(id).jpg"
        if let image = loadImageFromURL(url){
            self.managementImg.image = image
        } else {
            managementImg.isHidden = true
        }
        
    }
    
    func setButtonStates() {
        if self.management != nil {
            if self.management?.mail == nil {
                mailBtn.isEnabled=false
            }
            if self.management?.telefon == nil {
                callBtn.isEnabled = false
            }
        }
    }
    
    func populateTextFields(){
        if let management = self.management {
            AddressField.text = ""
            let name : String = management.name
            let street = management.street
            let zipCity = management.postcode + " " + management.place
           
            AddressField.text = name + "\n" + street + "\n" + zipCity + "\n"
        
            guard let o1 = management.openings_weekdays, let o2 = management.openings_weekends else {
                openingsField.isHidden=true;
                return
            }
            
            openingsField.text.append("\n" + o1)
            openingsField.text.append("\n" + o2)
        }
    }
    
    @IBAction func call(_ sender: Any) {
        let tel: URL = URL(string: "telprompt://\((self.management?.telefon)!)")!
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
    
    func loadImageFromURL(_ string:String) -> UIImage? {
        let url = URL(string: string)
        let data = try? Data(contentsOf: url!) // I'm assuming the image links are working ;)
        return UIImage(data: data!)
    }
    
    @IBAction func didTapGoogle(sender: AnyObject) {
        if let website = self.management?.website{
            if let url = URL(string: "http://\(website)") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
    }
}

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
    @IBOutlet weak var AddressField: UITextView!
    @IBOutlet weak var openingsField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // getManagementFromAuth()
        // For development purposes; Remove later !!!
        management = Management(id: 1,name: "Howoge", postcode: "10318", place: "Berlin", street: "Treskowallee 109",telefon: "030 54643200", mail: "info@howoge.de",openings_weekdays: "Mo-Fr: 8:00 - 17:00", openings_weekends: "Sa: 10:00- 14:00")
        
        setButtonStates()
        populateTextFields()

    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getManagementFromAuth(){
        let code: String? = "ztiuohijopk"
        if code == nil {return}
        let url = "https://thecodelabs.de:2530/management"
        var request = URLRequest(url: URL(string: url)!)
        //Setting the Header
        
        request.httpMethod = "GET"
        request.setValue(code, forHTTPHeaderField: "auth")
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                    if (jsonObject?.isEmpty)!{
                        return
                    }
                    if let json = jsonObject as? [[String: Any]] {
                        for j in json {
                            let place = j["place"] as! String
                            let telefon = j["telefon"] as! String?
                            let name = j["name"] as! String
                            let postcode = j["postcode"] as! String
                            let street = j["street"] as! String
                            let id = j["id"] as! Int
                            let mail = j["mail"] as! String?
                            let m = Management(id: id, name: name, postcode: postcode, place: place, street: street, telefon: telefon, mail: mail, openings_weekdays: nil, openings_weekends: nil)
                            DispatchQueue.main.async {
                                self.management = m
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        session.resume()
    }
    
    func setButtonStates() {
        if self.management != nil{
            if self.management?.mail == nil {
                mailBtn.isEnabled=false
            }
            if self.management?.telefon == nil {
                callBtn.isEnabled = false
            }
        }
    }
    
    func populateTextFields(){
        AddressField.text = ""
        let name : String = (self.management?.name)!
        let street = (self.management?.street)!
        let zipCity = (self.management?.place)!+" "+(self.management?.postcode)!
        AddressField.insertText(name + "\n" + street + "\n" + zipCity)
        let o1 = self.management?.openings_weekdays
        let o2 = self.management?.openings_weekends
        openingsField.text.append("\n"+o1!+"\n"+o2!)
        
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
}

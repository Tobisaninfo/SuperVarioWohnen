//
//  NewPostViewController.swift
//  SuperVarioWohnen
//
//  Created by Gires Ntchouayang Nzeunga on 25.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    //MARK
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var titelLabel: UITextField!
    @IBOutlet weak var sendeButton: UIButton!
    
    let url = URL(string: "https://thecodelabs.de:2530/forum/1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        postTextView.layer.borderWidth = 0.5
        postTextView.layer.borderColor = borderColor.cgColor
        postTextView.layer.cornerRadius = 3
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendenClicked(_ sender: Any) {
        if (titelLabel.text?.isEmpty)! && postTextView.text.isEmpty || postTextView.text == "Enter a message" {
            showToast(message: "Title und Text bitte eingeben!!")
            return
        }
        let titelP = titelLabel.text!
        let textP = postTextView.text!
        
        let json = "{\"title\": \"" + titelP + "\", \"message\": \"" + textP + "\"}"
        postMessage(payload: json)
        
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func postMessage(payload: String){
        /*var request = URLRequest(url: url!)
        request.setValue("ztiuohijopk", forHTTPHeaderField: "auth")
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        request.httpBody = payload.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print(data.description)
            } else if let error = error {
                print(error.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    self.showToast(message: "An Error has occured, please try again Later")
                    return
                }
            }
        }
        session.resume()*/
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-300, width: 300, height: 80))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


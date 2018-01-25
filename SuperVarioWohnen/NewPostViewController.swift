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
            return
        }
        
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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


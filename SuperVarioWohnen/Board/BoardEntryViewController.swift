//
//  BoardEntryViewController.swift
//  SuperVarioWohnen
//
//  Created by Tobias on 28.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import UIKit

class BoardEntryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UITextView!
    
    var entry: Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let entry = entry {
            titleLabel.text = entry.title
            messageLabel.text = entry.message
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

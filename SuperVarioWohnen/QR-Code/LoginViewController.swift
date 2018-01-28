//
//  LoginViewViewController.swift
//  SuperVarioWohnen
//
//  Created by Max Bause on 11.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        // ztiuohijopk
        let defaults = UserDefaults.standard
        let code: String? = defaults.string(forKey: "qr")
        if(code != nil) {
            self.performSegue(withIdentifier: "loginSuccSeque", sender: self)
        }
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

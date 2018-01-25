//
//  WebViewController.swift
//  collectonprojekt
//
//  Created by Mac on 21.12.17.
//  Copyright © 2017 Mac. All rights reserved.
//


import UIKit
import WebKit

class WebViewController:  UIViewController{
    
    @IBOutlet weak var webe: UIWebView!
    //  var backgroundSession: URLSession!
    var savepdfname:String!
    var urlLink: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.savepdfname)
        loadPdf(pdfname:savepdfname )
        setupViews()
    }
    
    // Mark: - function to load Pdf data
    func loadPdf(pdfname: String) {
        
        var pdfURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        pdfURL = pdfURL.appendingPathComponent(pdfname) as URL
        
        let data = try! Data(contentsOf: pdfURL)
        self.webe.load(data, mimeType: "application/pdf", textEncodingName:"", baseURL: pdfURL.deletingLastPathComponent())
        print(pdfURL)
    }
    
    // Mark: -Function to display Webview
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(webe)
    }
}

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
    
    @IBOutlet weak var webView: UIWebView!
    
    let token = "ztiuohijopk"
    let urlString = "https://thecodelabs.de:2530/documents/"
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let document = document {
            downloadFile(urlString: urlString, document: document)
        }
        setupViews()
    }
    
    // MARK: - download pdf Document
    func downloadFile(urlString: String, document: Document)  {
        if let url = URL(string: urlString.appending("\(document.id)")) {
            var request = URLRequest(url: url)
            
            request.setValue(token, forHTTPHeaderField: "auth")
            request.setValue("application/pdf", forHTTPHeaderField: "Accept-Type")
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Status code: \(statusCode)")
                    }
                    
                    if let documentsUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
                        let destinationFileUrl = documentsUrl.appendingPathComponent(document.name + ".pdf")
                        do {
                            try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        } catch (let writeError) {
                            print("Error creating a file \(destinationFileUrl) : \(writeError)")
                        }
                        DispatchQueue.main.async {
                            self.loadPdf(url: destinationFileUrl)
                        }
                    }
                } else {
                    if let error = error {
                        print("Error took place while downloading a file. \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - function to load Pdf data
    func loadPdf(url: URL) {
        if let data = try? Data(contentsOf: url) {
            self.webView.load(data, mimeType: "application/pdf", textEncodingName:"", baseURL: url)
        }
    }
    
    // Mark: -Function to display Webview
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(webView)
    }
}

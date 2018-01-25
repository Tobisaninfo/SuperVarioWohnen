//
//  detailViewController.swift
//  collectonprojekt
//
//  Created by Mac on 30.11.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class FilesViewController: UIViewController,  UICollectionViewDataSource ,UICollectionViewDelegate {
    
    @IBOutlet weak var collectionview: UICollectionView!
    var documentname = String ()
    var foldername:String!
    var pdfname:String!
    var savepdfname : String!
    var documentid : Int!
    
    let downloadFileURL = "https://thecodelabs.de:2530/documents/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionview.dataSource = self
        
        self.downloadFile(Urlstring: downloadFileURL + String(documentid), pdfname: pdfname )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark  collectionView  Number of Cell
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  1
    }
    
    // Mark  collectionViewcell
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ordner2", for: indexPath) as!  DocumentsViewCell
        cell.label.text = pdfname
        
        return cell
    }
    
    // Mark Passing PDF name Data to  WebViewController
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "webview"
        {
            if self.collectionview.indexPath(for: (sender as? DocumentsViewCell)!) != nil
            {
                let viewVC = segue.destination as! WebViewController
                print(viewVC)
                viewVC.savepdfname =  pdfname+".pdf"
                
                
                
            }
        }
    }
    
    // Mark download pdf Document
    func downloadFile( Urlstring: String, pdfname: String)  {
        // Create destination URL
        // let yourAuthorizationToken = "ztiuohijopk" // whatever is your token
        //  request.setValue(yourAuthorizationToken, forHTTPHeaderField: "auth")
        
        let yourUrl = URL(string:Urlstring ) // whatever is your url
        var request = URLRequest(url:yourUrl!)
        let yourAuthorizationToken = "ztiuohijopk" // whatever is your token
        request.setValue(yourAuthorizationToken, forHTTPHeaderField: "auth")
        
        request.setValue("application/pdf", forHTTPHeaderField: "Accept-Type")
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent(pdfname+".pdf")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Status code: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
}



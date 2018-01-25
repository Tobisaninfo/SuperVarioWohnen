//
//  ViewController.swift
//  SuperVarioWohnen
//
//  Created by Tobias on 31.10.17.
//  Copyright © 2017 Tobias. All rights reserved.
//


import UIKit

class DocumentsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var documentid : Int = 0
    var odrnerauswahlnummer : Int? =  nil
    var documentname = String ()
    var  foldername  = String ()
    let array = ["10"]
    ///server Data
    let yourAuthorizationToken = "ztiuohijopk" // whatever is your token
    let urlString1 = "https://thecodelabs.de:2530/documents"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ordner", for: indexPath) as! DocumentsViewCell
        
        if indexPath.row == 0 {
            //configure action when tap cell 1
            
            odrnerauswahlnummer = 1
            
            let image = "\(array[0]).jpg"
            cell.imageView.image = UIImage(named: image)
            cell.label.text = "Rechnungen"
        } else if indexPath.row == 1 {
            //configure action when tap cell 2
            odrnerauswahlnummer = 2
            let image = "\(array[0]).jpg"
            cell.imageView.image = UIImage(named: image)
            cell.label.text = "Ratgeber"
            
            self.downloadJsonWithURL1(Urlstring: urlString1)
            
        } else if indexPath.row == 2 {
            
            odrnerauswahlnummer = 3
            
            let image = "\(array[0]).jpg"
            cell.imageView.image = UIImage(named: image)
            cell.label.text = "Grundriss"
            
            
        }else if indexPath.row == 3 {
            
            odrnerauswahlnummer = 4
            
            let image = "\(array[0]).jpg"
            cell.imageView.image = UIImage(named: image)
            cell.label.text = "Mietvertrag"
        }
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "filesSegue"
        {
            // let viewVC = segue.destination as! detailViewController
            if (odrnerauswahlnummer==1){
                let viewVC = segue.destination as! FilesViewController
                viewVC.documentid = documentid
                viewVC.pdfname = documentname
                viewVC.foldername = foldername
            }
            if (odrnerauswahlnummer==2){
                let viewVC = segue.destination as! FilesViewController
                viewVC.documentid = documentid
                viewVC.pdfname = documentname
                viewVC.foldername = foldername
            }
            if (odrnerauswahlnummer==3){
                let viewVC = segue.destination as! FilesViewController
                viewVC.documentid = documentid
                viewVC.pdfname = documentname
                viewVC.foldername = foldername
                
            }
            if (odrnerauswahlnummer==4){
                
                let viewVC = segue.destination as! FilesViewController
                viewVC.documentid = documentid
                viewVC.pdfname = documentname
                viewVC.foldername = foldername
            }
            
        }
    }
    
    
    func downloadJsonWithURL1(Urlstring: String) {
        
        let yourUrl = URL(string:Urlstring ) // whatever is your url
        let yourPayload = Data() // whatever is your payload
        var request = URLRequest(url:yourUrl!)
        request.httpMethod = "GET"
        request.setValue(yourAuthorizationToken, forHTTPHeaderField: "auth")
        // request.setValue("application/pdf", forHTTPHeaderField: "Accept-Type")
        request.httpBody = yourPayload
        // executing the call
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            // your stuff here
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:Any]]
                for dayData in json{
                    
                    if let name = dayData["name"] as? String{
                        //  print (id)
                        self.documentname = name
                        // print (self.documentname)
                        
                    }
                    
                    if let id = dayData["id"] as? Int{
                        // print (id)
                        self.documentid = id
                        // print (self.documentid)
                    }
                    if let folder = dayData["folder"] as? String{
                        // print (folder)
                        self.foldername = folder
                        //print (self.foldername)
                    }
                }
                //  print(a)
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
}

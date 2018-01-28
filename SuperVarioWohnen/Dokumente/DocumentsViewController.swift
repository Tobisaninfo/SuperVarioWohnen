//
//  ViewController.swift
//  SuperVarioWohnen
//
//  Created by Tobias on 31.10.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

// https://images.techhive.com/images/article/2016/04/os-x-folder-icon-100657987-orig.jpg

import UIKit

class DocumentsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedFolder : Int? =  nil
    
    var documents: [Document] = []
    
    ///server Data
    let urlString = "https://thecodelabs.de:2530/documents"
    
    private let folderNames = ["Rechnungen", "Ratgeber", "Grundriss", "Mietvertrag"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DispatchQueue.global().async {
            self.downloadJsonFromUrl(urlString: self.urlString)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ordner", for: indexPath) as! DocumentsViewCell
        
        var imageName: String?
        
        if indexPath.row == 0 {
            imageName = "folder"
        } else if indexPath.row == 1 {
            imageName = "folder"
        } else if indexPath.row == 2 {
            imageName = "folder"
        } else if indexPath.row == 3 {
            imageName = "folder"
        }
        
        if let imageName = imageName {
            cell.imageView.image = UIImage(named: imageName)
        }
        cell.label.text = folderNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedFolder = indexPath.row
        self.performSegue(withIdentifier: "fileSegue", sender: self)
    }
    
    // MARK: - Layout
    
    private let columnCount = 2
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        let viewWidth =  collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemSize = viewWidth / CGFloat(columnCount)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fileSegue", let selectedFolder = selectedFolder {
            let destinationViewController = segue.destination as! FilesViewController
            destinationViewController.folderName = folderNames[selectedFolder]
            destinationViewController.documents = documents.filter() { $0.folderName == folderNames[selectedFolder]}
        }
    }
    
    
    func downloadJsonFromUrl(urlString: String) {
        if let url = URL(string:urlString), let token = try? getQrCode() {
            let payload = Data()
            var request = URLRequest(url:url)
            request.httpMethod = "GET"
            request.setValue(token, forHTTPHeaderField: "auth")
            request.httpBody = payload
            
            self.documents = []
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                do {
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:Any]]
                        for entry in json {
                            guard let name = entry["name"] as? String else {
                                continue
                            }
                            guard let id = entry["id"] as? Int else {
                                continue
                            }
                            guard let folder = entry["folder"] as? String else {
                                continue
                            }
                            
                            self.documents.append(Document(id: id, name: name, folderName: folder))
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            })
            task.resume()
        }
    }
}

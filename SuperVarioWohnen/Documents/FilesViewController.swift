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
    
    var documents: [Document] = []
    var selectedDocument: Int?
    
    let downloadFileURL = "https://thecodelabs.de:2530/documents/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionview.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark  collectionView  Number of Cell
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    // Mark  collectionViewcell
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ordner2", for: indexPath) as!  DocumentsViewCell
        cell.label.text = documents[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDocument = indexPath.row
        self.performSegue(withIdentifier: "webview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webview", let selectedDocument = selectedDocument {
            let viewVC = segue.destination as! WebViewController
            viewVC.document = documents[selectedDocument]
        }
    }
}

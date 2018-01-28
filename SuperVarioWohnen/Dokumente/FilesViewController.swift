//
//  detailViewController.swift
//  collectonprojekt
//
//  Created by Mac on 30.11.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class FilesViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    var folderName: String?
    var documents: [Document] = []
    var selectedDocument: Int?
    
    let downloadFileURL = "https://thecodelabs.de:2530/documents/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionview.dataSource = self
        
        self.navigationItem.title = folderName
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
    
    // MARK: - Layout
    
    private let columnCount = 3
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        let viewWidth =  collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemSize = viewWidth / CGFloat(columnCount)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webview", let selectedDocument = selectedDocument {
            let viewVC = segue.destination as! WebViewController
            viewVC.document = documents[selectedDocument]
        }
    }
}

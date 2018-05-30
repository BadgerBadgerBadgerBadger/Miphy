//
//  ViewController.swift
//  Miphy
//
//  Created by Shaun on 12/05/18.
//  Copyright © 2018 Nwinworks. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage
import JASON

class ViewController: NSViewController {
    
    var gifItems = [JSON]()
    
    @IBOutlet weak var previews: NSCollectionView!
    @IBAction func onSearchEnter(_ sender: NSTextField) {
        
        let searchQuery = sender.stringValue
        let giphQueryUrl = "https://api.giphy.com/v1/gifs/search?api_key=kQFh0pfL8AEU8tWQlu6YiJeoVdR72cww&q=\(searchQuery)&limit=25&offset=0&rating=G&lang=en"
        
        Alamofire.request(giphQueryUrl).responseJSON {
            response in
            
            let json = JSON(response.result.value)
            
            for item in json["data"] {
                self.gifItems.append(item)
            }
            
            self.previews.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.black.cgColor
        self.view.layer?.borderColor = NSColor.black.cgColor
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0

        previews.collectionViewLayout = flowLayout

        self.previews.wantsLayer = true
        previews.layer?.backgroundColor = NSColor.black.cgColor
        previews.layer?.borderColor = NSColor.black.cgColor
        
        previews.enclosingScrollView?.wantsLayer = true
        previews.enclosingScrollView?.layer?.borderColor = NSColor.black.cgColor
    }
}

extension ViewController : NSCollectionViewDataSource {

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gifItems.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        
        collectionViewItem.imageItem = self.gifItems[indexPath.item]
        return collectionViewItem
    }
}


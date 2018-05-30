import Cocoa
import Alamofire
import AlamofireImage
import JASON

class CollectionViewItem: NSCollectionViewItem {
    
    var imageItem: JSON? {
        didSet {
            guard isViewLoaded else {return}
            if let imageItem = imageItem {
                
                let previewUrl = imageItem["images"]["downsized"]["url"]
                
                 Alamofire.request(previewUrl.stringValue).responseImage {
                    imageResponse in
                    
                    self.imageView?.image = imageResponse.result.value
                    self.imageView?.animates = true
                    
                    self.imageView?.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(CollectionViewItem.copyToClipboard)))
                }
            } else {
                imageView?.image = nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor.init(gray: 0.0, alpha: 0.0)
    }
    
    @objc private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([self.imageItem!["images"]["original"]["url"].stringValue as NSString])
        
        let alert = NSAlert()
        alert.messageText = "Url copied to clipboard."
        alert.alertStyle = .informational
        
        alert.runModal()
    }
}

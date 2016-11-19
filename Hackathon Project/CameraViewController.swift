//
//  CameraViewController.swift
//  Hackathon Project
//
//  Created by Tom Large on 11/19/16.
//  Copyright © 2016 WildHacks. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var ImageView: UIImageView!
    var lat:CLLocationDegrees?
    var long:CLLocationDegrees?
    @IBOutlet weak var TextField: UITextField!
    
    let photoArr: [String] = []
   // let arrayOneKey = "Item 1"
  //  let arrayTwoKey = "Item 2"
  //  var arrayOneID: [AnyObject] = [42.20 as AnyObject, -80.0 as AnyObject, 1 as AnyObject, "First Picture" as AnyObject]
   // var arrayTwoID:[AnyObject] = [42.20 as AnyObject,-82.0 as AnyObject,1 as AnyObject,"Second Picture" as AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LibraryButton(_ sender: Any) {
        let LibraryUI = UIImagePickerController()
        LibraryUI.delegate = self
        LibraryUI.allowsEditing = true
        LibraryUI.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(LibraryUI, animated: true, completion: nil)
    }
    
    @IBAction func CameraButton(_ sender: Any) {
        let CameraUI = UIImagePickerController()
        CameraUI.delegate = self
        CameraUI.allowsEditing = true
        CameraUI.sourceType = UIImagePickerControllerSourceType.camera
        self.present(CameraUI, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        ImageView.image = originalImage
        
        //add to trip photos
        let tripNum = appDelegate.TripArray.count - 1
        let currentTrip = appDelegate.TripArray[tripNum] as! TripObject
        currentTrip.photos.append(originalImage)
        
        if picker.sourceType == UIImagePickerControllerSourceType.photoLibrary {
            let url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url as URL], options: nil).firstObject
            let location = asset?.location   //then do something with this data -> save to plist
            lat = location?.coordinate.latitude
            long = location?.coordinate.longitude
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DoneButton(_ sender: Any) {
        //what trip is this? what index photo for that trip is it?
        let tripNum = appDelegate.TripArray.count - 1
        let plistStringShort = "Trip\(tripNum)"
        let plistString = "Trip\(tripNum).plist"
        
        let arrayIndex = (appDelegate.TripArray[tripNum] as! TripObject).photos.count - 1
        let arrayKey = "\(arrayIndex)"
        print("Array Key for Pic: \(arrayKey)")
        
        // Make array: lat, long, trip no., title, caption
        var caption = " "
        if let text = TextField.text {
            caption = text
        }
        
        let arrayEntry:[AnyObject] = [lat as AnyObject!, long as AnyObject!, tripNum as AnyObject, caption as AnyObject!]
        print(arrayEntry)
        saveLocationData(id: arrayEntry, key: arrayKey, plist: plistString)
        
        view.endEditing(true)
        
    }
    
    func saveLocationData(id:[AnyObject], key:String, plist:String) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(plist)
        
        var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        //saving values
        dict.setObject(id, forKey: key as NSCopying)
        print(id, key)
        
        //writing to GameData.plist
        dict.write(toFile: path, atomically: false)
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Saved \(plist) file is --> \(resultDictionary?.description)")
    }
    
}

//
//  CameraViewController.swift
//  Hackathon Project
//
//  Created by Tom Large on 11/19/16.
//  Copyright © 2016 WildHacks. All rights reserved.
//

import UIKit
import Photos
import MBProgressHUD

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var ImageView: UIImageView!
    var lat:CLLocationDegrees?
    var long:CLLocationDegrees?
    @IBOutlet weak var TextField: UITextField!
    
    let locationManager = CLLocationManager()
    var currentLat:CLLocationDegrees?
    var currentLong:CLLocationDegrees?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            backgroundImageView.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = UIScreen.main.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundImageView.addSubview(blurEffectView)
        } else {
            backgroundImageView.backgroundColor = UIColor.black
        }
        
        if (appDelegate.currentTripBool != nil) && (appDelegate.currentTripBool != false) {
            //
        } else {
            self.alert(title: "Wait!", message: "You aren't on a trip right now, start one to add pictures!")
        }
        self.locationManager.requestAlwaysAuthorization()
    }
    private func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let backAction = UIAlertAction(title: "Start a Trip", style: .cancel) { (action) in
            self.performSegue(withIdentifier: "CancelCameraSegue", sender: nil)
        }
        alertController.addAction(backAction)
        
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
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
            print("PHOTOLIBRARY")
            let url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url as URL], options: nil).firstObject
            let location = asset?.location   //then do something with this data -> save to plist
            lat = location?.coordinate.latitude
            long = location?.coordinate.longitude
        } else {
            print("CAMERA")
            
            if CLLocationManager.locationServicesEnabled(){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                locationManager.delegate = self
                
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
            }

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
        
        if (lat != nil) && (long != nil) {
            let arrayEntry:[AnyObject] = [self.lat as AnyObject!, self.long as AnyObject!, tripNum as AnyObject, caption as AnyObject!]
            print(arrayEntry)
            self.saveLocationData(id: arrayEntry, key: arrayKey, plist: plistString)
        } else {
            print("error: nil lat or long")
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        guard let location = locations.first else { return }
        currentLat = location.coordinate.latitude
        currentLong = location.coordinate.longitude
        lat = currentLat
        long = currentLong
        MBProgressHUD.hide(for: self.view, animated: true)
        print("DID UPDATE")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

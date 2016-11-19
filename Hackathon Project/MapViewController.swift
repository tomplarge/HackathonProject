//
//  MapViewController.swift
//  Hackathon Project
//
//  Created by Tom Large on 11/19/16.
//  Copyright © 2016 WildHacks. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var MapSearchBar: UISearchBar!
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    
    var SelectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
        
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
            let annotations = getMapAnnotations()
        MapView.addAnnotations(annotations)
    }

    
    func getMapAnnotations() -> [Station]{
        var annotations:Array = [Station]()

        let currentTripIndex = appDelegate.TripArray.count - 1
        let currentTrip = appDelegate.TripArray[currentTripIndex] as! TripObject
        let plistName = "Trip\(currentTripIndex)"

        let numPhotos = currentTrip.photos.count - 1
        
        for index in 0...numPhotos {
            print("FOR LOOP!!!!")
            let key = "\(index)"
            let currentArray:[AnyObject] = loadLocationData(key: key, plistName: plistName)
            let lat = currentArray[0] as! Double
            let long = currentArray[1] as! Double
            let annotation = Station(latitude: lat, longitude: long)
            annotation.caption = currentArray[3] as! String
            annotations.append(annotation)
        }
        return annotations
     /*
        var annotations: Array = [Station]()
    
        var stations: NSArray?
        if let path = Bundle.main.path(forResource: "Stations",ofType: "plist"){
            stations = NSArray(contentsOfFile: path)
        }
        
        if let items = stations {
            for item in items{
                let lat = (item as AnyObject).value(forKey: "lat")
                let long = (item as AnyObject).value(forKey: "long")
                let annotation = Station(latitude: lat as! Double, longitude: long as! Double)
                annotation.title = (item as AnyObject).value(forKey: "title") as? String
                annotations.append(annotation)
            }
        }
        return annotations
 */
    }
    func loadLocationData(key:String, plistName:String) -> [AnyObject]{
        
        // getting path to plist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let plistText = "\(plistName).plist"
        let path = (documentsDirectory as NSString).appendingPathComponent(plistText)
        
        let fileManager = FileManager.default
        
        //check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: plistName, ofType: "plist") {
                
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle test file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                    print("copy")
                } catch {
                    print("error copying")
                }
                
            } else {
                print("\(plistName).plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("\(plistName).plist already exists at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Loaded test file is --> \(resultDictionary?.description)")
        
        var myDict = NSDictionary(contentsOfFile: path)
        
        //var idName = id
        if let dict = myDict {
            //loading values
            return dict.object(forKey: key)! as! [AnyObject]
            
        } else {
            print("WARNING: Couldn't create dictionary from \(plistName).plist! Default values will be used!")
            return []
        }
    }
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        guard let location = locations.first else { return }
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000.0, 5000.0)
        MapView.setRegion(region, animated:true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

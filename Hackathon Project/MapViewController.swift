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

//
//  TripCreator.swift
//  Hackathon Project
//
//  Created by Tom Large on 11/19/16.
//  Copyright © 2016 WildHacks. All rights reserved.
//

import UIKit

class TripCreator: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var TripTitle: UITextField!
    @IBOutlet weak var TripOverview: UITextView!
    @IBOutlet weak var StartDate: UIDatePicker!
    @IBOutlet weak var EndDate: UIDatePicker!

    @IBAction func DoneTripCreator(_ sender: Any) {
        let Trip = TripObject()
        Trip.title = TripTitle.text
        Trip.startdate = StartDate.date as NSDate?
        Trip.enddate = EndDate.date as NSDate?
        Trip.overview = TripOverview.text
        Trip.photos = []
        Trip.stations = []
        Trip.index = appDelegate.TripArray.endIndex
        
        appDelegate.TripArray.append(Trip)
        print("COUNT \(appDelegate.TripArray.count)")
        print("ENDIND \(appDelegate.TripArray.endIndex)")
    }
    
    @IBAction func TapOffKeyboard(_ sender: Any) {
       view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  TripCreator.swift
//  Hackathon Project
//
//  Created by Tom Large on 11/19/16.
//  Copyright © 2016 WildHacks. All rights reserved.
//

import UIKit

class TripCreator: UIViewController {

    @IBOutlet weak var TripTitle: UITextField!
    @IBOutlet weak var TripOverview: UITextView!
    @IBOutlet weak var StartDate: UIDatePicker!
    @IBOutlet weak var EndDate: UIDatePicker!

    @IBAction func DoneTripCreator(_ sender: Any) {
        let Trip1 = TripObject()
        Trip1.title = TripTitle.text
        Trip1.startdate = StartDate.date as NSDate?
        Trip1.enddate = EndDate.date as NSDate?
        Trip1.overview = TripOverview.text
        Trip1.photos = []
        Trip1.stations = []
        Trip1.index = 1
    }
    
    @IBAction func TapOffKeyboard(_ sender: Any) {
       view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

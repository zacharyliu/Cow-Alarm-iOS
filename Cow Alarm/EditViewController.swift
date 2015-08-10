//
//  EditViewController.swift
//  Cow Alarm
//
//  Created by Zachary Liu on 8/9/15.
//  Copyright (c) 2015 Zachary Liu. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let defaults = NSUserDefaults.standardUserDefaults()
        let maybeDate: NSDate? = defaults.valueForKey("alarmTime") as! NSDate?
        if let date = maybeDate {
            datePicker.setDate(date, animated: false)
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let dateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH-mm")
        let time = dateFormatter.dateFromString(dateFormatter.stringFromDate(datePicker.date))
        defaults.setValue(time, forKey:"alarmTime")
        defaults.synchronize()
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    
}

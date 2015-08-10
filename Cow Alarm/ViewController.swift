//
//  ViewController.swift
//  Cow Alarm
//
//  Created by Zachary Liu on 8/9/15.
//  Copyright (c) 2015 Zachary Liu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var isPlaying: Bool = false
    var player: AVAudioPlayer?
    var timer: NSTimer?
    
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var alarmTimeLabel: UIButton!

    @IBAction func buttonPressed(sender: AnyObject) {
        dismissButton.hidden = true
        self.isPlaying = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default time
        let defaults = NSUserDefaults.standardUserDefaults()
        var maybeDate: NSDate? = defaults.valueForKey("alarmTime") as! NSDate?
        if maybeDate == nil {
            defaults.setValue(NSDate(), forKey: "alarmTime")
        }
        
        self.playAlarm()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("appearing")
        self.loadAlarm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAlarm() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var date: NSDate? = defaults.valueForKey("alarmTime") as! NSDate?
        
        // Display time
        let dateReader = NSDateFormatter()
        dateReader.setLocalizedDateFormatFromTemplate("hh:mm a")
        let dateString = dateReader.stringFromDate(date!)
        alarmTimeLabel.setTitle(dateString, forState: UIControlState.Normal)
        
        // Clear previous alarm if present
        self.timer?.invalidate()
        
        // Calculate interval until next alarm
        let dateReader2 = NSDateFormatter()
        dateReader2.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        var now = dateReader2.dateFromString(dateReader2.stringFromDate(NSDate()))
        let secondsPerDay = 24.0 * 60.0 * 60.0
        let interval = (date!.timeIntervalSinceDate(now!) + secondsPerDay) % secondsPerDay
        
        // Set new alarm
        self.timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: Selector("playAlarm"), userInfo: nil, repeats: false)
    }
    
    func playMoo() {
        playFile("win")
    }
    
    func playFile(name: NSString) {
        let mainBundle = NSBundle.mainBundle()
        let filePath = mainBundle.pathForResource(name as String, ofType: "mp3")
        let fileData = NSData(contentsOfFile: filePath!)
        self.player = AVAudioPlayer(data: fileData!, error: nil)
        self.player!.prepareToPlay()
        self.player!.play()
    }
    
    func playAlarm() {
        self.isPlaying = true
        var playStep = 0
        var currentIndex = 0
        dismissButton.hidden = false
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            while self.isPlaying {
                NSThread.sleepForTimeInterval(0.3)
                println("Test " + playStep.description + " " + currentIndex.description)
                
                self.playFile(currentIndex.description)
                
                playStep++
                if playStep > 5 {
                    playStep = 0
                    if currentIndex < 11 {
                        currentIndex++
                    }
                }
            }
            
            if (self.player != nil) {
                self.player!.stop()
            }
            
            NSThread.sleepForTimeInterval(1.2)
            self.playMoo()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.loadAlarm()
            })
        });
    }

}

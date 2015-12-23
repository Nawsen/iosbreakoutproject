//
//  HighscoreController.swift
//  BreakoutProject
//
//  Created by Wannes Van Dorpe on 23/12/2015.
//  Copyright © 2015 Wannes Van Dorpe. All rights reserved.
//

import UIKit

class HighscoreController: UIViewController{
    
    
    @IBOutlet var level : UILabel!
    @IBAction func reset(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(0, forKey: "highscore")
        level.text = "0"
    }
    
    override func viewDidLoad() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let highscore = userDefaults.valueForKey("highscore") {
            let F = highscore as? NSNumber
            level.text = F?.description
            
        }
        else {
            level.text = "*"
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
}
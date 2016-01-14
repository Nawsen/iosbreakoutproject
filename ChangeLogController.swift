//
//  ChangeLogController.swift
//  BreakoutProject
//
//  Created by Wannes Van Dorpe on 14/01/2016.
//  Copyright © 2016 Wannes Van Dorpe. All rights reserved.
//

import UIKit

class ChangeLogController: UITableViewController {

    var items: [String] = [
        "v0.1 : Basic game implementation",
        "v0.2 : Basic game-overscreen created",
        "v0.3 : Basic start screen implementation",
        "v0.4 : UINavigationController implemented",
        "v0.5 : Highscore screen created",
        "v0.6 : Highscore now gets saved",
        "v0.7 : Highscore reset implemented",
        "v0.8 : TableViewController for this log created"]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("logcell", forIndexPath: indexPath) as UITableViewCell
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item
        
        
        return cell
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
}

//
//  OccurringEventsTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/17/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import UserNotifications

class OccurringEventsTableViewController: UITableViewController {
    
    private var events:[[String:Any]] = []
//    private var eventList:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { deliveredNotifications -> () in
            if deliveredNotifications.count > 0 {
                for notification in deliveredNotifications {
                    let eventID:String = notification.request.identifier
                    DBHandler.addEventToTimeline(eventID: eventID)
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [eventID])
                }
                
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    @objc private func createTimeline(_ notification: NSNotification) {
        if let eventID = notification.userInfo?["eventID"] as? String {
            print(eventID)
        }
    }
    
    func tableView (tableView:UITableView , heightForHeaderInSection section:Int)->Float {
        return 100.0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

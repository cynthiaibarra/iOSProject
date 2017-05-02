//
//  OccurringEventsTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/17/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class OccurringEventsTableViewController: UITableViewController {
    
    private var events:[[String:Any]] = []
    private var eventList:[String:String] = [:]
    private var themeDict:[String:UIColor] = Theme.getTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Timelines"      
        //Set Theme
        self.view.backgroundColor = themeDict["viewColor"]

        DBHandler.getTimelineEvents() { (timelineEvents) -> () in
            self.eventList = timelineEvents
            for event in self.eventList {
                let eventID = event.key
                DBHandler.getEventInfo(eventID: eventID){ (event) -> () in
                    self.events.append(event)
                    self.tableView.insertRows(at: [IndexPath(row: self.events.count - 1, section: 0)], with: .automatic)
                }
            }
        }
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
        if events.count == 0 {
            TableViewHelper.emptyMessage(message: "No timelines... yet!\nAttend an event to display an event timeline.", viewController: self, tableView: self.tableView)
        } else {
            TableViewHelper.clearMessage(tableView: tableView)
        }
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineEventCell", for: indexPath) as! OccurringEventTableViewCell

        let event = events[indexPath.row]
        cell.titleLabel.text = event["title"] as? String
        cell.startLabel.text = event["start"] as? String
        cell.endLabel.text = event["end"] as? String

        let imageID:String? = event["image"] as? String
        if imageID != nil {
            let reference = FIRStorage.storage().reference().child(imageID!)
            let imageView:UIImageView = cell.imageview
            let placeholderImage = UIImage(named: "austin-blur")
            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        } else {
            cell.imageview.image = UIImage(named: "austin-blur")
        }
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTimeline" {
            if let timelineVC = segue.destination as? TimelineViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    timelineVC.eventID = (self.events[indexPath.row]["id"] as? String)!
                    timelineVC.eventTitle = (self.events[indexPath.row]["title"] as? String)!
                    timelineVC.event = self.events[indexPath.row]
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 11.0
        cell.layer.borderColor = themeDict["viewColor"]?.cgColor
    }
    
}

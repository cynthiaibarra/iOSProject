//
//  EventsTableViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/30/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import MapKit

class EventsTableViewController: UITableViewController {
    
    private var myEvents:[[String:Any]] = []
    private var invitedEvents:[[String:Any]] = []
    private var attendingEvents:[[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let addEventButton:UIButton = UIButton.init(type: UIButtonType.custom)
        addEventButton.setImage(UIImage(named: "plus.png"), for: .normal)
        addEventButton.addTarget(self, action: #selector(self.segueToCreateEvent), for: .touchUpInside)
        addEventButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addEventButton)
        
        self.navigationController?.setNavigationBarHidden(false, animated:false)
        
        //Create back button of type custom
        self.title = "Events"
        setBackButton()
        DBHandler.getUserEventIDs(userEmail: (FIRAuth.auth()?.currentUser?.email)!) { (eventID) -> () in
            DBHandler.getEventInfo(eventID: eventID["id"]!) { (event) -> () in
                if eventID["status"] == "hosting" {
                    self.myEvents.append(event)
                    self.tableView.insertRows(at: [IndexPath(row: self.myEvents.count - 1, section: 2)], with: .automatic)
                } else if eventID["status"] == "pending" {
                    self.invitedEvents.append(event)
                    self.tableView.insertRows(at: [IndexPath(row: self.invitedEvents.count - 1, section: 1)], with: .automatic)
                } else if eventID["status"] == "attending" {
                    self.attendingEvents.append(event)
                    self.tableView.insertRows(at: [IndexPath(row: self.attendingEvents.count - 1, section: 0)], with: .automatic)
                }
            }
        }
        
    }
    

    func popToRoot(sender:UIBarButtonItem){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return attendingEvents.count
        } else if section == 1 {
            return invitedEvents.count
        }
        return myEvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        var event:[String:Any] = [:]
        
        if indexPath.section == 0 {
            event = attendingEvents[indexPath.row]
            cell.acceptInviteButton.isHidden = true
        } else if indexPath.section == 1 {
            event = invitedEvents[indexPath.row]
            cell.index = indexPath.row
            cell.acceptInviteButton.addTarget(self, action: #selector(EventsTableViewController.acceptInviteButton(_:)), for: .touchUpInside)
        } else {
            event = myEvents[indexPath.row]
            cell.acceptInviteButton.isHidden = true
        }
        cell.id = event["id"] as? String
        cell.titleLabel.text = event["title"] as? String
        cell.locationLabel.text = event["location"] as? String
        cell.startDateLabel.text = event["start"] as? String
        
        let imageID:String = (event["image"] as? String)!
        DBHandler.getImage(imageID: imageID) { (image) -> () in
            cell.eventImageView.image = image
        }
        return cell
    }
    
    @objc private func acceptInviteButton(_ sender: UIButton) {
        let vc = sender.superview?.superview as! EventTableViewCell
        print(vc.id!)
        DBHandler.acceptInvite(eventID: vc.id!)
        let event = invitedEvents[vc.index!]
        invitedEvents.remove(at: vc.index!)
        let indexPath = IndexPath(row: vc.index!, section: 1)
        tableView.deleteRows(at: [indexPath], with: .fade)
        attendingEvents.append(event)
        tableView.insertRows(at: [IndexPath(row: self.attendingEvents.count - 1, section: 0)], with: .automatic)
    }
    
    @objc private func segueToCreateEvent() {
        performSegue(withIdentifier: "segueToCreateEvent" , sender: self)
    }
    
    private func setBackButton() {
        let myBackButton:UIButton = UIButton.init(type: .custom)
        myBackButton.addTarget(self, action: #selector(EventsTableViewController.popToRoot(sender:)), for: .touchUpInside)
        myBackButton.setTitle("Home", for: .normal)
        myBackButton.setTitleColor(UIColor(hex: 0x007AFF) , for: .normal)
        myBackButton.sizeToFit()
        
        //Add back button to navigationBar as left Button
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Attending"
        } else if section == 1 {
            return "Invited"
        } else {
            return "Hosting"
        }
    }
    
    func tableView (tableView:UITableView , heightForHeaderInSection section:Int)->Float {
        return 122.0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            if indexPath.section == 0 {
                attendingEvents.remove(at: indexPath.row)
            } else if indexPath.section == 1 {
                invitedEvents.remove(at: indexPath.row)
            } else {
                myEvents.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

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
    } */
 

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventInfo" {
            if let eventInfoVC = segue.destination as? EventInfoViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    var event:[String:Any] = [:]
                    if indexPath.section == 0 {
                        event = self.attendingEvents[indexPath.row]
                    } else if indexPath.section == 1 {
                        event = self.invitedEvents[indexPath.row]
                    } else {
                        event = self.myEvents[indexPath.row]
                    }
        
                    eventInfoVC.eventTitle = (event["title"] as? String)!
                    eventInfoVC.location = event["location"] as? String
                    eventInfoVC.address = event["address"] as? String
                    eventInfoVC.start = event["start"] as? String
                    eventInfoVC.end = event["end"] as? String
                    let lat:CLLocationDegrees = (event["latitude"] as? CLLocationDegrees)!
                    let long:CLLocationDegrees = (event["longitude"] as? CLLocationDegrees)!
                    eventInfoVC.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    eventInfoVC.imageID = event["image"] as? String
                    eventInfoVC.invitees = event["invitees"] as? [String:String]
                    eventInfoVC.eventID = event["id"] as? String
                }
            }
        }
    }
}

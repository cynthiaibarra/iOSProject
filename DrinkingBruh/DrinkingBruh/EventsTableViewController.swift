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
    private var themeDict:[String:UIColor] = Theme.getTheme()
    let roles:[String] = ["Designated Driver", "Birthday Boy/Girl", "Rando", "Casual Member", "Free Agent"]
    let picker = UIPickerView()
    var selectedRow:Int = 0
    var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Theme
        self.view.backgroundColor = themeDict["viewColor"]
        
        //Setting UIPicker delegate
        picker.delegate = self
        
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
                    let d:String = (event["start"] as? String)!
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE, MMM d yyyy, hh:mm a"
                    let date:Date = dateFormatter.date(from: d)!
                    let timeInterval = date.timeIntervalSinceNow
                    if timeInterval < 0 {
                        DBHandler.deleteEvent(eventID: eventID["id"]!)
                    } else {
                        self.invitedEvents.append(event)
                        self.tableView.insertRows(at: [IndexPath(row: self.invitedEvents.count - 1, section: 1)], with: .automatic)
                    }
                    
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
        var event:[String:Any] = [:]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
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
    
        alert = UIAlertController(title: "Role Selection", message: "Choose your role in the event!", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "The Awesome One"
            textField.inputView = self.picker
            textField.text = self.roles[self.selectedRow]
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let role:String = (textField?.text!)!
            DBHandler.addRole(role: role, eventID: vc.id!)
        }))
        self.present(alert, animated: true, completion: nil)
        NotificationManager.eventNotification(date: vc.startDateLabel.text!, eventTitle: vc.titleLabel.text!, eventID: vc.id!)
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

extension EventsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedRow = row
        let textField = alert.textFields![0]
        textField.text = self.roles[self.selectedRow]
        
    }
}


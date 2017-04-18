//
//  EventInfoViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/7/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import MapKit

class EventInfoViewController: UIViewController {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var hostImageView: UIImageView!
    @IBOutlet weak var hostFirstNameLabel: UILabel!
    @IBOutlet weak var hostLastNameLabel: UILabel!
  
    var eventTitle:String?
    var imageID:String?
    var start:String?
    var end:String?
    var location:String?
    var address:String?
    var coordinates:CLLocationCoordinate2D?
    var invitees:[String:String]?
    var eventID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHostInfo()
        DBHandler.getImage(imageID: imageID!) { (image) -> () in
            self.eventImageView.image = image
        }
        eventTitleLabel.text = eventTitle
        startDateLabel.text = start
        endDateLabel.text = end
        locationLabel.text = location
        addressLabel.text = address
        setUpMap()
        
        if invitees?[DBHandler.getUserEmail()] == "hosting" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EventInfoViewController.segueToEditEvent))
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func segueToEditEvent() {
        performSegue(withIdentifier: "segueToEditInfo", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGuestList" {
            if let guestListVC = segue.destination as? GuestsTableViewController {
                guestListVC.invitees = self.invitees!
                guestListVC.eventID = self.eventID!
            }
        }else if segue.identifier == "segueToEditInfo" {
            if let createEventVC = segue.destination as? CreateEventViewController {
                createEventVC.edit = true
                createEventVC.eventTitle = eventTitle
                createEventVC.eventStart = start
                createEventVC.eventEnd = end
                createEventVC.eventLocation = location
                createEventVC.eventAddress = address
                createEventVC.latitude = (coordinates?.latitude)!
                createEventVC.longitude = (coordinates?.longitude)!
                createEventVC.eventID = eventID!
                createEventVC.invitees = invitees
                createEventVC.imageID = imageID
            }
        }
    }
    
    private func setUpMap() {
        mapView.setCenter(coordinates!, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates!
        pin.title = location
        var arr:[MKPointAnnotation] = []
        arr.append(pin)
        mapView.showAnnotations([pin], animated: true)
    }
    
    private func setUpHostInfo () {
        for invitee in invitees! {
            if invitee.value == "hosting" {
                DBHandler.getUserInfo(userEmail: invitee.key){ (hostInfo) -> () in
                    DBHandler.getImage(imageID: hostInfo["image"] as! String) { (image) -> () in
                        self.hostImageView.image = image
                    }
                    self.hostFirstNameLabel.text = hostInfo["firstName"] as? String
                    self.hostLastNameLabel.text = hostInfo["lastName"] as? String
                }
            }
        }
    }
}

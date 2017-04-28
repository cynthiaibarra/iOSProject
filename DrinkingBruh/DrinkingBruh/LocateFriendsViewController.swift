//
//  LocateFriendsViewController.swift
//  DrinkingBruh
//
//  Created by Vineeth on 4/16/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

class LocateFriendsViewController: UIViewController {
    
    //MARK: Properties
    var currentEventID:String?
    var friendEmails:[String]?
    var allLocations:[String:[String:Double]]?
    var locations:[MKPointAnnotation]?
    var options:[String]?
    var selectedRow:Int = 0
    //private var themeDict:[String:UIColor] = Theme.getTheme()

    
    //get this user's email
    let userEmail = FIRAuth.auth()?.currentUser?.email?.firebaseSanitize()
        
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var chosenOption: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friend Locator"
        // Do any additional setup after loading the view.
        
        //Set Theme -- doesn't work - mapView covers background
        //self.view.backgroundColor = themeDict["viewColor"]
        
        locations = [MKPointAnnotation]()
        friendEmails = [String]()
        
        //currentEventID = "869E96C8-BFE9-48EA-A54D-11E7C314696A"
        
        if(currentEventID != nil) {
            
            //get the friends attending - variable
            DBHandler.friendsInvited(eventID: currentEventID!) { (invitees) -> () in
                //print(invitees)
                for invitee in invitees {
                    if(invitee.value == "attending" || invitee.value == "hosting") {
                        self.friendEmails?.append(invitee.key)
                    }
                }
                
                //get locations of all users
                DBHandler.getAllUsersLocations() { (allUsersLocation) -> () in
                    
                    if(allUsersLocation != nil) {
                        self.allLocations = allUsersLocation
                        //print(self.allLocations ?? " ")
                        
                        self.options = [String]()
                        self.options?.append("Show Everyone")
                        
                        self.setNamesAndLocations()

                    }
                    
                }
                
            }
            
        }
        
        //show this user on map if location services are enabled
        if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            
            self.mapView.showsUserLocation = true
        }
        
        mapView.showsCompass = true;
        mapView.showsTraffic = true;
        
        self.createPicker()
        self.createToolbar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //may need this to fetch new data here when the user navigates to this screen again
        //things that could change - everything except event ownership
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNamesAndLocations() {
        
        if (self.friendEmails != nil) {
            
            //if this user is on the friends list - do not add to participant names, locations
            //get locations for the friends create MKPointAnnotations and update locations array
            //get full name of the people and add to eventParticipantNames
            for friendEmail in self.friendEmails! {
                if(self.userEmail! != friendEmail) {
                    
                    DBHandler.getUserInfo(userEmail: friendEmail) { (user) -> () in
                        let fullName:String = user["fullName"] as! String
                        self.options?.append(fullName)
                        
                        let lat:Double = (self.allLocations?[friendEmail]?["latitude"])!
                        let long:Double = (self.allLocations?[friendEmail]?["longitude"])!
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate.latitude = lat
                        annotation.coordinate.longitude = long
                        annotation.title = fullName
                        
                        self.locations?.append(annotation)
                        //print(self.friendEmails ?? " ")
                        //print(self.eventParticipantsNames ?? " ")
                        
                    }
                }
                
            }
        }
        
    }
    
    func createPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        
        chosenOption.inputView = picker
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(LocateFriendsViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        chosenOption.inputAccessoryView = toolBar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        
        //show the latest known location of the participant the user chooses
        // or all the participants
        
        if (selectedRow == 0) {
            mapView.showAnnotations(locations!, animated: true)
        }
        else {
            mapView.removeAnnotations(locations!)
            let annotation = locations![selectedRow - 1]
            var one = [MKPointAnnotation]()
            one.append(annotation)
            mapView.showAnnotations(one, animated: true)
            mapView.selectAnnotation(one.first!, animated: true)
        }
    }
    
}

extension LocateFriendsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (options?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        chosenOption.text = options?[row]
        selectedRow = row
    }
}

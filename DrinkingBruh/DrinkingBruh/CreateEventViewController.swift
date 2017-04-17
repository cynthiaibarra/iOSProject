//
//  CreateEventViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/30/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseStorage
import GooglePlaces
import GoogleMaps
import GooglePlacePicker

class CreateEventViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var eventTitleTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var eventStartTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var eventEndTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var locationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var createEventButton: UIButton!
    
    private let storageRef = FIRStorage.storage().reference()
    private let datePicker:UIDatePicker = UIDatePicker()
    private let dateFormatter:DateFormatter = DateFormatter()
    private let imagePicker:UIImagePickerController = UIImagePickerController()
    private var eventImage:UIImage?
    private var placesClient:GMSPlacesClient = GMSPlacesClient.shared()
    
    var eventID:String = ""
    var longitude:CLLocationDegrees = 0.0
    var latitude:CLLocationDegrees = 0.0
    var eventTitle:String?
    var eventStart:String?
    var eventEnd:String?
    var eventAddress:String?
    var eventLocation:String?
    var invitees:[String:String]?
    var imageID:String?
    
    var edit:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.isEnabled = false
        initDelegates()
        initViews()
        if !edit {
            eventID = UUID().uuidString
        }
        if edit {
            self.imageView.image = nil
            DBHandler.getImage(imageID: imageID!) { (image) -> () in
                self.imageView.image = image
            }
            createEventButton.setTitle("Save Changes", for: .normal)
            self.title = "Edit Event"
            print(eventID)
            eventTitleTextField.text = eventTitle!
            eventStartTextField.text = eventStart!
            eventEndTextField.text = eventEnd!
            addressTextField.text = eventAddress!
            locationTextField.text = eventLocation!
        }
        createEventButton.addTarget(self, action: #selector(CreateEventViewController.save(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker){
        let date:String = dateFormatter.string (from: sender.date)
        
        if eventStartTextField.editingOrSelected {
            eventStartTextField.text = date
        } else {
            eventEndTextField.text = date
        }
    }
    
    @objc private func chooseDateAndTime(_ sender: SkyFloatingLabelTextField) {
        sender.inputView = datePicker
        if eventStartTextField.editingOrSelected {
            datePicker.minimumDate = Date()
        } else if !(eventStartTextField.text?.isEmpty)! {
            datePicker.minimumDate = dateFormatter.date(from: eventStartTextField.text!)
        }
        
    }
    
    @IBAction func chooseLocation(_ sender: UIButton) {
        let center = CLLocationCoordinate2D(latitude: 30.267876, longitude: -97.740295)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: { (place, error) in
            if let error = error {
                print("Pick Place error: \(error)")
                return
            }
            
            guard let place = place else {
                print("No place selected")
                return
            }
            
            self.locationTextField.text = place.name
            self.addressTextField.text = place.formattedAddress
            
            self.longitude = place.coordinate.longitude
            self.latitude = place.coordinate.latitude
        })
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func save(_ sender: UIButton) {
        let incomplete:Bool = (eventEndTextField.text?.isEmpty)! || (eventStartTextField.text?.isEmpty)! || (eventTitleTextField.text?.isEmpty)! || (locationTextField.text?.isEmpty)!
        
        if (eventTitleTextField.text?.isEmpty)! {
            eventTitleTextField.shake()
        }
        if (eventStartTextField.text?.isEmpty)! {
            eventStartTextField.shake()
        }
        if (eventEndTextField.text?.isEmpty)! {
            eventEndTextField.shake()
        }
        if (locationTextField.text?.isEmpty)! {
            locationTextField.shake()
            addressTextField.shake()
        }
        
        if incomplete { return }
        if !edit {
            imageID = UUID().uuidString
        }
        let eventImageRef = storageRef.child(imageID!)
        let data = UIImageJPEGRepresentation(imageView.image!, 0.3)
        let uploadTask = eventImageRef.put(data!)
        
        let title:String = self.eventTitleTextField.text!
        let start:String = self.eventStartTextField.text!
        let end:String = self.eventEndTextField.text!
        let location:String = self.locationTextField.text!
        let address:String = self.addressTextField.text!
        
        if !edit {
            DBHandler.createEvent(eventID: eventID, title: title, start: start, end: end, location: location, address: address, imageID: imageID!, longitude: self.longitude, latitude: self.latitude)
        } else {
            DBHandler.editEvent(eventID: eventID, title: title, start: start, end: end, location: location, address: address, imageID: imageID!, longitude: self.longitude, latitude: self.latitude, invitees: self.invitees!)
        }

        NotificationManager.eventNotification(date: start, eventTitle: title)
       
        performSegue(withIdentifier: "segueToInviteFriends", sender: nil)
  
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func initDelegates() {
        eventTitleTextField.delegate = self
        eventStartTextField.delegate = self
        eventEndTextField.delegate = self
        locationTextField.delegate = self
        imagePicker.delegate = self
    }
    
    private func initViews() {
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "EEEE, MMM d yyyy, hh:mm a"
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        eventStartTextField.addTarget(self, action: #selector(CreateEventViewController.chooseDateAndTime(_:)), for: .editingDidBegin)
        eventEndTextField.addTarget(self, action: #selector(CreateEventViewController.chooseDateAndTime(_:)), for: .editingDidBegin)
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.addTarget(self, action: #selector(CreateEventViewController.datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.eventImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
        imageView.image = self.eventImage
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToInviteFriends" {
            if let inviteFriendsVC = segue.destination as? InviteFriendsTableViewController {
                inviteFriendsVC.eventID = self.eventID
                inviteFriendsVC.invitees = invitees
                inviteFriendsVC.edit = edit
            }
        }
    }

}

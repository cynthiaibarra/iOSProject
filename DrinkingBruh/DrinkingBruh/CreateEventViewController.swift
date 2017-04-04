//
//  CreateEventViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/30/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseDatabase
import FirebaseAuth
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
    
    
    private let userEmail = FIRAuth.auth()?.currentUser?.email?.replacingOccurrences(of: ".", with: "\\_")
    private let storageRef = FIRStorage.storage().reference()
    private let dbRef = FIRDatabase.database().reference().child("users")
    private let datePicker:UIDatePicker = UIDatePicker()
    private let dateFormatter:DateFormatter = DateFormatter()
    private let imagePicker:UIImagePickerController = UIImagePickerController()
    private var eventImage:UIImage?
    private var placesClient:GMSPlacesClient = GMSPlacesClient.shared()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.isEnabled = false
        initDelegates()
        initViews()
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
            
            print("Place name \(place.name)")
            print("Place address \(place.formattedAddress)")
            print("Place attributions \(place.attributions)")
        })
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createEventButton(_ sender: UIButton) {
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
        let imageName = UUID().uuidString
        let eventUUID = UUID().uuidString
        let eventImageRef = storageRef.child(imageName)
        let data = UIImageJPEGRepresentation(imageView.image!, 0.7)
        let uploadTask = eventImageRef.put(data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                if error != nil {
                    print(error?.localizedDescription ?? "error: image upload")
                }
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
            self.dbRef.child("events").child(eventUUID).child("imageURL").setValue(downloadURL)
            
           
        }
        
        let title:String = self.eventTitleTextField.text!
        let start:String = self.eventStartTextField.text!
        let end:String = self.eventEndTextField.text!
        let location = self.locationTextField.text!
        let address = self.addressTextField.text!
        
        dbRef.child("events").child(eventUUID).setValue(["title":title, "start":start, "end":end, "location":location, "address":address])
        
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
        dateFormatter.dateFormat = "EEEE, MMM d yyyy, hh:mm a zz"
        
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

}

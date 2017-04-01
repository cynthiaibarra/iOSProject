//
//  CreateEventViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 3/30/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseStorage

class CreateEventViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var eventTitleTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var eventStartTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var eventEndTextField: SkyFloatingLabelTextField!
    
    private let datePicker:UIDatePicker = UIDatePicker()
    private let dateFormatter:DateFormatter = DateFormatter()
    private let imagePicker:UIImagePickerController = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.image = image
        
        dismiss(animated:true, completion: nil) //5
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }

}

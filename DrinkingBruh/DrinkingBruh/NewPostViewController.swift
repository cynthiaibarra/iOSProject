//
//  NewPostViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/27/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postTextEditor: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var eventID:String = ""
    private let imagePicker:UIImagePickerController = UIImagePickerController()
    private var themeDict:[String:UIColor] = Theme.getTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Post"
        
        //Set Theme
        self.view.backgroundColor = themeDict["viewColor"]
        let theme = Config.theme()
        
        if(theme == "dark") {
            self.postTextEditor.backgroundColor = UIColor(hex:0x62B1F6)
        }
        else {
            self.postTextEditor.backgroundColor = UIColor(hex:0x205691)
        }
        
        //Make textview corners round
            self.postTextEditor.layer.cornerRadius = 15
        
        //postTextEditor.delegate = self
        postTextEditor.becomeFirstResponder()
        indicatorView.hidesWhenStopped = true
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButton(_ sender: UIButton) {
        indicatorView.startAnimating()
        sender.isHidden = true
        var image:UIImage? = nil
        if postImageView.image != nil {
            image = postImageView.image!.resize(toWidth: 400.0)
        }
        
        DBHandler.newPost(eventID: eventID, image: image , content: postTextEditor.text) { (status) -> () in
            if status == "success" {
                _  = self.navigationController?.popViewController(animated: true)
            }
        }
    }
  
    @IBAction func uploadPhotoButton(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.postImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage //2
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

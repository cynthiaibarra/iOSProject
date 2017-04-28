//
//  NewPostViewController.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/27/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var postTextEditor: UITextView!
    
    var eventID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //postTextEditor.delegate = self
        postTextEditor.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButton(_ sender: UIButton) {
        DBHandler.newPost(eventID: eventID, content: postTextEditor.text) { (status) -> () in
            if status == "success" {
                _  = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        placeholdeerLabel.isHidden = !textView.text.isEmpty
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        postTextEditor.setContentOffset(CGPoint.zero, animated: false)
 //   }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

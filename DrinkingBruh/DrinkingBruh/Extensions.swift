//
//  Extensions.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/6/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

public extension String {
    func firebaseSanitize() -> String {
        return self.replacingOccurrences(of: ".", with: "\\_")
    }
}

public extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}

public extension String
{
    func replaceFirstOccurrenceOfString(
        targetString: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: targetString) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}
    
public extension UIImage {
    func resize(toWidth width: Double) -> UIImage? {
        let scale:Double = width / Double(size.width)
        let newHeight:Double = Double(size.height) * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
        draw(in: CGRect(x: 0.0, y: 0.0, width: width, height: newHeight))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class TableViewHelper {
    
    static func emptyMessage(message:String, viewController:UIViewController, tableView:UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20.0)
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel;
 
    }
    
    static func clearMessage(tableView:UITableView) {
        tableView.backgroundView = nil
    }
}

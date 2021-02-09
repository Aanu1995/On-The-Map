//
//  HelperFunction.swift
//  On The Map
//
//  Created by user on 04/02/2021.
//

import Foundation
import UIKit

protocol HelperFunction {
    
}

extension HelperFunction {
    
    func errorMessageDisplay(title: String, message: ErrorMessage) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    func errorMessage(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    // Required to configure the navigation bar in both Map View and Tabbed Table View
    
    func configureNavBar(navigationItem: UINavigationItem, logoutSelector: Selector, locationSelector: Selector, refreshSelector: Selector){
        
        // set the navigation bar title
        navigationItem.title = "On the Map"
        
        // set the left button item
        let logoutButton = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [
           .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
        ]
        logoutButton.setAttributedTitle(NSAttributedString(string: "LOGOUT", attributes: attributes), for: .normal)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        logoutButton.addTarget(self, action: logoutSelector, for: .touchUpInside)
        
        // add left button to navigation bar items
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        // set the right button items
        let addLocationButton = UIButton(type: .system)
        addLocationButton.setImage(UIImage(named: "icon_addpin"), for: .normal)
        addLocationButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        addLocationButton.addTarget(self, action: locationSelector, for: .touchUpInside)
        
        let refreshButton = UIButton(type: .system)
        refreshButton.setImage(UIImage(named: "icon_refresh"), for: .normal)
        refreshButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        refreshButton.addTarget(self, action: refreshSelector, for: .touchUpInside)
        
        // Add the two right buttons to navigation bar item
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addLocationButton), UIBarButtonItem(customView: refreshButton)]
    }
    
}

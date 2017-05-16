//
//  UIViewController.swift
//  WhatWearToday
//
//  Created by jlcardosa on 02/01/2017.
//  Copyright © 2017 Cardosa. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

extension UIViewController {
	
    func sendScreenView(name: String) {
        FIRAnalytics.logEvent(withName: "screenview", parameters: [
            "screen_name":name
            ])
	}
	
	func trackEvent(category: String, action: String, label: String, value: NSNumber) {
        
        FIRAnalytics.logEvent(withName: category, parameters: [
            "action": action,
            "label": label,
            "value": value
            ])
	}
}

//
//  ViewController.swift
//  SwiftSample
//
//  Created by Sven Herzberg on 18.10.19.
//

import AditionAdsLib
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var aditionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let version = AdsView.sdkVersionNumber() {
            aditionLabel.text = "Using Adition SDK v\(version)"
        } else {
            aditionLabel.text = "Adition SDK not found"
        }
    }


}


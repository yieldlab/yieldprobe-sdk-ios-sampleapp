//
//  ViewController.swift
//  SwiftSample
//
//  Created by Sven Herzberg on 18.10.19.
//

import AditionAdsLib
import UIKit
import Yieldprobe

class ViewController: UIViewController {
    
    @IBOutlet var aditionLabel: UILabel!
    
    let yieldprobe = Yieldprobe.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let version = AdsView.sdkVersionNumber() {
            aditionLabel.text = "Using Adition SDK v\(version)"
        } else {
            aditionLabel.text = "Adition SDK not found"
        }
    }
    
    func handle (error: Error) {
        print("An error occurred: \(error)")
        print("It might be a good idea to request another ad after ~10s.")
    }
    
    var pendingAdView: AdsView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        yieldprobe.probe(slot: 6846238, queue: .main) { result in
            do {
                // AditionAdsLib expects String or null only.
                let bid = try result.get()
                let targeting = try bid.customTargeting()
                    .mapValues(String.init(describing:))
                
                let view = AdsView(inlineWithFrame: CGRect(origin: .zero,
                                                           size: CGSize(width: 300,
                                                                        height: 250)),
                                   delegate: self)
                try view?.targeting.mergeProfileTargeting(with: targeting)
                try view?.loadCreative(fromNetwork: "99", withContentUnitID: "4493233")
                self.pendingAdView = view
                print("loading…")
            } catch {
                self.handle(error: error)
            }
        }
    }
    
}

extension ViewController: AdsViewDelegate {
    
    func adFinishedCaching (_ inAdsView: AdsView!, withSuccessOrError inError: Error!) {
        if let error = inError {
            pendingAdView = nil
            return handle(error: error)
        }
        
        fatalError("Unimplemented.")
    }
    
}

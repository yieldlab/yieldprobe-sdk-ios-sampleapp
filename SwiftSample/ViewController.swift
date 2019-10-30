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

    // MARK: - Yieldprobe Configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let configuration = Configuration(extraTargeting: ["age": "27"])
        yieldprobe.configure(using: configuration)

        if let version = AdsView.sdkVersionNumber() {
            aditionLabel.text = "Using Adition SDK v\(version)"
        } else {
            aditionLabel.text = "Adition SDK not found"
        }
    }
    
    func handle (error: Error) {
        let vc = UIAlertController(title: error.localizedDescription,
                                   message: "It might be a good idea to request another ad after ~10s.",
                                   preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Close", style: .default))
        present(vc, animated: true)
    }
    
    var pendingAdView: AdsView?
    
    // MARK: - Yieldprobe Request
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        yieldprobe.probe(slot: 6846238, queue: .main, completionHandler: onResult(_:))
    }
    
    // MARK: - Yieldprobe Response
    func onResult (_ result: Result<Bid,Error>) {
        do {
            let bid = try result.get()
            
            // AditionAdsLib expects String or null only.
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

extension ViewController: AdsViewDelegate {
    
    func adFinishedCaching (_ inAdsView: AdsView!, withSuccessOrError inError: Error!) {
        if let error = inError {
            pendingAdView = nil
            return handle(error: error)
        }
        
        inAdsView.translatesAutoresizingMaskIntoConstraints = false
        inAdsView.widthAnchor.constraint(equalToConstant: inAdsView.bounds.width).isActive = true
        inAdsView.heightAnchor.constraint(equalToConstant: inAdsView.bounds.height).isActive = true

        view.addSubview(inAdsView)
        view.centerXAnchor.constraint(equalTo: inAdsView.centerXAnchor).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: inAdsView.bottomAnchor).isActive = true
    }
    
}

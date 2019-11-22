//
//  OnboardViewController.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/18/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var instructorImage: UIImageView!
    @IBOutlet weak var lookingForClasses: UIButton! {
        didSet {
            lookingForClasses.layer.cornerRadius = 25
            lookingForClasses.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var coachingTheClasses: UIButton! {
        didSet {
            coachingTheClasses.layer.cornerRadius = 25
            coachingTheClasses.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(identifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
}



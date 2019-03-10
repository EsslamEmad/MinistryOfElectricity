//
//  HomeViewController.swift
//  MinistryOfElectricity
//
//  Created by Esslam Emad on 2/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 15.0
        aboutUsButton.clipsToBounds = true
        aboutUsButton.layer.cornerRadius = 15.0
        signOutButton.clipsToBounds = true
        signOutButton.layer.cornerRadius = 15.0
    }
    

    @IBAction func didPressSignOut(_ sender: UIButton){
        let alert = UIAlertController(title: "تسجيل الخروج", message: "هل أنت متأكد من رغبتك في تسجيل الخروج؟", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "نعم", style: .default, handler: {(UIAlertAction) in
            Auth.auth.user = nil
            self.performSegue(withIdentifier: "back to login", sender: nil)
        })
        let noAction = UIAlertAction(title: "لا", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }

}

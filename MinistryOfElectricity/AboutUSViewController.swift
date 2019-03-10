//
//  AboutUSViewController.swift
//  MinistryOfElectricity
//
//  Created by Esslam Emad on 2/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class AboutUSViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 20.0
        
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.aboutUS)
            }.done {
                let page = try! JSONDecoder().decode(Page.self, from: $0)
                self.title = page.title
                self.titleLabel.text = page.subtitle
                self.contentLabel.text = page.content
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    

   

}

//
//  LoginViewController.swift
//  MinistryOfElectricity
//
//  Created by Esslam Emad on 2/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PromiseKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 15.0
        containerView.layer.cornerRadius = 20.0
        containerView.clipsToBounds = true
        emailTF.textAlignment = .right
        passwordTF.textAlignment = .right
    }
    
    

    @IBAction func didPressLogin(_ sender: UIButton){
        guard let email = emailTF.text, let password = passwordTF.text, password != "" else {
            self.showAlert(withMessage: "يرجى إدخال بيانات تسجيل الدخول.")
            return
        }
        guard email.isEmail() else {
            self.showAlert(withMessage: "البريد الإلكتروني اللذي قمت بإدخاله خاطئ")
            return
        }
        
        SVProgressHUD.show()
        firstly{
            API.CallApi(APIRequests.login(email: email, password: password))
            }.done {
                Auth.auth.user = try! JSONDecoder().decode(User.self, from: $0)
                self.performSegue(withIdentifier: "show home", sender: nil)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }

    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
    }
    
}


extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    
}

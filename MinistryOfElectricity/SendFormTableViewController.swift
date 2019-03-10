//
//  SendFormTableViewController.swift
//  MinistryOfElectricity
//
//  Created by Esslam Emad on 2/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import GoogleMaps
import SkyFloatingLabelTextField
import PromiseKit
import SVProgressHUD

class SendFormTableViewController: UITableViewController, GMSMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var images = [UIImage]()
    var isLocationPicked = false
    var form = Form()

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var nameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var subjectTF: SkyFloatingLabelTextField!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 15.0
        collectionView.delegate = self
        collectionView.dataSource = self
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.camera = GMSCameraPosition.camera(withLatitude: 24.7254, longitude: 47.383, zoom: 6.0)
        mapView.accessibilityElementsHidden = false
        mapView.settings.myLocationButton = true
        messageTV.clipsToBounds = true
        messageTV.layer.cornerRadius = 20.0
        messageTV.layer.borderColor = UIColor.darkGray.cgColor
        messageTV.layer.borderWidth = 1.0
        collectionView.backgroundColor = .clear
    }

    

    @IBAction func didPressSend(_ sender: UIButton){
        guard let name = nameTF.text, let subject = subjectTF.text, let message = messageTV.text, name != "", subject != "", message != "", isLocationPicked else {
            self.showAlert(withMessage: "من فضلك أدخل جميع بياناتك")
            return
        }
        form.name = name
        form.subject = subject
        form.message = message
        self.sendButton.isEnabled = false
        if images.count > 0 {
            var completedImages = 0
            form.photos = [String]()
            SVProgressHUD.show()
        for image in images {
            firstly{
                return API.CallApi(APIRequests.upload(image: image))
                }.done {
                    let resp = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                    self.form.photos.append(resp.image)
                    completedImages += 1
                }.catch {
                    self.showAlert(withMessage: $0.localizedDescription)
                    SVProgressHUD.dismiss()
                    return
                }.finally {
                    if completedImages == self.images.count {
                        SVProgressHUD.dismiss()
                        self.sendForm()
                    }
            }
        }
        } else {
            sendForm()
        }
    }
    
    func sendForm() {
        SVProgressHUD.show()
        form.userID = Auth.auth.user!.id
        firstly{
            return API.CallApi(APIRequests.sendForm(form: form))
            }.done {
                let resp = try! JSONDecoder().decode(MessageResponse.self, from: $0)
                self.showAlert(error: false, withMessage: resp.message, completion: {(UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.sendButton.isEnabled = true
        }
    }
    
    //mark: collectionView Protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    //image picker gesture
    
    @IBAction func PickImage(recognizer: UITapGestureRecognizer) {
        
        guard images.count < 4 else {
            self.showAlert(withMessage: "لا يمكنك إضافة المزيد من الصور")
             return
        }
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("اختر طريقة رفع الصورة.", comment: ""), preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("الكاميرا", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى الكاميرا الخاصة بك", comment: ""))
            }
        })
        let photoAction = UIAlertAction(title: NSLocalizedString("مكتبة الصور", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى مكتبة الصور الخاصة بك", comment: ""))
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    var ImagePicked = false
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            images.append(selectedImage)
            collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //google maps
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.clear()
        marker.map = mapView
        mapView.selectedMarker = marker
        isLocationPicked = true
        form.latitude = Double(coordinate.latitude)
        form.longitude = Double(coordinate.longitude)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

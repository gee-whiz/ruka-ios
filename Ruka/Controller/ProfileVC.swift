//
//  ProfileVC.swift
//  Ruka
//
//  Created by George on 2018/04/05.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import UIKit
import GrowingTextView
import RSKImageCropper


struct DynamicField {
    var title: String!
    var value: String!
    var tag: Int
    var keyType: UIKeyboardType!
    
}

class ProfileVC: UIViewController, UITableViewDelegate,RSKImageCropViewControllerDelegate, UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var imgProfile: CircleImage!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMenu: UIButton!
     var activityIndicator = UIActivityIndicatorView()
    var user  = [User]()
    var data = [DynamicField(title:    "First Name",value: "", tag: 0,keyType: UIKeyboardType.default),
                DynamicField(title:    "Last Name",value: "",tag: 1,keyType: UIKeyboardType.default),
                DynamicField(title:    "Email",value: "",tag: 2,keyType: UIKeyboardType.emailAddress),
                DynamicField(title:    "Phone",value: "",tag: 3,keyType: UIKeyboardType.phonePad),
                DynamicField(title:    "About",value: "", tag: 4, keyType: UIKeyboardType.default )]
    
    var email: String = ""
    var first_name = ""
    var last_name = ""
    var about: String = " "
    var phone: String = ""
     var pfImage:UIImage!
    var profile_image_uri: String = ""
     var imageCropVC = RSKImageCropViewController()
     var picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .gray,  placeInTheCenterOf: view)
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginController.handleTap))
        self.view.addGestureRecognizer(tap)
        self.activityIndicator.startAnimating()
        self.tableView.tableFooterView = UIView()
        self.presenter  = UserPresenter()
        self.presenter?.getProfile()
        self.tableView.rowHeight = 50
        self.tableView.estimatedRowHeight =  50
        self.imageCropVC.delegate = self
        self.picker.delegate = self
        
    }

 
    
    
    var presenter: UserPresenter? {
        didSet {
            presenter?.user.observe {
                [unowned self] (results) in
                self.user = results.count > 0 ? results : []
                if results.count > 0 {
                    self.imgProfile.sd_setImage(with: URL(string: self.user[0].profile_image_uri), placeholderImage: UIImage(named: "avatar_placeholder"))
                    self.profile_image_uri =  self.user[0].profile_image_uri
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:  LOGGED_IN_KEY),object: nil)
                    self.imgProfile.setNeedsLayout()
                       self.data = [DynamicField(title:    "First Name",value: self.user[0].first_name,tag: 0,keyType: UIKeyboardType.default),
                                    DynamicField(title:    "Last Name",value: self.user[0].last_name,tag: 1,keyType: UIKeyboardType.default),
                                    DynamicField(title:    "Email",value: self.user[0].email,tag: 2,keyType: UIKeyboardType.default),
                                    DynamicField(title:    "Phone",value: self.user[0].phone,tag: 3,keyType: UIKeyboardType.phonePad),
                                    DynamicField(title:    "About",value: self.user[0].about,tag: 4,keyType: UIKeyboardType.default)]
                }
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.btnDone.loadingIndicator(show: false)
                self.btnDone.setTitle("Edit", for: .normal)
            }
            presenter?.errorMsg.observe { (error) in
                self.view.setNeedsLayout()
                if error.count > 0 {
                    self.activityIndicator.stopAnimating()
                    self.btnDone.loadingIndicator(show: false)
                    self.btnDone.setTitle("Done", for: .normal)
                }
                
            }
            
            presenter?.profilePicUrl.observe({ (url) in
                if url.count > 0 {
                    self.profile_image_uri = url
                    self.presenter?.updateUser(email:  self.data[2].value , first_name:  self.data[0].value , last_name:  self.data[1].value , about: self.data[4].value , phone:  self.data[3].value , profile_image_uri: url)
                }
                
            })
            
            presenter?.updateMsg.observe { (msg) in
                self.view.setNeedsLayout()
                if msg.count > 0 {
                    self.btnDone.loadingIndicator(show: false)
                    self.btnDone.setTitle("Edit", for: .normal)
                    self.showMessage(msg, type: .success)
                }
            }
            
            
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return  4
        }else{
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  60
        }
        return  100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            let item = self.data[indexPath.row]
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.edtText.delegate = self
            cell.edtText.tag  = item.tag
            cell.lblTitle.text = item.title
            cell.edtText.text = item.value
            cell.edtText.AddIcon(direction: .Right, imageName: "icon_edit", Frame: frame, backgroundColor: .clear)
            cell.edtText.keyboardType  = item.keyType
             return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileAboutCell", for: indexPath) as! ProfileCell
            let item = self.data[4]
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.edtAbout.delegate = self
            cell.edtAbout.tag  = item.tag
            cell.lblTitle.text = item.title
            cell.edtAbout.text  = item.value
            cell.edtAbout.keyboardType = item.keyType
             return cell
        }
    }
    
    @IBAction func btnCamera(_ sender: Any) {
        self.showActionSheet()
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        if btnDone.titleLabel?.text == "Done" {
             self.view.endEditing(true)
            self.presenter?.updateUser(email:  self.data[2].value , first_name:  self.data[0].value , last_name:  self.data[1].value , about: self.data[4].value , phone:  self.data[3].value , profile_image_uri: self.profile_image_uri)
            self.btnDone.setTitle("", for: .normal)
            self.btnDone.loadingIndicator(show: true)
            self.activityIndicator.startAnimating()
            self.resignFirstResponder()
        }else{
            let allTextField = getTextfield(view: self.view)
            for txtField in allTextField{
                if txtField.tag == 0 {
                    txtField.becomeFirstResponder()
                }
            }
        }
    }
    
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ =  textField
        debugPrint(textField.tag)
            if textField.tag  == 0  {
                self.data[0].value = textField.text!
            }else if textField.tag == 1 {
                self.data[1].value   = textField.text!
            }else if textField.tag  == 2 {
                 self.data[2].value   = textField.text!
            }else if textField.tag  == 3 {
                self.data[3].value   = textField.text!
            }
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
          _ = textView as! GrowingTextView
           self.data[4].value   = textView.text!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.btnDone.setTitle("Done", for: .normal)
        self.btnDone.isEnabled   = true
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor  = UIColor.black
        self.btnDone.setTitle("Done", for: .normal)
        self.btnDone.isEnabled   = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let nextField = textField.superview?.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @objc func handleTap(){
        self.view.endEditing(true)
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.imageCropVC.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.pfImage = croppedImage
        let data = self.pfImage.jpegData(compressionQuality: 0.5)! as NSData
        self.saveImage(image: data)
        self.btnDone.isEnabled   = true
        self.imageCropVC.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(image: NSData ) {
        self.activityIndicator.startAnimating()
        self.presenter?.updateProfilePic(imageData: image as Data)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let  cropImage =  info[UIImagePickerController.InfoKey.originalImage]
        self.imageCropVC.originalImage  = cropImage as! UIImage
        self.picker.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(self.imageCropVC, animated: false, completion: nil)
        }
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet() {
        let  actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .camera
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.present(self.picker, animated: true, completion: nil)
        })
        let LibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(LibraryAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

}

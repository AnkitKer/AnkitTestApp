
//  AddProductVC.swift
//  AnkitTestApp
//
//  Created by apple on 21/07/2023.

import UIKit
import Firebase
import MBProgressHUD
import FirebaseStorage
import FirebaseStorage
import FirebaseDatabase

class AddProductVC: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtProductPrice: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    var isImageSelected = false
    var ref: DatabaseReference!
    var imagePicker = UIImagePickerController()
    var datePicker = UIDatePicker()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.imgProduct.layer.cornerRadius = 12.0
         imagePicker.delegate = self
         ref = Database.database().reference()
         txtProductName.attributedPlaceholder = NSAttributedString(string: "Product Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
         txtProductPrice.attributedPlaceholder = NSAttributedString(string: "Product Price", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
         txtDate.attributedPlaceholder = NSAttributedString(string: "Date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        self.navigationController?.isNavigationBarHidden = true

          if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        
        
        self.txtDate.delegate = self
        self.showDatePicker()
        
    }
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.txtProductName.text = ""
        self.txtProductPrice.text = ""
        self.txtDate.text = ""
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        txtDate.inputAccessoryView = toolbar
        // add datepicker to textField
        txtDate.inputView = datePicker
    }
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDate.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    //MARK: - Validate Textfiled
     func IsValidationPerform() -> Bool {
         if(txtProductName.text!.trimmingCharacters(in: .whitespaces) == ""){
             self.globleAlertWithMessage(strMessage: "Please Enter Product name")
             return false
         }
         else if(txtProductPrice.text!.trimmingCharacters(in: .whitespaces) == ""){
             self.globleAlertWithMessage(strMessage: "Please Enter Product Price")
             return false
             
         }else if(txtDate.text!.trimmingCharacters(in: .whitespaces) == ""){
             self.globleAlertWithMessage(strMessage: "Please Select Date")
             return false
             
         }
         return true
     }
   
    //MARK:- Button Action
    @IBAction func btnSaveAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.IsValidationPerform() {
            
            if Reachability.isConnectedToNetwork(){
                self.storeProductWithDetails()
            }else{
                self.globleAlertWithMessage(strMessage: "Internet Connection not Available!")
            }
        }
    }
    @IBAction func btnAddProductImages(_ sender: UIButton) {
         pickerOpen(sender: sender)
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func pickerOpen(sender : UIButton){
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera(picker: self.imagePicker)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery(picker: self.imagePicker)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera(picker:UIImagePickerController){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            }()
            self.present(alertController, animated: true, completion: nil)
        }
    }
       func openGallery(picker:UIImagePickerController){
           
           picker.sourceType = .photoLibrary
           self.present(picker, animated: true, completion: nil)
       }
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.imgProduct.image = image
            self.isImageSelected = true
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK:- API CALL
    func storeProductWithDetails(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let data = self.imgProduct.image!.jpegData(compressionQuality: 0.5)! as NSData
        
        let sec = Int64(Date().timeIntervalSince1970 * 1000)
        let filePath   = "\(sec).jpg" // path where you wanted to store img in storage
        let metaData   = StorageMetadata()
        let storageRef = Storage.storage().reference().child("Products").child(filePath)
        
        storageRef.putData(data as Data, metadata: metaData){(metaDatas,error) in
            if let error = error {
                
                self.globleAlertWithMessage(strMessage: error.localizedDescription)
        
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }else{
                storageRef.downloadURL(completion: { (url, error) in
                    if(error == nil){
                        let strUrl = url!.absoluteString
                        //SAVE INFORMATION
                        self.saveItem(imageURl:strUrl)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                    }                })
            }
        }
    }
    //MARK: FIREBASE -> SAVE FUNCTION
    func saveItem(imageURl:String){
        
        //GET USER ID
        //CREATE ORDER NODE
        if let userId = UserDefaults.standard.value(forKey: "userID") as? String{
            let userData = self.ref.child("Products").childByAutoId()
            let url = "\(userData)"
            let arrPart = url.components(separatedBy: "/")
            
            let dictData = [
                "product_name"       : self.txtProductName.text!,
                "product_price"      : self.txtProductPrice.text!,
                "image"              : imageURl,
                "date"               : self.txtDate.text!,
                "strproductID"             : userData.key
                ] as [String : Any]
            
            print(dictData)
            userData.setValue(dictData)
            MBProgressHUD.hide(for: self.view, animated: true)
            self.globleAlertWithMessage(strMessage: "Product Added have been Successfully.")
            self.dismiss(animated: true, completion: nil)
        }
    }
}

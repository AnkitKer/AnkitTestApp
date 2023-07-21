//  SignUpVC.swift
//  AnkitTestApp
//
//  Created by apple on 21/07/2023.



import UIKit
import MBProgressHUD
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignUpVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textConfrmPassword: UITextField!
    
    var databaseReference: DatabaseReference!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        databaseReference = Database.database().reference()
        
        textEmail.attributedPlaceholder = NSAttributedString(string: "Email Addrees", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textPassword.attributedPlaceholder = NSAttributedString(string: "Passsword", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textConfrmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Passsword", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      self.textEmail.text = ""
      self.textPassword.text = ""
      self.textConfrmPassword.text = ""
    }
    
       //Mark: - Validate Textfiled
        func validationPerform() -> Bool {
            if(textEmail.text!.trimmingCharacters(in: .whitespaces) == ""){
                self.globleAlertWithMessage(strMessage: "Please Enter Email")
                return false
            }
            else if(!GlobleMethods.sharedInstance.isValidEmail(email: textEmail.text!)){
                self.globleAlertWithMessage(strMessage: "Please Enter Valid Email")
                return false
                
            }else if(textPassword.text!.trimmingCharacters(in: .whitespaces) == ""){
                self.globleAlertWithMessage(strMessage: "Please Enter Password")
                return false
                
            }else if(textConfrmPassword.text!.trimmingCharacters(in: .whitespaces) == ""){
                self.globleAlertWithMessage(strMessage: "Please Enter Confirm Password")
                return false
                
            }else if(self.textPassword.text != self.textConfrmPassword.text){
                self.globleAlertWithMessage(strMessage: "Password and Confirm Password must be same!")
                return false
            }
            return true
        }
    //MARK:- Button Action
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSignUpAction(_ sender: Any){
        self.view.endEditing(true)
        
        if self.validationPerform(){
           
            if Reachability.isConnectedToNetwork(){
                 self.signupData()
            }else{
                self.globleAlertWithMessage(strMessage: "Internet Connection not Available!")
            }
        }
    }
}
//MARK: ==== SIGNUP WITH FIREBASE =======
extension SignUpVC{
    
    func signupData(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().createUser(withEmail: self.textEmail.text!, password: self.textPassword.text!) { (result, error) in
           
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil){ // CREATE SUCCESSFULLY
                
                //FIREBASE USER ID
                let userId = Auth.auth().currentUser?.uid
                
                let arrUserData = [
                    "email"               : self.textEmail.text!,
                    "id"                  : "\(userId!)",
                    "uuid"                : "\(UIDevice.current.identifierForVendor?.uuidString ?? "0")"
                    ] as [String : Any]
                
                //CREATE USER NODE
                let userData = self.databaseReference.child("users").child(userId!)
                userData.setValue(arrUserData)
                print(arrUserData)
                
                let alert = UIAlertController(title: appName, message: "Signup Successfully.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
             
            } else {
                print(error!.localizedDescription)
                MBProgressHUD.hide(for: self.view, animated: true)
           }
        }
    }
}

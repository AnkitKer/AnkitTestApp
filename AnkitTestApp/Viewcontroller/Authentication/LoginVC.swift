
//  LoginVC.swift
//  AnkitTestApp
//
//  Created by apple on 21/07/2023.

//admin@gmail.com
//123

import UIKit
import Firebase
import MBProgressHUD
import FirebaseDatabase
import FirebaseAuth

class LoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textEmail    : UITextField!
    @IBOutlet weak var textPassword : UITextField!
  
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textEmail.text = ""
        self.textPassword.text = ""
        
        textEmail.attributedPlaceholder = NSAttributedString(string: "admin@gmail.com", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textPassword.attributedPlaceholder = NSAttributedString(string: "123456", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
       
    }
    func gotTofoodVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let foodVC = storyboard.instantiateViewController(withIdentifier: "FoodVC") as! FoodVC
        let rootVC = UINavigationController(rootViewController: foodVC)
        rootVC.navigationBar.isHidden = true
        UIApplication.shared.keyWindow?.rootViewController = foodVC
    
    }
    // Validate Textfiled
    func validationPerform() -> Bool {
        if(textEmail.text!.trimmingCharacters(in: .whitespaces) == ""){
            self.globleAlertWithMessage(strMessage: "Please Enter Email")
            return false
        }
        else if(!GlobleMethods.sharedInstance.isValidEmail(email: textEmail.text!)){
            self.globleAlertWithMessage(strMessage: "Please Enter Valid Email")
            return false
        }
        else if(textPassword.text!.trimmingCharacters(in: .whitespaces) == ""){
            self.globleAlertWithMessage(strMessage: "Please Enter Password")
            return false
        }
        return true
    }
    //MARK:- Button Action
    @IBAction func btnLoginAction(_ sender: Any) {
        self.view.endEditing(true)
        if self.validationPerform() {
            
            if(Reachability.isConnectedToNetwork()){
                self.getLoginWithFirebase()
            }else{
                self.globleAlertWithMessage(strMessage: "Internet Connection not Available!")
            }
        }
    }
    @IBAction func btnSignUpAction(_ sender: Any) {
          
        let cnt = storyboard?.instantiateViewController(withIdentifier: "SignUpVC")as! SignUpVC
        self.navigationController?.pushViewController(cnt, animated: true)
    }
    @IBAction func btnSkipAction(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "guest")
        self.gotTofoodVC()
    }
    //MARK:- API CALLING
    func getLoginWithFirebase() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().signIn(withEmail: self.textEmail.text!, password: self.textPassword.text!) { (user, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil){ // SUCCESSFULLY LOGIN
                
                // SAVE USER ID IN DEFAULT
                let userId = Auth.auth().currentUser?.uid
                
                if (self.textEmail.text == "admin@gmail.com" as! String){
                    
                    UserDefaults.standard.set(true, forKey: "admin")
                }else{
                    UserDefaults.standard.set(false, forKey: "admin")
                }
        
                UserDefaults.standard.set(true, forKey: "IS_LOGIN")
                //UserDefaults.standard.setValue(userId, forKey: "userID")
            
                MBProgressHUD.hide(for: self.view, animated: true)
                self.gotTofoodVC()
            } else {
                 MBProgressHUD.hide(for: self.view, animated: true)
                self.globleAlertWithMessage(strMessage: error!.localizedDescription)
                //GlobleMethods.sharedInstance.globleAlertWithMessage(strMessage: <#T##String#>)(title: appName, msg: error!.localizedDescription)
            }
        }
    }
}

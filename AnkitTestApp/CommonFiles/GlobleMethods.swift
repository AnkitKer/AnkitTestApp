//
//  Extenstion.swift
//  AnkitTestApp
//
//  Created by apple on 21/07/2023.
//

import UIKit

class GlobleMethods: NSObject {

    static var sharedInstance =  GlobleMethods()
    

    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
extension UIViewController{
    
    func globleAlertWithMessage(strMessage:String){
        
        let alert = UIAlertController(title: appName, message: strMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

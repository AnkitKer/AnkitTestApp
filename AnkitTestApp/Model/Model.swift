//
//  Model.swift
//  AnkitTestApp
//
//  Created by apple on 21/07/2023.
//

import UIKit

    struct ModelFoodList{
        
        var product_name = ""
        var product_price = ""
        var date = ""
        var image  = ""
        var strproductID  = ""
        
        init(dict:NSDictionary){
            
            self.product_name =  dict.value(forKey: "product_name")as? String ?? "NA"
            self.product_price =  dict.value(forKey: "product_price")as? String ?? "NA"
            self.date =  dict.value(forKey: "date")as? String ?? "NA"
            self.image =  dict.value(forKey: "image")as? String ?? "NA"
            self.strproductID =  dict.value(forKey: "strproductID")as? String ?? "NA"
        }
        
    }
    

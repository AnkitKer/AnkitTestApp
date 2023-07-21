//
//  FoodVC.swift
//  AnkitTestApp
//
//  Created by apple on 21/07/2023.
//

import UIKit
import Firebase
import MBProgressHUD
import SDWebImage

class FoodVC: UIViewController {

    @IBOutlet weak var tblFoodData: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var arrFoodData = [ModelFoodList]()
    var databse : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        databse = Database.database().reference()
    }
    override func viewWillAppear(_ animated: Bool) {
      
        self.tblFoodData.register(UINib(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "FoodCell")
        self.tblFoodData.delegate = self
        self.tblFoodData.dataSource = self
        
        if(Reachability.isConnectedToNetwork()){
            self.GetProductList()
        }else{
            self.globleAlertWithMessage(strMessage: "Internet Connection not Available!")
        }
    }
    @IBAction func btnActionAddProduct(_ sender: UIButton) {
        let ctrl =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddProductVC")as! AddProductVC
        ctrl.modalPresentationStyle =  .fullScreen
        self.navigationController?.present(ctrl, animated: true, completion: nil)
        
    }
    @IBAction func btnActionLogout(_ sender: UIButton) {
       let alert = UIAlertController(title: "Alert", message: "Are you Sure You want to Logout", preferredStyle: .alert)
        
        let alertNo  = UIAlertAction(title: "No", style: .destructive, handler: { action in
            
        })
        
        let alertYes = UIAlertAction(title: "Yes", style: .default, handler: { action in
          
           UserDefaults.standard.setValue(nil, forKey: "IS_LOGIN")
           
           let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let rootVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
           let navigation = UINavigationController(rootViewController: rootVC)
           navigation.navigationBar.isHidden = true
           UIApplication.shared.keyWindow?.rootViewController = navigation
       })
            alert.addAction(alertNo)
            alert.addAction(alertYes)
          self.present(alert, animated: true, completion: nil)
       
      }
}
extension FoodVC:UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- UITableView Datasource Or Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFoodData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFoodData.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
        if(self.arrFoodData.count != 0){
            
            cell.imgProduct.sd_setImage(with: URL(string: self.arrFoodData[indexPath.row].image), placeholderImage: #imageLiteral(resourceName: "placeholder"))
           
            cell.imgProduct.layer.cornerRadius = 12.0
            cell.viewMain.layer.cornerRadius  = 12.0
            cell.lblDate.text =  arrFoodData[indexPath.row].date
            cell.lblProductName.text =  arrFoodData[indexPath.row].product_name
            cell.lblProductPrice.text =  "₹ \(arrFoodData[indexPath.row].product_price)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //MARK:- methodForGetProductList
    func GetProductList(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.arrFoodData.removeAll()
        
            self.databse.child("Products").observeSingleEvent(of: .value) { (snapshot) in
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let dicData = snapshot.value as? NSDictionary
                print(dicData!.allValues)
                let newArry  = dicData!.allValues as! NSArray
                
                for i in 0..<newArry.count{
                    
                    let dict  = newArry[i] as! NSDictionary
                    
                    self.arrFoodData.append(ModelFoodList.init(dict: dict))
                }
                
            
                if (self.arrFoodData.count == 0){
                    self.lblMessage.isHidden = false
                }else{
                    self.lblMessage.isHidden = true
                }
                self.tblFoodData.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
       // }
    }
}

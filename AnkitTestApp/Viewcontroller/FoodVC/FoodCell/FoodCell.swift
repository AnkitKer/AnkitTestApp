//
//  FoodCell.swift
//  AnkitTestApp
//
//  Created by apple on 21/07/2023.
//

import UIKit

class FoodCell: UITableViewCell {

    @IBOutlet weak var viewMain : UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

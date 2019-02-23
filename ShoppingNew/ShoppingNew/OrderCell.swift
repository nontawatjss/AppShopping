//
//  OrderCell.swift
//  ShoppingNew
//
//  Created by Nontawat on 31/1/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var amountProduct: UILabel!
    @IBOutlet weak var BTdown: UIButton!
    @IBOutlet weak var BTplus: UIButton!
    @IBOutlet weak var removeOrder: UIButton!
    @IBOutlet weak var imageProduct: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

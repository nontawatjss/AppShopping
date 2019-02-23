//
//  ProductCell.swift
//  ShoppingMedical
//
//  Created by Nontawat on 22/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var ImageCell: UIImageView!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var AmountLabel: UILabel!
    
    @IBOutlet weak var DeleteBT: UIButton!
    
    @IBOutlet weak var PlusBT: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

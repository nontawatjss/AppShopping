//
//  HistoryCell.swift
//  ShoppingNew
//
//  Created by Nontawat on 6/2/2562 BE.
//  Copyright © 2562 com.nontawat. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var Status: UILabel!
    
    @IBOutlet weak var DateOrder: UILabel!
    @IBOutlet weak var AllPrice: UILabel!
    
    @IBOutlet weak var ImgStatus: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

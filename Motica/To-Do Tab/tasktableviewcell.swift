//
//  tasktableviewcell.swift
//  Motica
//
//  Created by Seah Family on 14/1/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit

class tasktableviewcell: UITableViewCell {
    
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtNotes: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

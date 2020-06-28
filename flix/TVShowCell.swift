//
//  TVShowCell.swift
//  flix
//
//  Created by Jonathan Singer on 6/25/20.
//  Copyright © 2020 Jonathan Singer. All rights reserved.
//

import UIKit

class TVShowCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var TVShowSynopsis: UILabel!
    @IBOutlet weak var TVShowTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

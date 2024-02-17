//
//  MessageCell.swift
//  Chat
//
//  Created by Yusuf Bayindir on 2/12/24.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         // Configure the view for the selected state
    }
    
}

//
//  NewsTableViewCell.swift
//  Kiran_PadinhareKUnnoth_FE_8940891
//
//  Created by IS on 2023-12-10.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var newsTitle: UILabel!
    
    
    @IBOutlet weak var newsDescription: UILabel!
    
    
    @IBOutlet weak var newsSource: UILabel!
    
    
    @IBOutlet weak var newsAuthor: UILabel!
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

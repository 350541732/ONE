//
//  ThirdViewCell.swift
//  rxSwiftNodeElm
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class ThirdViewCell: UITableViewCell {

    @IBOutlet weak var catrgroyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var descTextField: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var topLikeLabel: UILabel!
    @IBOutlet weak var bottomLikeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  FirstViewCell.swift
//  rxSwiftNodeElm
//
//  Created by apple on 2018/7/6.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit
import RxSwift

class FirstViewCell: UITableViewCell {

    
    
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var ticAndPicInfo: UILabel!
    @IBOutlet weak var forward: UITextView!
    @IBOutlet weak var wordsInfo: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var bookMarkBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var topLikeNum: UILabel!
    @IBOutlet weak var bottomLikeNum: UILabel!
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        

        
    }
    /*
     注意 prepareForReuse() 方法里的 disposeBag = DisposeBag()
     每次 prepareForReuse() 方法执行时都会初始化一个新的 disposeBag。这是因为 cell 是可以复用的，这样当 cell 每次重用的时候，便会自动释放之前的 disposeBag，从而保证 cell 被重用的时候不会被多次订阅，避免错误发生。
     */
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

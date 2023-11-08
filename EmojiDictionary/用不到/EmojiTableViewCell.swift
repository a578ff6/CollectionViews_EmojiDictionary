//
//  EmojiTableViewCell.swift
//  EmojiDictionary
//
//  Created by 曹家瑋 on 2023/10/9.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {

    
    // 客製化表格元件
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 使用 Emoji 實例 來更新 cell。
    func update(with emoji: Emoji) {
        symbolLabel.text = emoji.symbol
        nameLabel.text = emoji.name
        descriptionLabel.text = emoji.description
    }

}

//
//  CustomCell.swift
//  AkiosTask17
//
//  Created by Nekokichi on 2020/09/05.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var checkItemImage: UIImageView!
    @IBOutlet weak var checkItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(checkItem: CheckItemModel) {
        //チェックマークの画像を表示
        if checkItem.isChecked {
            checkItemImage.image = UIImage(systemName: "checkmark")
        } else {
            checkItemImage.image = UIImage(systemName: "")
        }
        //チェックリストのテキストを表示
        checkItemLabel.text = checkItem.title
    }
    
}

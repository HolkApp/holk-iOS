//
//  InsuranceTableViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var hintValueLabel: UILabel!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var ideaValueLabel: UILabel!
    @IBOutlet private weak var ideaLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        logoImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        layer.cornerRadius = 6
    }
    
    func configureCell() {
        logoImageView.image = UIImage(named: "Insurance")
    }
}

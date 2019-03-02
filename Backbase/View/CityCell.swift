//
//  CityCell.swift
//  Backbase
//
//  Created by Paulo Correa on 02/03/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    var cityViewModel: CityViewModel! {
        didSet {
            textLabel?.text = cityViewModel.title
            detailTextLabel?.text = cityViewModel.subtitle
            accessoryType = .detailDisclosureButton
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

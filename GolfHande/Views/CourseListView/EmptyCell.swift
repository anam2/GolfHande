//
//  EmptyCell.swift
//  GolfHande
//
//  Created by Admin on 4/27/23.
//

import Foundation
import UIKit

class EmptyCell: UITableViewCell {
    
    // MARK: UI COMPONENTS:
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Empty Cell"
        return label
    }()
    
    // MARK: INITIALIZER
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }
    
    private func setupUI() {
        contentView.addSubview(titleLabel, constraints: [.centerX()])
        
    }
}

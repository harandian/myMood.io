//
//  GraphCollectionViewCell.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-08.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class GraphCollectionViewCell: UICollectionViewCell {
    
    let graphBox = UIView()
    
    var barHeightConstraint: NSLayoutConstraint?
    
    override var isHighlighted: Bool {
        didSet {
            graphBox.backgroundColor = isHighlighted ? .blue : .red
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        graphBox.translatesAutoresizingMaskIntoConstraints = false
        
        graphBox.leadingAnchor.constraint(equalTo: self.graphBox.leadingAnchor, constant: 0).isActive = true
        graphBox.trailingAnchor.constraint(equalTo: self.graphBox.trailingAnchor, constant: 0).isActive = true
        graphBox.bottomAnchor.constraint(equalTo: self.graphBox.bottomAnchor, constant: 0).isActive = true
        
//        barHeightConstraint = graphBox.heightAnchor.constraint(equalTo: self.graphBox.bounds.height, constant: 100.0).isActive = true
//        barHeightConstraint = graphBox.heightAnchor.constraint(equalToConstant: 300).isActive = true
//        barHeightConstraint?.constant = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

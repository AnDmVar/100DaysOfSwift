//
//  cellTableViewCell.swift
//  Day50
//
//  Created by An Var on 18.08.2021.
//

import UIKit

class cellTableViewCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView?.heightAnchor.constraint(equalToConstant: (self.frame.height - 20)).isActive = true
        imageView?.widthAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        imageView?.contentMode = .scaleAspectFit
        
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //textLabel?.heightAnchor.constraint(equalToConstant: (self.frame.height - 20)).isActive = true
        //textLabel?.widthAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        textLabel?.leadingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? self.leadingAnchor, constant: 20).isActive = true
    }
    
}

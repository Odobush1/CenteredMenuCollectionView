//
//  MenuCollectionViewCell.swift
//  ODCenteredMenu
//
//  Created by Alex on 1/17/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit
import SDWebImage

final class MenuCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "menuCollectionViewCell"
    static let nib = UINib(nibName: "MenuCollectionViewCell", bundle: nil)
    
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var label: UILabel?
    
    var infoObject: InfoObject? {
        didSet {
            guard let info = infoObject else {
                return
            }
            updateUIWithInfoObject(info)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        label?.text = nil
    }
}

private extension MenuCollectionViewCell {
    func updateUIWithInfoObject(infoObject: InfoObject) {
        label?.text = infoObject.text
        
        if let textColor = infoObject.cellTextColor {
            label?.textColor = textColor
        }
        
        if let font = infoObject.cellFont {
            label?.font = font
        }
        
        if let imageName = infoObject.imageName {
            imageView?.image = UIImage.init(named: imageName)
            return
        }
        
        guard let imageURLString = infoObject.imageURLString else {
            return
        }
        var placeholder: UIImage?
        if let placeholderName = infoObject.imagePlaceholderName {
            placeholder = UIImage.init(named: placeholderName)
        }
        imageView?.sd_setImageWithURL(NSURL(string: imageURLString), placeholderImage: placeholder)
    }
}
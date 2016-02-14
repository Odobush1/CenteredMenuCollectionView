//
//  ODInfoObject.swift
//  ODCenteredMenu
//
//  Created by Alex on 1/16/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit

final class InfoObject {
    var number: Int
    var text: String
    var imageName: String?
    
    var imageURLString: String?
    var imagePlaceholderName: String?
    
    var cellTextColor: UIColor?
    var cellFont: UIFont?
    
    init(objectNumber: Int, objectText: String, objectImageName: String) {
        number = objectNumber
        text = objectText
        imageName = objectImageName
    }
    
    init(objectNumber: Int, objectText: String, objectImageURL: String, objectImagePlaceholderName: String) {
        number = objectNumber
        text = objectText
        imageURLString = objectImageURL
        imagePlaceholderName = objectImagePlaceholderName
    }
    
}

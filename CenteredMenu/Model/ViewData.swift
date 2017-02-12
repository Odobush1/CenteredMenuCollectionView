import UIKit

struct ViewData {
    let number: Int
    let text: String
    
    var imageName: String?
    var imageURLString: String?
    var imagePlaceholderName: String?
    var cellTextColor: UIColor?
    var cellFont: UIFont?
    
    init(number: Int, text: String, imageName: String?) {
        self.number = number
        self.text = text
        self.imageName = imageName
    }
    
    init(number: Int, text: String, imageURLString: String?, imagePlaceholderName: String?) {
        self.number = number
        self.text = text
        self.imageURLString = imageURLString
        self.imagePlaceholderName = imagePlaceholderName
    }
}

import SDWebImage

final class MenuCollectionViewCell: UICollectionViewCell {
    static let identifier = "menuCollectionViewCell"
    static let nib = UINib(nibName: "MenuCollectionViewCell", bundle: nil)
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var label: UILabel!
    
    var viewData: ViewData? {
        didSet {
            guard let data = viewData else { return }
            updateUI(withViewData: data)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
}

private extension MenuCollectionViewCell {
    func updateUI(withViewData viewData: ViewData) {
        label.text = viewData.text
        
        if let textColor = viewData.cellTextColor {
            label.textColor = textColor
        }
        
        if let font = viewData.cellFont {
            label.font = font
        }
        
        if let imageName = viewData.imageName {
            imageView.image = UIImage(named: imageName)
            return
        }
        
        guard let imageURLString = viewData.imageURLString else { return }
        
        var placeholder: UIImage?
        if let placeholderName = viewData.imagePlaceholderName {
            placeholder = UIImage(named: placeholderName)
        }
        let url = URL(string: imageURLString)
        imageView.sd_setImage(with: url, placeholderImage: placeholder)
    }
}

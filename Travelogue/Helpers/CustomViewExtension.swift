import UIKit

extension UIView {
    @discardableResult
    func applyBorderRadius(radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func applyShadow() -> Self {
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        return self
    }
    
    @discardableResult
    func applyBorder(color: UIColor) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
        return self
    }
}

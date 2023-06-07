import UIKit

extension UIView {
    @discardableResult
    func applyBorderRadius(radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func applyShadow() -> Self {
        layer.shadowColor = UIColor.tertiarySystemBackground.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func applyBorder(color: UIColor) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
        return self
    }
    
    @discardableResult
    func applyBlurryGlassBackground(alpha: CGFloat = 0.9) -> Self {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        sendSubviewToBack(blurView)
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(alpha)
        addSubview(backgroundView)
        sendSubviewToBack(backgroundView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return self
    }
    
    private var loadingTag: Int { return 98765 }
    
    func showLoadingAnimation() {
        guard viewWithTag(loadingTag) == nil else { return }
        
        let loadingView = UIView(frame: bounds)
        loadingView.backgroundColor = UIColor.gray
        loadingView.tag = loadingTag
        addSubview(loadingView)
        
        let animationDuration: TimeInterval = 0.5
        let transitionColor = CABasicAnimation(keyPath: "backgroundColor")
        transitionColor.fromValue = UIColor.gray.cgColor
        transitionColor.toValue = UIColor.white.cgColor
        transitionColor.duration = animationDuration
        transitionColor.autoreverses = true
        transitionColor.repeatCount = Float.greatestFiniteMagnitude
        loadingView.layer.add(transitionColor, forKey: "backgroundColorTransition")
    }
    
    func hideLoadingAnimation() {
        guard let loadingView = viewWithTag(loadingTag) else { return }
        loadingView.layer.removeAnimation(forKey: "backgroundColorTransition")
        loadingView.removeFromSuperview()
    }
}

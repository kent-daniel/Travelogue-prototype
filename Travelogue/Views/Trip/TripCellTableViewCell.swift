import UIKit
class TripCellTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set the cell's background color to clear
        self.backgroundColor = .blue
        // Set the cell's selection style to none
        self.selectionStyle = .none
        
        // Set the cell's size to 30% of the screen width
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = screenWidth * 0.3
        self.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellWidth)
        
        // Add a drop shadow to the cell
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        
        // Add an inset to the cell
        let inset: CGFloat = 10
        let insetFrame = CGRect(x: inset, y: inset, width: cellWidth - inset * 2, height: cellWidth - inset * 2)
        let insetView = UIView(frame: insetFrame)
        insetView.backgroundColor = .white
        insetView.layer.cornerRadius = 10
        insetView.layer.masksToBounds = true
        self.contentView.addSubview(insetView)
        self.contentView.sendSubviewToBack(insetView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//
//  PostCell.swift
//  Travelogue
//
//  Created by kent daniel on 15/5/2023.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let dateLabel = UILabel()
    let posterLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Add image view
        let padding: CGFloat = 20
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        // Add date label
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        
        
        // Add activity indicator
        contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        activityIndicator.color = .gray
        
        // Add drop shadow
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        let imageUrlString = post.url
        if let imageUrlString {
            self.activityIndicator.startAnimating()
            ImageManager.downloadImage(from: imageUrlString) { (image, error) in
                if let image = image {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = image
                }
            }
        }
        self.dateLabel.text = formatDateToString(post.dateTime!,format: "yyyy-MM-dd HH:mm") // use formatDate() to format the date string
        
    }
    
    func formatDateToString(_ date: Date , format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

}


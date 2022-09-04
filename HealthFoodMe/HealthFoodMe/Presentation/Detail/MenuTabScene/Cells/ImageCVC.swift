//
//  AllMenuImageCVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/08/29.
//

import UIKit

class ImageCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    // MARK: - UI Components
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = ImageLiterals.MenuTab.emptyCard
        return imageView
    }()
    
    // MARK: - Life Cycle Part
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension ImageCVC {
    func setImage(_ image: UIImage) {
        photoImageView.image = image
    }
    
    func setImageURL(_ url: String) {
        let url = URL(string: url)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data!)
            }
        }
    }
    
    func setLayout() {
        contentView.addSubviews(photoImageView)
        let width = UIScreen.main.bounds.width
    
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(width * 107/375)

        }
        photoImageView.layer.cornerRadius = 8
        photoImageView.layer.masksToBounds = true
    }
}

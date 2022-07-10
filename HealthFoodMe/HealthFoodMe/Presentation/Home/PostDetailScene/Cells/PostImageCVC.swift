//
//  PostImageCVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/05/18.
//

import UIKit

import SnapKit

final class PostImageCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = .carrotBlue
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    // MARK: - View Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        profileImageView.image = UIImage()
    }
    
    // MARK: Custom Methods
    
    func setData(postImage: UIImage?) {
        profileImageView.image = postImage
    }
    
    func setData(postImageURL: String) {
//        profileImageView.setImage(with: postImageURL)
    }
    
    // MARK: UI & Layout
    
    private func setUI() {
//        self.backgroundColor = .carrotWhite
    }
    
    private func setLayout() {
        contentView.addSubviews(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

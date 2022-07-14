//
//  ListPhotoCVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/13.
//

import UIKit

protocol ListPhotoCVCDelegate: AnyObject {
  func didPressDeleteBtn(at index: Int)
}

final class ListPhotoCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    weak var delegate: ListPhotoCVCDelegate?
    var indexPath: Int = 0
  
    // MARK: - UI Components
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = ImageLiterals.ReviewWrite.addPhotoIcon
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.ReviewWrite.deletePhotoBtn, for: .normal)
        btn.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return btn
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

extension ListPhotoCVC {
    
    func setImage(_ image: UIImage) {
        photoImageView.image = image
    }
    
    func setLayout() {
        contentView.addSubviews(photoImageView, deleteBtn)
        
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        photoImageView.layer.cornerRadius = 8
        photoImageView.layer.masksToBounds = true
        deleteBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.trailing.equalToSuperview().inset(2)
            make.width.height.equalTo(24)
        }
    }
    
    @objc func didTapDeleteButton(_ sender: Any) {
        delegate?.didPressDeleteBtn(at: indexPath)
    }
}

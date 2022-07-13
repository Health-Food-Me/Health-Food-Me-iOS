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
        imageView.image = ImageLiterals.ReviewWrite.addPhotoIcon
        return imageView
    }()
    
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.ReviewWrite.deletePhotoBtn, for: .normal)
        return btn
    }()
    
    // MARK: - Life Cycle Part
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension ListPhotoCVC {
    func setUI() {
        
    }
    
    func setLayout() {
        contentView.addSubviews(photoImageView, deleteBtn)
        
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().offset(7)
            make.width.height.equalTo(16)
        }
    }
}

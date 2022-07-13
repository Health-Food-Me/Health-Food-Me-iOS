//
//  AddPhotoCVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/13.
//

import UIKit

import SnapKit

protocol AddImageDelegate: AnyObject {
    func didPickImagesToUpload(images: [UIImage])
}

final class AddPhotoCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    weak var delegate: AddImageDelegate?
    
//    var selectedAssets: [PHAsset] = [PHAsset]()
    var userSelectedImages: [UIImage] = [UIImage]()
    
    // MARK: - UI Components
    let addPhotoView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        return view
    }()
    
    lazy var addPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.ReviewWrite.addPhotoIcon
        return imageView
    }()
    
    lazy var photoCountLabel: UILabel = {
        let lb = UILabel()
        lb.text = "0/5"
        lb.textColor = .helfmeTagGray
        lb.font = .NotoRegular(size: 14)
        return lb
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

extension AddPhotoCVC {
    func setLineDot(view: UIView, color: UIColor, radius: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.frame = view.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: radius).cgPath

        view.layer.addSublayer(borderLayer)
    }
    
    func setUI() {
        setLineDot(view: addPhotoView, color: UIColor.helfmeTagGray, radius: 8)
    }
    
    func setLayout() {
        contentView.addSubview(addPhotoView)
        
        addPhotoView.addSubviews(addPhotoImageView, photoCountLabel)
        
        addPhotoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(105)
        }
        
        addPhotoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.centerX.equalToSuperview()
            make.width.equalTo(31)
        }
        
        photoCountLabel.snp.makeConstraints { make in
            make.top.equalTo(addPhotoImageView.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
            make.width.equalTo(22)
        }
    }
}

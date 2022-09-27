//
//  AllImageCVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/08/31.
//

import UIKit
import SnapKit

class AllImageCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    var imgURLList = [String]() {didSet {
        menuImageCV.reloadData()
    }}
    
    // MARK: - UI Components
    lazy var menuImageCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .helfmeWhite
        cv.bounces = false
        return cv
    }()
    
    // MARK: - Life Cycle Part
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setDelegate()
        registerCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension AllImageCVC {
    private func setDelegate() {
        menuImageCV.delegate = self
        menuImageCV.dataSource = self
    }
    
    private func registerCell() {
        ImageCVC.register(target: menuImageCV)
    }
    
    private func setLayout() {
        contentView.addSubviews(menuImageCV)
        menuImageCV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setData(menuBoardList: [String]) {
        self.imgURLList = menuBoardList
    }
}

extension AllImageCVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgURLList.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let allImageCell = menuImageCV.dequeueReusableCell(withReuseIdentifier: ImageCVC.className, for: indexPath) as? ImageCVC
        else { return UICollectionViewCell() }
        allImageCell.setData(menuBoard: imgURLList[indexPath.row])
        return allImageCell
    }
}

extension AllImageCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        
        let cellWidth = width * (107/375)
        let cellHeight = cellWidth * (107/107)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageSlideData = ImageSlideDataModel.init(clickedIndex: indexPath.row,
                                                      imgURLs: imgURLList ?? [])
        postObserverAction(.menuPhotoClicked,object: imageSlideData)
    }
}



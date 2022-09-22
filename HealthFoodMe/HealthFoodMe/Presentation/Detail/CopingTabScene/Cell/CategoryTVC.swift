//
//  CategoryTVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/09/07.
//

import UIKit

class CategoryTVC: UITableViewCell, UITableViewRegisterable {
    
    static var isFromNib = false
    let categoryList = ["샌드위치", "샐러드", "샤브샤브", "키토김밥"] // 테스트용
    
    // MARK: - UI Components
    lazy var categoryCV: UICollectionView = {
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        setDelegate()
        registerCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CategoryTVC {
    private func setDelegate() {
        categoryCV.delegate = self
        categoryCV.dataSource = self
    }
    
    private func registerCell() {
        CategoryCVC.register(target: categoryCV)
    }
    
    private func setLayout() {
        contentView.addSubviews(categoryCV)
        categoryCV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CategoryTVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count//임시로 넣어둔 값 (서버 붙일때 수정 예정)
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryCell = categoryCV.dequeueReusableCell(withReuseIdentifier: CategoryCVC.className, for: indexPath) as? CategoryCVC
        else { return UICollectionViewCell() }
//        categoryCell.setData(menuData: categoryList[indexPath.row])
        return categoryCell
    }
}

extension CategoryTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        
        let cellWidth = width * (77/375)
        let cellHeight = cellWidth * (32/77)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelected = true
    }
}



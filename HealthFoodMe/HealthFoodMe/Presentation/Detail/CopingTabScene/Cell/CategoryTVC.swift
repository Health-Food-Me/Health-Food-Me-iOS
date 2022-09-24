//
//  CategoryTVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/09/07.
//

import UIKit
import RxCocoa
import RxRelay

typealias CategoryIndex = Int

class CategoryTVC: UITableViewCell, UITableViewRegisterable {
    
    static var isFromNib = false
    private var categoryNameList: [String] = [] { didSet {
        categoryCV.isScrollEnabled = categoryNameList.count > 3
    }}
    internal var clickedCategoryIndex: ((CategoryIndex) -> Void)?
    private var currentIdx: CategoryIndex = 0
    
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
    public func setCategoryData(nameList: [String]) {
        categoryNameList = nameList
        categoryCV.reloadData()
    }
}

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
        return categoryNameList.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryCell = categoryCV.dequeueReusableCell(withReuseIdentifier: CategoryCVC.className, for: indexPath) as? CategoryCVC
        else { return UICollectionViewCell() }
        categoryCell.setCategoryData(name: categoryNameList[indexPath.row],
                                     isClicked: currentIdx == indexPath.row)
        return categoryCell
    }
}

extension CategoryTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = 77
        let cellHeight = 32
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if categoryNameList.count <= 3 {
            let totalWidth = calculateCategoryWidth(categoryNameList)
            let cellWidth = UIScreen.main.bounds.width - 40
            let margin = (cellWidth - totalWidth) / 2
            return UIEdgeInsets.init(top: 0,
                                     left: margin,
                                     bottom: 0,
                                     right: margin)
        } else {
            return UIEdgeInsets.init(top: 0,
                                     left: 20,
                                     bottom: 0,
                                     right: 0)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickedCategoryIndex?(indexPath.row)
        currentIdx = indexPath.row
        categoryCV.reloadData()
    }
}

extension CategoryTVC {
    private func calculateCategoryWidth(_ categoryList: [String]) -> CGFloat {
        let cellWidth: CGFloat = 77
        let cellWidthSpacing: CGFloat = 8
        let totalCategoryCellWidth: CGFloat = categoryList.map { _ in
            return cellWidth
        }.reduce(0) { $0 + $1 }
        
        var totalCellWidthSpacing: CGFloat {
            if categoryList.count == 1 { return 0 }
            else { return cellWidthSpacing * CGFloat(categoryList.count - 1) }
        }
        return totalCategoryCellWidth + totalCellWidthSpacing
    }
}

//
//  menuCellCVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/05.
//

import UIKit

import SnapKit
import MapKit

final class MenuCellCVC: UICollectionViewCell, UICollectionViewRegisterable {
   
    // MARK: - Properties
    
    static var isFromNib = false
    var isPick = false
    
    // MARK: - UI Components
    
    private lazy var menuView = MenuView()
    private lazy var menuDetailView = MenuDetailView()
  
    // MARK: - Life Cycle Part
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
    }
}

// MARK: - Methods

extension MenuCellCVC {
    private func setLayout() {
        contentView.addSubviews(menuView, menuDetailView)
        menuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        menuDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func changeCustomView(isMenu: Bool) {
        menuDetailView.isHidden = isMenu
        menuView.isHidden = !isMenu
    }
    
    func setData(menuData: MenuDataModel) {
        menuView.prepareView()
        self.isPick = menuData.isPick
        menuView.isPick = self.isPick
        menuView.updateLayout()
        menuView.menuImageView.image =  menuData.memuImageURL == nil ?  ImageLiterals.MenuTab.emptyCard : UIImage(named: "Image")
        menuView.titleLabel.text = menuData.menuName
        menuView.pickImageView.image = menuData.isPick ? UIImage(named: "icn_pick") : .none
        
        menuView.priceLabel.text = "\(menuData.menuPrice)원"
        if menuData.menuKcal == nil {
            menuView.kcalView.isHidden = true
        } else {
            guard let menuKcal = menuData.menuKcal else { return }
            menuView.kcalLabel.text = "\(menuKcal)"
        }

//        영양정보 부분
//        menuDetailView.titleLabel.text = menuData.menuName
//        menuDetailView.pickImageView.image = menuData.isPick ? UIImage(named: "icn_pick") : .none
//        menuDetailView.carbohydrateAmountLabel.text = "\(menuData.carbohydrates)g"
//        menuDetailView.proteinAmountLabel.text = "\(menuData.protein)g"
//        menuDetailView.fatsAmountLabel.text = "\(menuData.fat)g"
//        menuDetailView.kcalLabel.text = "\(menuData.menuKcal)"
    }
}

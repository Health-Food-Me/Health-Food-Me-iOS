//
//  MainInfoTVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import SnapKit

final class DetailTabTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let detailSummaryView = DetailSummaryView()
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension

extension DetailTabTVC {
    
    private func setUI() {
        
    }
    
    private func setLayout() {
        self.addSubviews(detailSummaryView)
        
        detailSummaryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Initializer
    
    func initCell(profileImageURL: String?, nickname: String?) {

    }
}

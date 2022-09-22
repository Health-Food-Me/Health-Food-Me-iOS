//
//  CopingTVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/09/07.
//

import UIKit

class CopingTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    private var copingHeader = CopingHeaderView()
    private var copingEmptyView = CopingEmptyView()
    private var isOnlyCategory: Bool = false
    var copingDataModel: CopingTabEntity?
    var restaurantId = ""
    var recommendList: [String] = [] {
        didSet {
            copingTableView.reloadData()
            checkEmptyView()
            updateTableViewLayout()
        }
    }
    var eatingList: [String] = [] {
        didSet {
            copingTableView.reloadData()
            checkEmptyView()
            updateTableViewLayout()
        }
    }
    private let headerHeight = 130
    private let rowHeight = 38
    private let bottomMargin = 115
    
    // MARK: - UI Components
    
    private let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeGreenSubDark
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeWhite
        lb.font = .NotoBold(size: 15)
        return lb
    }()
    
    private lazy var copingTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.clipsToBounds = true
        tv.sectionFooterHeight = 0
        tv.allowsSelection = false
        tv.bounces = false
        tv.layer.borderColor = UIColor.helfmeLineGray.cgColor
        tv.layer.borderWidth = 0.5
        tv.layer.cornerRadius = 15
        if #available(iOS 15, *) {
            tv.sectionHeaderTopPadding = 0
        }
        return tv
    }()

    // MARK: - Life Cycle Part
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        checkEmptyView()
        setLayout()
        setDelegate()
        registerCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CopingTVC {
    private func checkEmptyView() {
        copingEmptyView.isHidden = !(recommendList.isEmpty && eatingList.isEmpty)
        copingTableView.isHidden = (recommendList.isEmpty && eatingList.isEmpty)
    }
    
    private func updateEmptyViewConstraint() {
        let topInset = isOnlyCategory ? 32 : 0
        copingEmptyView.snp.updateConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(topInset)
        }
    }
    
    private func setLayout() {
        contentView.addSubviews(copingTableView, copingEmptyView, categoryView)
        
        categoryView.snp.makeConstraints { make in
            make.centerX.equalTo(copingEmptyView.snp.centerX)
            make.centerY.equalTo(contentView.snp.top).offset(32)
            make.height.equalTo(32)
            make.width.equalTo(117)
        }
        
        categoryView.addSubviews(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        copingTableView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(headerHeight * 2 + rowHeight * (recommendList.count + eatingList.count) + bottomMargin)
        }
        
        copingEmptyView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(346)
        }
    }
    
    private func registerCell() {
        ContentTVC.register(target: copingTableView)
        CopingHeaderView.register(target: copingTableView)
    }
    
    private func setDelegate() {
        copingTableView.delegate = self
        copingTableView.dataSource = self
    }
    
    func setData(category: String, data: CopingDataModel, isOnlyCategory: Bool){
        self.categoryLabel.text = "#\(category)"
        self.recommendList = data.recommend
        self.eatingList = data.tip
        self.categoryView.isHidden = !isOnlyCategory
        self.isOnlyCategory = isOnlyCategory
        self.updateEmptyViewConstraint()
    }
    
    private func updateTableViewLayout() {
        copingTableView.snp.updateConstraints { make in
            make.height.equalTo(headerHeight * 2 + rowHeight * (recommendList.count + eatingList.count) + bottomMargin)
        }
    }
}

extension CopingTVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let topHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CopingHeaderView.className) as? CopingHeaderView else { return nil }
        guard let bottomHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CopingHeaderView.className) as? CopingHeaderView else { return nil }
        
        if section == 0 {
            topHeaderCell.setHeaderData(section: 0)
            return topHeaderCell
        } else {
            bottomHeaderCell.setHeaderData(section: 1)
            return bottomHeaderCell
        }
    }
}

// MARK: TableViewDataSource

extension CopingTVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recommendList.count
        } else {
            return eatingList.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTVC.className, for: indexPath) as? ContentTVC else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            cell.setData(section: 0, content: recommendList[indexPath.row])
        } else {
            cell.setData(section: 1, content: eatingList[indexPath.row])
        }
        return cell
    }
}

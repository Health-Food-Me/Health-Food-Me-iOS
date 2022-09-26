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
    private let headerHeight: CGFloat = 126
    private let bottomMargin: CGFloat = 52
    
    // MARK: - UI Components
    
    private let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeGreenSubDark
        view.layer.cornerRadius = 16
        view.clipsToBounds = false
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeWhite
        lb.font = .NotoBold(size: 15)
        return lb
    }()
    
    private lazy var copingTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
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
        addObserver()
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
        let topInset = isOnlyCategory ? 16 : 0
        copingEmptyView.snp.updateConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(topInset)
        }
    }
    
    private func updateCopingTableView() {
        let topInset = isOnlyCategory ? 16 : 0
        copingTableView.snp.updateConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(topInset)
        }
    }
    
    private func setLayout() {

        contentView.addSubviews(copingTableView, copingEmptyView, categoryView)
        
        categoryView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(32)
            make.width.equalTo(117)
        }
        
        categoryView.addSubviews(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        copingTableView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        
        copingEmptyView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
    
    private func addObserver() {
        addObserverAction(.copingCellScrollToTop) { _ in
            let topOffset = CGPoint(x: 0, y: 0)
            self.copingTableView.setContentOffset(topOffset, animated: true)
        }
        
        addObserverAction(.copingCellScrollToBottom) { _ in
            let bottomOffset = CGPoint(x: 0, y: self.copingTableView.contentSize.height - self.copingTableView.bounds.height + self.copingTableView.contentInset.bottom)
            self.copingTableView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func setData(category: String, data: CopingDataModel, isOnlyCategory: Bool){
        self.categoryLabel.text = "#\(category)"
        self.recommendList = data.recommend
        self.eatingList = data.tip
        self.categoryView.isHidden = !isOnlyCategory
        self.isOnlyCategory = isOnlyCategory
        self.updateEmptyViewConstraint()
        self.updateCopingTableView()
    }
    
    private func updateTableViewLayout() {
        let cellCalculator = CopingCellCalculator.shared
        var cellHeight: CGFloat {
            let recommendListHeight = cellCalculator.calculateCellHeight(tipList: recommendList)
            let eatingListHeight = cellCalculator.calculateCellHeight(tipList: eatingList)
            return recommendListHeight + eatingListHeight
        }
        
        var tableViewHeight: CGFloat {
            let calculatedHeight: CGFloat = headerHeight * 2 + cellHeight + bottomMargin

            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let top = window?.safeAreaInsets.top ?? 0
            let bottom = window?.safeAreaInsets.bottom ?? 0
            let screenHeight: CGFloat = UIScreen.main.bounds.height - top - bottom

            let maximumHeight: CGFloat = screenHeight - 176
            
            print(calculatedHeight, maximumHeight)
            if maximumHeight > calculatedHeight {
                postObserverAction(.isOverFillCopingVC,object: false)
                return calculatedHeight
            } else {
                postObserverAction(.isOverFillCopingVC,object: true)
                return maximumHeight
            }
        }
        
        copingTableView.snp.updateConstraints { make in
            make.height.equalTo(tableViewHeight)
        }
    }
}

extension CopingTVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
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
            cell.setData(section: 0, content: recommendList[indexPath.row], isLast: recommendList.count - 1 == indexPath.row)
        } else {
            cell.setData(section: 1, content: eatingList[indexPath.row], isLast: eatingList.count - 1 == indexPath.row)
        }
        cell.selectionStyle = .none
        return cell
    }
}

struct CopingCellCalculator {
    static let shared = CopingCellCalculator()
    private init () { }
    
    func calculateCellHeight(tipList: [String]) -> CGFloat {
        guard !tipList.isEmpty else { return 0 }
        var totalHeight: CGFloat = 0
        let topMargin: CGFloat = 9
        let bottomMargin: CGFloat = 9
        let screenWidth = UIScreen.main.bounds.width
        
        let mockLabel = UILabel()
        mockLabel.textColor = .helfmeBlack
        mockLabel.font = .NotoRegular(size: 12)
        mockLabel.numberOfLines = 0
        mockLabel.lineBreakMode = .byCharWrapping
        mockLabel.frame = CGRect(x: 0, y: 0, width: screenWidth - 170, height: 0)
        
        for tip in tipList {
            mockLabel.text = tip
            mockLabel.sizeToFit()
            totalHeight += (mockLabel.frame.height + topMargin + bottomMargin)
        }
        return totalHeight
    }
}

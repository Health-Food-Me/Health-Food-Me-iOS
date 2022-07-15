//
//  CopingTabVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/15.
//

import UIKit

class CopingTabVC: UIViewController {
    
    // MARK: - Properties
    private var copingHeader = CopingHeaderView()
    private var copingEmptyView = CopingEmptyView()
    // MARK: - UI Components
    
    var recommendList: [String] = []
    var eatingList: [String] = []
    
    //태그 종류 UI 추가해야함
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
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        registerCell()
        fetchData()
    }
}

// MARK: - Methods

extension CopingTabVC {
    private func setUI() {
        copingEmptyView.isHidden = !(recommendList.isEmpty && eatingList.isEmpty)
        copingTableView.isHidden = (recommendList.isEmpty && eatingList.isEmpty)
    }
    
    private func setLayout() {
        view.addSubviews(copingTableView, copingEmptyView)
        
        copingTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.leading.equalToSuperview().offset(20)
            make.trailing.bottom.equalToSuperview().inset(20)
        }
        
        copingEmptyView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
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
    
    private func fetchData() {
        recommendList = CopingDataModel.sampleCopingData.recommend ?? []
        eatingList = CopingDataModel.sampleCopingData.eating ?? []
        copingTableView.reloadData()
    }
}

// MARK: - Network

extension CopingTabVC {

}

extension CopingTabVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CopingHeaderView.className) as? CopingHeaderView else { return nil }
        if section == 0 {
            headerCell.setHeaderData(section: 0)
        } else {
            headerCell.setHeaderData(section: 1)
        }
        return headerCell
    }
}

// MARK: TableViewDataSource

extension CopingTabVC: UITableViewDataSource {
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



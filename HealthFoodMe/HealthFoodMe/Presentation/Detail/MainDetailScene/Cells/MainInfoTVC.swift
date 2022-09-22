//
//  MainInfoTVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import SnapKit
import RxRelay
import RxSwift

final class MainInfoTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    var isOpenned: Bool = false
    let toggleButtonTapped = PublishRelay<Void>()
    let directionButtonTapped = PublishRelay<Void>()
    let telePhoneLabelTapped = PublishRelay<String>()
    var expandableData = MainDetailExpandableModel.init(location: "",
                                                        telephone: "",
                                                        labelText: [],
                                                        isExpandable: false) { didSet {
        if !expandableData.location.isEmpty {
            expandableTableView.reloadData()
        }
    }}
    var isInitialReload = true
    
    // MARK: - UI Components
    
    private let detailSummaryView = DetailSummaryView()
    
    private var expandableTVC = [ExpandableInfoTVC]()
    
    private lazy var expandableTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.clipsToBounds = true
        tv.sectionFooterHeight = 0
        tv.allowsSelection = false
        tv.isScrollEnabled = false
        if #available(iOS 15, *) {
            tv.sectionHeaderTopPadding = 0
        }
        tv.estimatedRowHeight = 100
        tv.estimatedSectionHeaderHeight = 80
        return tv
    }()
    
    private let directionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = ImageLiterals.MainDetail.directionIcon
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let distanceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "0m"
        lb.textColor = .mainRed
        lb.font = .NotoMedium(size: 12)
        return lb
    }()
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        registerCell()
        setDelegate()
        setTapGesture()
        addObserver()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MainInfoTVC {
    
    private func setUI() {
        self.backgroundColor = .white
    }
    
    private func setLayout() {
        self.contentView.addSubviews(detailSummaryView, expandableTableView, directionImageView,
                                     distanceLabel)
        
        detailSummaryView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        expandableTableView.snp.makeConstraints { make in
            make.top.equalTo(detailSummaryView.snp.bottom)
            make.leading.equalToSuperview().offset(17.5)
            make.width.equalTo(250)
            make.height.equalTo(34 * 2 + 20 * 1)
            make.bottom.equalToSuperview().inset(9)
        }
        
        directionImageView.snp.makeConstraints { make in
            make.top.equalTo(detailSummaryView.snp.bottom).offset(4.5)
            make.width.height.equalTo(44)
            make.trailing.equalToSuperview().inset(34)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(directionImageView.snp.bottom).offset(4)
            make.centerX.equalTo(directionImageView.snp.centerX)
        }
    }
    
    private func registerCell() {
        ExpandableInfoTVC.register(target: expandableTableView)
    }
    
    private func setDelegate() {
        expandableTableView.delegate = self
        expandableTableView.dataSource = self
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentActionSheet))
        directionImageView.addGestureRecognizer(tapGesture)
    }
    
    func setData(data: MainDetailEntity) {
        detailSummaryView.setData(data: data)
        if data.restaurant.distance > 1000 {
            let firstNumber = data.restaurant.distance / 1000
            let secondNumber = (data.restaurant.distance / 100) % 10
            let result = "\(firstNumber).\(secondNumber)"
            distanceLabel.text = "\(result)km"
        } else {
            distanceLabel.text = "\(data.restaurant.distance)m"
        }
        self.expandableData = data.restaurant.toDomain()
        
        initialReload()
    }
    
    func initialReload() {
        if isInitialReload {
            expandableTableView.reloadData()
        }
    }
    private func addObserver() {
        addObserverAction(.foldButtonClicked) { _ in
            self.toggleCells()
        }
    }
    
    @objc
    private func presentActionSheet() {
        directionButtonTapped.accept(())
    }
}

// MARK: TableViewDelegate

extension MainInfoTVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return CGFloat(isOpenned ? (4 + (expandableData.labelText.count * 19)) : 28)
        } else {
            return 28
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: TableViewDataSource

extension MainInfoTVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableInfoTVC.className, for: indexPath) as? ExpandableInfoTVC else { return UITableViewCell() }
        if indexPath.row == 1 && indexPath.section == 1 {
            cell.foldState = self.isOpenned
            cell.setUIWithIndex(indexPath: indexPath, isOpenned: self.isOpenned, expandableData: self.expandableData)
        } else {
            cell.setUIWithIndex(indexPath: indexPath, isOpenned: self.isOpenned, expandableData: self.expandableData)
        }

        cell.telePhoneLabelTapped.asDriver(onErrorJustReturn: "")
            .drive { phoneNumber in
                self.telePhoneLabelTapped.accept(phoneNumber)
            }.disposed(by: cell.disposeBag)
        cell.setFoldStateImage(isFolded: !self.isOpenned)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
    
    private func toggleCells() {
        self.isOpenned.toggle()
        self.remakeConstraintsForCells()
        toggleButtonTapped.accept(())
        self.expandableTableView.reloadData()
        UIView.animate(withDuration: 1, delay: 0) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    private func makeIndexPaths() -> [IndexPath] {
        var indexPath = [IndexPath]()
        
        for row in 1...6 {
            indexPath.append(IndexPath(row: row, section: 1))
        }
        
        return indexPath
    }
    
    private func remakeConstraintsForCells() {
        expandableTableView.snp.updateConstraints { make in
            if isOpenned {
                make.height.equalTo(34 * 2 + 20 * 7)
            } else {
                make.height.equalTo(34 * 2 + 20 * 1)
            }
        }
    }
}

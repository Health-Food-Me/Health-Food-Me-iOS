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
    private var isOpenned: Bool = false
    let toggleButtonTapped = PublishRelay<Void>()
    let directionButtonTapped = PublishRelay<Void>()
    
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
        lb.text = "593m"
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
    
    @objc
    private func presentActionSheet() {
        directionButtonTapped.accept(())
    }
}

// MARK: TableViewDelegate

extension MainInfoTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 20
        } else {
            return 34
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: TableViewDataSource

extension MainInfoTVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1) && isOpenned {
            return 7
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableInfoTVC.className, for: indexPath) as? ExpandableInfoTVC else { return UITableViewCell() }
        cell.setUIWithIndex(indexPath: indexPath)
        cell.toggleButtonTapped.asDriver(onErrorJustReturn: ())
            .drive { _ in
                self.toggleCells()
            }
            .disposed(by: cell.disposeBag)
        return cell
    }
    
    private func toggleCells() {
        self.isOpenned.toggle()
        self.remakeConstraintsForCells()
        toggleButtonTapped.accept(())
        if isOpenned {
            self.expandableTableView.insertRows(at: makeIndexPaths(), with: .none)
        } else {
            self.expandableTableView.deleteRows(at: makeIndexPaths(), with: .none)
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

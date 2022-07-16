//
//  CopingTabVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/15.
//

import UIKit

import RxSwift
import RxCocoa

class CopingTabVC: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var copingHeader = CopingHeaderView()
    private var copingEmptyView = CopingEmptyView()
    var topScrollAnimationNotFinished: Bool = true
    weak var delegate: ScrollDeliveryDelegate?
    var recommendList: [String] = []
    var eatingList: [String] = []
    
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
        lb.text = "#샤브샤브"
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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setUI()
        setLayout()
        setDelegate()
        registerCell()
        addPanGesture()
    }
}

// MARK: - Methods

extension CopingTabVC {
    private func setUI() {
        copingEmptyView.isHidden = !(recommendList.isEmpty && eatingList.isEmpty)
        copingTableView.isHidden = (recommendList.isEmpty && eatingList.isEmpty)
    }
    
    private func setLayout() {
        view.addSubviews(copingTableView, copingEmptyView, categoryView)
        
        categoryView.snp.makeConstraints { make in
            make.centerX.equalTo(copingEmptyView.snp.centerX)
            make.centerY.equalTo(copingEmptyView.snp.top)
            make.height.equalTo(32)
            make.width.equalTo(117)
        }
        
        categoryView.addSubviews(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        copingTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(130 * 2 + 38 * (recommendList.count + eatingList.count) + 56)
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
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer()
        view.addGestureRecognizer(panGesture)
        panGesture.rx.event.asDriver { _ in .never() }
            .drive(onNext: { [weak self] sender in
                let windowTranslation = sender.translation(in: self?.view)
                switch sender.state {
                case .changed:
                        if windowTranslation.y < 0 {
                            self?.delegate?.scrollStarted(velocity: windowTranslation.y, scrollView: UIScrollView())
                        } else {
                            self?.delegate?.childViewScrollDidEnd(type: .coping)
                        }
                case .ended:
                    break
                default:
                    break
                }
            }).disposed(by: disposeBag)

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

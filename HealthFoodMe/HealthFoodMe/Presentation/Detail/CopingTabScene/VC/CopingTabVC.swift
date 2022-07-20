//
//  CopingTabVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/15.
//

import UIKit

import RxSwift
import RxCocoa

protocol CopingGestureDelegate {
    func panGestureSwipe(isRight: Bool)
    func downPanGestureSwipe(panGesture: ControlEvent<UIPanGestureRecognizer>.Element)
}

class CopingTabVC: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var copingHeader = CopingHeaderView()
    private var copingEmptyView = CopingEmptyView()
    var topScrollAnimationNotFinished: Bool = true
    weak var delegate: ScrollDeliveryDelegate?
    var panDelegate: CopingGestureDelegate?
    var copingDataModel: CopingTabEntity?
    var restaurantId = "" //임시로 넣어준 식당ID
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
    private let bottomMargin = 120
    var swipeDelegate: SwipeDismissDelegate?
    
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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        checkEmptyView()
        setLayout()
        setDelegate()
        registerCell()
        addPanGesture()
    }
}

// MARK: - Methods

extension CopingTabVC {
    private func checkEmptyView() {
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
            make.height.equalTo(headerHeight * 2 + rowHeight * (recommendList.count + eatingList.count) + bottomMargin)
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
        getMenuPrescription()
        copingTableView.reloadData()
    }
    
    private func updateTableViewLayout() {
        copingTableView.snp.updateConstraints { make in
            make.height.equalTo(headerHeight * 2 + rowHeight * (recommendList.count + eatingList.count) + bottomMargin)
        }
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer()
        view.addGestureRecognizer(panGesture)
        panGesture.rx.event.asDriver { _ in .never() }
            .drive(onNext: { [weak self] sender in
                let velocity = sender.velocity(in: self?.view)
                let isVertical = abs(velocity.y) > abs(velocity.x)
                switch (isVertical, velocity.x, velocity.y) {
                case (true, _, let y) where y < 0:
                    self?.delegate?.scrollStarted(velocity: -10, scrollView: UIScrollView())
                    
                case (true, _, let y) where y > 0:
                    self?.swipeDelegate?.swipeToDismiss()
                    self?.delegate?.childViewScrollDidEnd(type: .coping)
                    
                case (false, let x, _) where x > 0:
                    self?.panDelegate?.panGestureSwipe(isRight: false)
                    
                case (false, let x, _) where x < 0:
                    self?.panDelegate?.panGestureSwipe(isRight: true)
                    
                default: return
                }
            }).disposed(by: disposeBag)
        
    }
}

// MARK: - Network

extension CopingTabVC {
    func getMenuPrescription() {
        RestaurantService.shared.getMenuPrescription(restaurantId: restaurantId) { networkResult in
            print(networkResult)
            switch networkResult {
            case .success(let data):
                if let data = data as? CopingTabEntity {
                    print(data, "성공")
                    self.categoryLabel.text = " # \(data.category)"
                    self.recommendList = data.content.recommend
                    self.eatingList = data.content.tip
                }
                self.copingTableView.reloadData()
            default:
                break;
            }
        }
    }
}

extension CopingTabVC: UITableViewDelegate {
    
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

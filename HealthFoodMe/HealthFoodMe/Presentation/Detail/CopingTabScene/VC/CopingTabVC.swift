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
    private var copingTVC = CopingTVC()
    private let disposeBag = DisposeBag()
    var topScrollAnimationNotFinished: Bool = true
    weak var delegate: ScrollDeliveryDelegate?
    var panDelegate: CopingGestureDelegate?
    var restaurantId = ""
    var swipeDelegate: SwipeDismissDelegate?
    
    // MARK: - UI Components
    
    private lazy var copingTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.clipsToBounds = true
        tv.sectionFooterHeight = 0
        tv.allowsSelection = false
        tv.bounces = false
        if #available(iOS 15, *) {
            tv.sectionHeaderTopPadding = 0
        }
        return tv
    }()
    
//    CopingTVC().restaurantId = self.restaurantId
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setDelegate()
        registerCell()
        addPanGesture()
    }
}

// MARK: - Methods

extension CopingTabVC {
    
    private func setLayout() {
        view.addSubviews(copingTableView)
        
        copingTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1500)
        }
    }
    
    private func registerCell() {
        CategoryTVC.register(target: copingTableView)
        CopingTVC.register(target: copingTableView)
    }
    
    private func setDelegate() {
        copingTableView.delegate = self
        copingTableView.dataSource = self
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

extension CopingTabVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50 //카테고리 개수가 한개면 높이 0
        } else {
            return 1000
        }
    }
}

// MARK: TableViewDataSource

extension CopingTabVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTVC.className, for: indexPath) as? CategoryTVC else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CopingTVC.className, for: indexPath) as? CopingTVC else { return UITableViewCell() }
            
//            copingTVC.restaurantId = self.restaurantId
//            print(copingTVC.restaurantId + "✈️")
            return cell
        }
    }
}

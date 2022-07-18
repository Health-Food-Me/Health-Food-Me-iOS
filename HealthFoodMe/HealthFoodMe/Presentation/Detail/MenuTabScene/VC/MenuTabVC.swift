//
//  menuVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/05.
//

import UIKit

import SnapKit
import RxSwift

protocol ScrollDeliveryDelegate: AnyObject {
	func scrollStarted(velocity: CGFloat, scrollView: UIScrollView)
	func childViewScrollDidEnd(type: TabMenuCase)
	func currentTabMenu(_ type: TabMenuCase)
}

enum TabMenuCase: Int {
	case menu = 0
	case coping = 1
	case review = 2
}

final class MenuTabVC: UIViewController {
	
	// MARK: - Properties
	
	var isMenu: Bool = true
	var topScrollAnimationNotFinished: Bool = true
	let panGesture = UIPanGestureRecognizer()
	weak var delegate: ScrollDeliveryDelegate?
	var swipeDismissDelegate: SwipeDismissDelegate?
	private var disposeBag = DisposeBag()
	
	// MARK: - UI Components
	
	private var headerView = HeaderView()
	
	private lazy var menuCV: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.scrollDirection = .vertical
		layout.sectionInset = .zero
		
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.showsVerticalScrollIndicator = false
		cv.backgroundColor = .helfmeWhite
		cv.bounces = false
		return cv
	}()
	
	// MARK: - View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUI()
		setLayout()
		setDelegate()
		registerCell()
		addGesture()
		bindGesture()
	}
}

// MARK: - Methods

extension MenuTabVC {
	
	private func addGesture() {
		menuCV.addGestureRecognizer(panGesture)
		panGesture.isEnabled = false
	}
	
	private func setDelegate() {
		menuCV.delegate = self
		menuCV.dataSource = self
		headerView.delegate = self
	}
	
	private func setUI() {
		view.backgroundColor = .helfmeWhite
	}
	
	private func setLayout() {
		view.addSubviews(menuCV)
		menuCV.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
	
	private func registerCell() {
		MenuCellCVC.register(target: menuCV)
	}
	
	private func bindGesture() {
		panGesture.rx.event.asDriver { _ in .never() }
			.drive(onNext: { [weak self] sender in
				let velocity = sender.velocity(in: self?.view)
				print(velocity)
			}).disposed(by: disposeBag)
	}
	
	private func lockCollectionView() {
		menuCV.isScrollEnabled = false
	}
}

extension MenuTabVC: UICollectionViewDelegate {
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		let yVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
		panGesture.isEnabled = true
		if yVelocity > 300 && scrollView.contentOffset.y == 0 {
			panGesture.isEnabled = true
			delegate?.childViewScrollDidEnd(type: .menu)
			return
		} else {
			
		}
		
		if yVelocity < 0 && topScrollAnimationNotFinished {
			menuCV.isScrollEnabled = false
		} else {
			panGesture.isEnabled = true
		}
		delegate?.scrollStarted(velocity: yVelocity, scrollView: scrollView)
	}
	
	// 손가락을 놓을때 처리하는 부분
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		panGesture.isEnabled = false
		menuCV.isScrollEnabled = true
	}
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		print(velocity)
		print(targetContentOffset.pointee.y)
		if velocity.x == 0 &&
			velocity.y < 0 {
			swipeDismissDelegate?.swipeToDismiss()
		}
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y <= 0 {
			delegate?.childViewScrollDidEnd(type: .menu)
		}
	}
		
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y == 0 {
//			panGesture.isEnabled = true
		}
		delegate?.currentTabMenu(.menu)
	}
}

extension MenuTabVC: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return MenuDataModel.sampleMenuData.count
	}
		
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = menuCV.dequeueReusableCell(withReuseIdentifier: MenuCellCVC.className, for: indexPath) as? MenuCellCVC
		else { return UICollectionViewCell() }
		cell.setData(menuData: MenuDataModel.sampleMenuData[indexPath.row])
		cell.changeCustomView(isMenu: isMenu)
		return cell
	}
}

extension MenuTabVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UIScreen.main.bounds.width
		
		let cellWidth = width * (335/375)
		let cellHeight = cellWidth * (120/335)
		
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 20, left: 20, bottom: 120, right: 20)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
}

// MARK: - Network

extension MenuTabVC {
	
}

extension MenuTabVC: MenuCVCDelegate {
	func controlSegement() {
		self.isMenu.toggle()
		menuCV.reloadData()
	}
}

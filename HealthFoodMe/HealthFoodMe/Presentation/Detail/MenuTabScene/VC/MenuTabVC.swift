//
//  menuVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/05.
//

import UIKit

import SnapKit

protocol ScrollDeliveryDelegate: AnyObject {
	func scrollStarted(velocity: CGFloat, scrollView: UIScrollView)
	func childViewScrollDidEnd(type: TabMenuCase)
	func currentTabMenu(_ type: TabMenuCase)
}

enum TabMenuCase {
	case menu
	case coping
	case review
}

final class MenuTabVC: UIViewController {
	
	// MARK: - Properties
	
	var isMenu: Bool = true
	var topScrollAnimationNotFinished: Bool = true
	weak var delegate: ScrollDeliveryDelegate?
	
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
	}
}

// MARK: - Methods

extension MenuTabVC {
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
	
	private func lockCollectionView() {
		menuCV.isScrollEnabled = false
	}
}

extension MenuTabVC: UICollectionViewDelegate {
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		
		let yVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
		print(yVelocity)
		print(scrollView.contentOffset.y)
		if yVelocity > 300 && scrollView.contentOffset.y == 0 {
			delegate?.childViewScrollDidEnd(type: .menu)
			return
		}
		
		if yVelocity < 0 && topScrollAnimationNotFinished {
			menuCV.isScrollEnabled = false
		}
		delegate?.scrollStarted(velocity: yVelocity, scrollView: scrollView)
	}
	
	// 손가락을 놓을때 처리하는 부분
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		menuCV.isScrollEnabled = true
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		print("scrollViewCONTENTOFFSET",scrollView.contentOffset.y)
		if scrollView.contentOffset.y <= 0{
			delegate?.childViewScrollDidEnd(type: .menu)
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

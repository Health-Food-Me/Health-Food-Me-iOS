//
//  menuVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/05.
//

import UIKit

import SnapKit
import RxSwift
import ImageSlideShowSwift

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

enum SectionLayout: CaseIterable {
	case menu, menuImage
}

final class MenuTabVC: UIViewController {
	
	// MARK: - Properties
	
	var isMenu: Bool = true
	var topScrollAnimationNotFinished: Bool = true
	var menuData: [MenuDataModel] = [] {
		didSet {
			DispatchQueue.main.async {
				self.menuCV.reloadData()
			}
		}
	}
	let panGesture = UIPanGestureRecognizer()
	weak var delegate: ScrollDeliveryDelegate?
	var swipeDismissDelegate: SwipeDismissDelegate?
	private var disposeBag = DisposeBag()
	
	// MARK: - UI Components
	
	//	private var headerView = HeaderView()
	
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
		addObserver()
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
//		headerView.delegate = self
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
		AllImageCVC.register(target: menuCV)
		menuCV.register(ImageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImageHeaderView.className)
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
	
	func setData(data: [Menu]) {
		var models: [MenuDataModel] = []
		data.forEach {
			models.append($0.toDomain())
		}
		
		var pickModel: [MenuDataModel] = []
		var notPickModel: [MenuDataModel] = []
		
		models.forEach { data in
			if data.isPick {
				pickModel.append(data)
			} else {
				notPickModel.append(data)
			}
		}
		pickModel += notPickModel
		
		self.menuData = pickModel
	}
	
	private func addObserver() {
		addObserverAction(.menuPhotoClicked) { noti in
			if let slideData = noti.object as? ImageSlideDataModel {
				self.clickPhotos(index: slideData.clickedIndex, urls: slideData.imgURLs)
			}
		}
	}
	
	func clickPhotos(index: Int,urls: [String]){
		let images :[ImageSlideShowProtocol] = urls.enumerated().map { index,url in
			
			ImageForSlide(title: "\(index+1)/\(urls.count)", url: URL(string: url)!)
		}
		
		ImageSlideShowViewController.presentFrom(self) { controller in
			controller.navigationBarTintColor = .black
			controller.navigationController?.navigationBar.backgroundColor = .black
			controller.navigationController?.navigationBar.barTintColor = .black
			controller.navigationController?.navigationBar.tintColor = .black
			controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
			
			controller.dismissOnPanGesture = true
			controller.slides = images
			controller.enableZoom = true
			controller.initialIndex = index
			controller.view.backgroundColor = .black
		}
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
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let sectionType = SectionLayout.allCases[section]
		let count : Int = sectionType == .menu ? menuData.count : 1
		return count
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ImageHeaderView", for: indexPath)
			return header
		}
		return UICollectionReusableView()
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let sectionType = SectionLayout.allCases[indexPath.section]
		switch sectionType{
		case .menu:
			guard let menuCell = menuCV.dequeueReusableCell(withReuseIdentifier: MenuCellCVC.className, for: indexPath) as? MenuCellCVC
			else { return UICollectionViewCell() }
			menuCell.setData(menuData: menuData[indexPath.row])
			menuCell.changeCustomView(isMenu: isMenu)
			return menuCell
		case .menuImage:
			guard let imageCell = menuCV.dequeueReusableCell(withReuseIdentifier: AllImageCVC.className, for: indexPath) as? AllImageCVC
			else { return UICollectionViewCell() }
			return imageCell
		}
	}
}

extension MenuTabVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UIScreen.main.bounds.width
		
		let cellWidth = width * (335/375)
		let cellHeight = cellWidth * (120/335)
		
		return CGSize(width: cellWidth, height: cellHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		let sectionType = SectionLayout.allCases[section]
		switch sectionType{
		case .menu:
			return CGSize(width: collectionView.frame.width, height: 0)
		case .menuImage:
			return CGSize(width: collectionView.frame.width, height: 34)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		let sectionType = SectionLayout.allCases[section]
		switch sectionType{
		case .menu:
			return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		case .menuImage:
			return UIEdgeInsets(top: 6, left: 20, bottom: 120, right: 20)
		}
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

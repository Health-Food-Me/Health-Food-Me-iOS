//
//  MainInfoTVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class DetailTabTVC: UITableViewCell, UITableViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib: Bool = false
    let disposeBag = DisposeBag()
    let scrollRatio = PublishRelay<CGFloat>()
    let scrollStart = PublishRelay<Int>()
    let scrollEnded = PublishRelay<Int>()
    var childControllers = [UIViewController]() {
        didSet {
            containerCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Components
    
    lazy var containerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-104)
        layout.minimumLineSpacing = .zero
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-104), collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.backgroundColor = .white
        cv.bounces = false
        
        return cv
    }()
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
        setDelegate()
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension DetailTabTVC {
    
    private func setDelegate() {
        containerCollectionView.delegate = self
        containerCollectionView.dataSource = self
    }
    
    private func registerCell() {
        TabContainerCVC.register(target: containerCollectionView)
    }
    
    private func setLayout() {
        self.contentView.addSubviews(containerCollectionView)
        
        containerCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Initializer
    
    func scrollToSelectedIndex(index: Int) {
        containerCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func receiveChildVC(childVC: UIViewController) {
        if !childControllers.contains(childVC) {
            childControllers.append(childVC)
        }
    }
}

// MARK: - CollectionView Delegate

extension DetailTabTVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scroll = scrollView.contentOffset.x + scrollView.contentInset.left
        let width = scrollView.contentSize.width + scrollView.contentInset.left + scrollView.contentInset.right
        let scrollRatio = scroll / width
        self.scrollRatio.accept(scrollRatio)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scroll = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let scrollIndex = Int(scroll / width)
        self.scrollEnded.accept(scrollIndex)
    }
}

extension DetailTabTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabContainerCVC.className, for: indexPath) as? TabContainerCVC else { return UICollectionViewCell() }
        
        if indexPath.item == 0,
           childControllers.count > 0 {
            cell.addSubview(childControllers[indexPath.item].view)
            childControllers[indexPath.item].view.frame = cell.bounds
        } else if indexPath.item == 1 && childControllers.count > 1 {
            cell.addSubview(childControllers[indexPath.item].view)
            childControllers[indexPath.item].view.frame = cell.bounds
        } else if indexPath.item == 2 && childControllers.count > 2 {
            cell.addSubview(childControllers[indexPath.item].view)
            childControllers[indexPath.item].view.frame = cell.bounds
        }
        
        return cell
    }
}

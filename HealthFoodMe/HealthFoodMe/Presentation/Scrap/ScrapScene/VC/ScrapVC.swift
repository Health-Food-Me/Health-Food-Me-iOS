//
//  ScrapVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/14.
//

import UIKit

import SnapKit

class ScrapVC: UIViewController {
    
    // MARK: - Properties
    
    private let scrapTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()
    
    private let scrapBackButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Scrap.beforeIcon, for: .normal)
        return btn
    }()
    
    private let scrapTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Scrap.scrapTitle
        lb.font = .NotoBold(size: 16)
        return lb
    }()
    
    private let scrapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
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

extension ScrapVC {
    private func setUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(scrapTopView,
                         lineView,
                         scrapCollectionView)
        
        scrapTopView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        scrapTopView.addSubviews(scrapBackButton, scrapTitleLabel)
        
        scrapBackButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(scrapTopView)
        }
        
        scrapTitleLabel.snp.makeConstraints {
            $0.center.equalTo(scrapTopView)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(scrapTopView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        scrapCollectionView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        scrapCollectionView.delegate = self
        scrapCollectionView.dataSource = self
    }
    
    private func registerCell() {
        ScrapCVC.register(target: scrapCollectionView)
    }
}

// MARK: - UICollectionViewDelegate

extension ScrapVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension ScrapVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ScrapDataModel.sampleScrapData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrapCVC.className, for: indexPath) as? ScrapCVC else { return UICollectionViewCell() }
        cell.setData(data: ScrapDataModel.sampleScrapData[indexPath.row])
        return cell
    }
}

extension ScrapVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width

        let cellWidth = width * (160/375)
        let cellHeight = cellWidth * (232/160)

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 15, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

// MARK: - Network

extension ScrapVC {
    
}

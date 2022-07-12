//
//  MapDetailSummaryView.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/12.
//

import UIKit

import SnapKit

final class MapDetailSummaryView: UIView {
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = ImageLiterals.MainDetail.tempMuseum
        return iv
    }()
    
    private let titleTagStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 6
        st.distribution = .fillProportionally
        st.alignment = .leading
        return st
    }()
    
    private let restaurantNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "서브웨이 동대문역사문화공원역점"
        lb.textColor = .helfmeBlack
        lb.lineBreakMode = .byWordWrapping
        lb.numberOfLines = 0
        lb.font = .NotoBold(size: 16)
        return lb
    }()
    
    private let starRateStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 2
        st.distribution = .fillProportionally
        st.alignment = .leading
        return st
    }()
    
    private let starStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 2
        st.distribution = .equalSpacing
        return st
    }()
    
    private let rateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "(4.3)"
        lb.textColor = .lightGray
        lb.font = .NotoRegular(size: 12)
        return lb
    }()
    
    private lazy var tagCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: TagCVCFlowLayout())
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        return cv
    }()
    
    // MARK: View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setDelegate()
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension MapDetailSummaryView {
    func setData() {
        
    }
   
    private func setUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 13
        self.layer.applyShadow(color: .helfmeBlack, alpha: 0.1, x: 0, y: -3, blur: 4, spread: 0)
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(140)
        }
        
        self.addSubviews(logoImageView, titleTagStackView)
        
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(15)
            make.width.height.equalTo(112)
        }
        
        titleTagStackView.addArrangedSubviews(restaurantNameLabel, starRateStackView, tagCollectionView)
        starRateStackView.addArrangedSubviews(starStackView, rateLabel)
        setStarStackView()
        
        restaurantNameLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.height.equalTo(13)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(23)
        }
        
        titleTagStackView.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(16)
            make.centerY.equalTo(logoImageView)
        }
    }
    
    private func setStarStackView() {
        for starNumber in 1...5 {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            imageView.contentMode = .scaleAspectFill
            if starNumber < 5 {
                imageView.image = ImageLiterals.MainDetail.starIcon_filled
            } else {
                imageView.image = ImageLiterals.MainDetail.starIcon
            }
            imageView.tag = starNumber
            starStackView.addArrangedSubviews(imageView)
        }
    }
    
    private func setDelegate() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    private func registerCell() {
        TagSummaryCVC.register(target: tagCollectionView)
    }
}

extension MapDetailSummaryView: UICollectionViewDelegate {

}

extension MapDetailSummaryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: MainMapCategory.categorySample[indexPath.row].menuName.size(withAttributes: [NSAttributedString.Key.font: UIFont.NotoRegular(size: 10)]).width + 20, height: 18)
    }
    
    
    // TODO: - 태그 데이터 가져와서 컬렉션뷰 높이 조정해주기
    
    private func isDoubleLineHeight(tags: [String]) -> Bool {
        var width: CGFloat = 0
        tags.forEach { tag in
            width += tag.size(withAttributes: [NSAttributedString.Key.font: UIFont.NotoRegular(size: 10)]).width
        }
        return width > 200
    }
}

extension MapDetailSummaryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagSummaryCVC.className, for: indexPath) as? TagSummaryCVC else { return UICollectionViewCell() }
        cell.setData(tag: MainMapCategory.categorySample[indexPath.row].menuName)
        return cell
    }
}

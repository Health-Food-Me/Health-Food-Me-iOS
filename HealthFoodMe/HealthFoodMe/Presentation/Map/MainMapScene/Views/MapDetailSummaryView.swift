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
    
    private let grabLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeGray1.withAlphaComponent(0.3)
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = ImageLiterals.MainDetail.tempMuseum
        return iv
    }()
    
    private lazy var scrapButton: UIButton =  {
        let bt = UIButton()
        bt.setImage(ImageLiterals.MainDetail.scrapIcon, for: .normal)
        bt.setImage(ImageLiterals.MainDetail.scrapIcon_filled, for: .selected)
        bt.addAction(UIAction(handler: { _ in
            bt.isSelected.toggle()
        }), for: .touchUpInside)
        return bt
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
        st.distribution = .fillEqually
        st.alignment = .leading
        return st
    }()
    
    private let starRateView: StarRatingView = {
        let st = StarRatingView(starScale: 14)
        st.rate = 4.3
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
        }
        
        self.addSubviews(grabLineView, logoImageView, scrapButton,
                         titleTagStackView)
        
        grabLineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(3)
            make.width.equalTo(70)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(grabLineView.snp.bottom).offset(28)
            make.width.height.equalTo(112)
        }
        
        scrapButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        titleTagStackView.addArrangedSubviews(restaurantNameLabel, starRateStackView, tagCollectionView)
        starRateStackView.addArrangedSubviews(starRateView, rateLabel)
        
        starRateView.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.centerY.equalToSuperview()
        }
        
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

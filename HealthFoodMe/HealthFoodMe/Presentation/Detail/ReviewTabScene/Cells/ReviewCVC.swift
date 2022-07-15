//
//  ReviewCVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/13.
//

import UIKit

class ReviewCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    private var cellViewModel: ReviewDataModel? {
        didSet {
            tagCV.reloadData()
            reviewPhotoCV.reloadData()
        }
    }
    
    var setEnumValue = 0
    
    let width = UIScreen.main.bounds.width
    
    // MARK: - UI Components
    
    private var nameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoMedium(size: 14)
        lb.text = ""
        return lb
    }()
    
    private var starView: StarRatingView = {
        let st = StarRatingView(starScale: 18)
        st.spacing = 2
        return st
    }()
    
    private var tagCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.estimatedItemSize = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .helfmeWhite
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    private var reviewPhotoCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .helfmeWhite
        cv.showsHorizontalScrollIndicator = false

        return cv
    }()
    
    private var reviewContents: UITextView = {
        let tv = UITextView()
        tv.textColor = .helfmeBlack
        tv.font = UIFont.NotoRegular(size: 12)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.text = " "
        return tv
    }()
    
    lazy var blogReviewSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.helfmeCardlineGray
        return view
    }()
    
    // MARK: - Life Cycle Part
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDelegate()
        registerCell()
        setDefaultLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        nameLabel.text = " "
        reviewContents.text = " "
        reviewPhotoCV.isHidden = false
        reviewContents.isHidden = false
    }
}

// MARK: - Methods

extension ReviewCVC {
    func setDelegate() {
        tagCV.delegate = self
        tagCV.dataSource = self
        reviewPhotoCV.dataSource = self
        reviewPhotoCV.delegate = self
    }
    
    func registerCell() {
        TagCVC.register(target: tagCV)
        ReviewPhotoCVC.register(target: reviewPhotoCV)
    }
    
    func setDefaultLayout() {
        contentView.addSubviews(nameLabel, starView, tagCV,
                                reviewPhotoCV, reviewContents, blogReviewSeperatorView)
        
        let width = UIScreen.main.bounds.width
        
        blogReviewSeperatorView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalTo(width - 40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(blogReviewSeperatorView.snp.bottom).offset(28)
            make.height.equalTo(nameLabel.font.lineHeight)
        }
        
        starView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(18)
            make.width.equalTo(86)
        }
        
        tagCV.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(22)
        }
        
        reviewPhotoCV.snp.makeConstraints { make in
            make.top.equalTo(tagCV.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.height.equalTo(width * (105/375))
            make.width.equalToSuperview()
        }
        
        reviewContents.snp.makeConstraints { make in
            make.top.equalTo(reviewPhotoCV.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-28)
            make.width.equalTo(50)
        }
    }
    
    func setLayout() {
        switch setEnumValue {
        case 0:
            setLayoutWithImageAndContents()
        case 1:
            setLayoutWithImage()
        case 2:
            setLayoutWithContents()
        case 3:
            setLayoutWithImageAndContents()
        default:
            setLayoutOnlyTag()
        }
        layoutIfNeeded()
    }
    
    func setLayoutOnlyTag() {
        
        reviewContents.isHidden = true
        reviewPhotoCV.isHidden = true
    }
    
    func setLayoutWithContents() {
        
        reviewContents.isHidden = false
        
        reviewContents.snp.remakeConstraints { make in
            make.top.equalTo(tagCV.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-28)
        }
    }
    
    func setLayoutWithImage() {
        
        let width = UIScreen.main.bounds.width
        reviewContents.isHidden = true
        
        reviewPhotoCV.snp.remakeConstraints { make in
            make.top.equalTo(tagCV.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.height.equalTo(width * (105/375))
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-28)
        }
    }

    func setLayoutWithImageAndContents() {
        let width = UIScreen.main.bounds.width
        reviewContents.isHidden = false
        
        reviewPhotoCV.snp.remakeConstraints { make in
            make.top.equalTo(tagCV.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.height.equalTo(width * (105/375))
            make.width.equalToSuperview()
        }
        
        reviewContents.snp.remakeConstraints { make in
            make.top.equalTo(reviewPhotoCV.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-28)
        }
    }
    
    func setData(reviewData: ReviewDataModel) {
        nameLabel.text = reviewData.reviewer
        nameLabel.sizeToFit()
        starView.rate = CGFloat(reviewData.starLate)
        self.cellViewModel = reviewData
        reviewContents.text = reviewData.reviewContents
        reviewContents.sizeToFit()
        self.contentView.layoutIfNeeded()
    }
}

extension ReviewCVC: UICollectionViewDelegate {
}

extension ReviewCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCV {
            return self.cellViewModel?.tagList.count ?? 0
        } else {
            return self.cellViewModel?.reviewImageURLList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case tagCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCVC.className, for: indexPath) as? TagCVC else { return UICollectionViewCell() }
            if let data = cellViewModel {
                cell.setData(tagData: data.tagList[indexPath.row])
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.mainRed.cgColor
                cell.layer.cornerRadius = 11
                cell.layer.masksToBounds = true
            }
            return cell
        case reviewPhotoCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewPhotoCVC.className, for: indexPath) as? ReviewPhotoCVC
            else { return UICollectionViewCell() }
            if let data = cellViewModel,
               let imageURL = data.reviewImageURLList?[indexPath.row] {
                cell.setData(photoData: imageURL)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ReviewCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case tagCV:
            return 4
        case reviewPhotoCV:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case tagCV:
            return 4
        case reviewPhotoCV:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        switch collectionView {
        case tagCV:
            guard let cellViewModel = cellViewModel else { return .zero }
            let tagWidth = calculateTagCellWidth(cellViewModel.tagList[indexPath.row])
            if tagWidth < 95 {
                return CGSize(width: tagWidth, height: 22)
            } else {
                return CGSize(width: 95, height: 22)
            }
        case reviewPhotoCV:
            let cellWidth = width * (105/375)
            let cellHeight = cellWidth * (105/105)
            return CGSize(width: cellWidth, height: cellHeight)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    private func calculateTagCellWidth(_ tag: String) -> CGFloat {
        let label = UILabel()
        label.font = .NotoRegular(size: 10)
        label.text = tag
        label.sizeToFit()
        return label.frame.width + 20
    }
}

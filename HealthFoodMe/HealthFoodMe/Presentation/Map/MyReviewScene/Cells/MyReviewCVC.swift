//
//  MyReviewCVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/19.
//

import UIKit

protocol MyReviewCVCDelegate: AnyObject {
    func restaurantNameTapped(restaurantId: String)
    func editButtonTapped(reviewId: String, restaurantName: String)
    func deleteButtonTapped(reviewId: String)
}

class MyReviewCVC: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static var isFromNib = false
    
    weak var delegate: MyReviewCVCDelegate?
    
    private var cellViewModel: MyReviewModel? {
        didSet {
            tagCV.reloadData()
            reviewPhotoCV.reloadData()
        }
    }
    
    let width = UIScreen.main.bounds.width
    var layoutEnumValue = 0
    var clickedEvent: ((Int) -> Void)?
    var isFolded: Bool = true
    var lineNumber: Int?
    var entitleHeight: CGFloat?
    var reviewId : String = ""
    var restaurantId: String = ""
    var restaurantName: String = ""
    
    // MARK: - UI Components
    
    private var restaurantNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoMedium(size: 14)
        lb.text = ""
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.image = ImageLiterals.Map.arrowRightIcon
        return iv
    }()
    
    private var starView: StarRatingView = {
        let st = StarRatingView(starScale: 18)
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
    
    private lazy var buttonStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 8
        st.distribution = .equalSpacing
        st.isUserInteractionEnabled = true
        return st
    }()
    
    private lazy var editButton: UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = .NotoRegular(size: 10)
        bt.setTitle("편집", for: .normal)
        bt.setTitleColor(UIColor.helfmeGray2, for: .normal)
        bt.addAction(UIAction(handler: { _ in
            self.delegate?.editButtonTapped(reviewId: self.reviewId, restaurantName: self.restaurantName)
        }), for: .touchUpInside)
        return bt
    }()
    
    private let verticalView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeGray1.withAlphaComponent(0.3)
        view.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(1)
        }
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = .NotoRegular(size: 10)
        bt.setTitle("삭제", for: .normal)
        bt.setTitleColor(UIColor.helfmeGray2, for: .normal)
        bt.addAction(UIAction(handler: { _ in
            self.delegate?.deleteButtonTapped(reviewId: self.reviewId)
        }), for: .touchUpInside)
        return bt
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
    
    private var reviewContents: UILabel = {
        let lb = UILabel()
        lb.textColor = .helfmeBlack
        lb.font = UIFont.NotoRegular(size: 12)
        lb.numberOfLines = 0
        lb.lineBreakMode = .byTruncatingTail
        lb.text = " "
        return lb
    }()
    
    lazy var reviewSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.helfmeCardlineGray
        return view
    }()
    
    lazy var moreTapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.press {
            guard let index = self.getIndexPath() else { return }
            self.clickedEvent?(index)
        }
        return button
    }()
    
    // MARK: - Life Cycle Part
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDelegate()
        registerCell()
        setDefaultLayout()
        setTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        restaurantNameLabel.text = " "
        reviewContents.text = " "
        reviewPhotoCV.isHidden = false
        reviewContents.isHidden = false
    }
}

// MARK: - Methods

extension MyReviewCVC {
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
        contentView.addSubviews(arrowImageView, restaurantNameLabel, buttonStackView,
                                starView, tagCV, reviewPhotoCV,
                                reviewContents, reviewSeperatorView, moreTapButton)
        
        let width = UIScreen.main.bounds.width
        
        reviewSeperatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(1)
            make.width.equalTo(width - 40)
        }
        
        restaurantNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(reviewSeperatorView.snp.bottom).offset(28)
            make.height.equalTo(restaurantNameLabel.font.lineHeight)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(restaurantNameLabel.snp.centerY)
            make.leading.equalTo(restaurantNameLabel.snp.trailing).offset(-8)
            make.width.height.equalTo(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(restaurantNameLabel.snp.centerY)
        }
        
        buttonStackView.addArrangedSubviews(editButton, verticalView, deleteButton)
        
        editButton.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
        
        starView.snp.makeConstraints { make in
            make.leading.equalTo(restaurantNameLabel.snp.leading)
            make.top.equalTo(restaurantNameLabel.snp.bottom).offset(8)
            make.height.equalTo(18)
            make.width.equalTo(86)
        }
        
        tagCV.snp.makeConstraints { make in
            make.top.equalTo(starView.snp.bottom).offset(10)
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
            make.top.equalTo(reviewPhotoCV.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-28)
            make.width.equalTo(width - 40)
        }
        
        moreTapButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-28)
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(width - 40)
            make.height.equalTo(60)
        }
    }
    
    func setLayout() {
        switch layoutEnumValue {
        case 0:
            setLayoutWithImageAndContents()
        case 1:
            setLayoutWithImage()
        case 2:
            setLayoutWithContents()
        case 3:
            setLayoutOnlyTag()
        default:
            setLayoutOnlyTag()
        }
        layoutIfNeeded()
        contentView.layoutIfNeeded()
    }
    
    func setLayoutOnlyTag() {
        reviewPhotoCV.removeFromSuperview()
        reviewContents.removeFromSuperview()
        reviewContents.isHidden = true
        reviewPhotoCV.isHidden = true
    }
    
    func setLayoutWithContents() {
        
        reviewPhotoCV.removeFromSuperview()
        addSubviews(reviewContents)
        reviewContents.isHidden = false
        
        reviewContents.snp.remakeConstraints { make in
            make.top.equalTo(tagCV.snp.bottom).offset(10)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-28)
            make.width.equalTo(width - 40)
        }
    }
    
    func setLayoutWithImage() {
        reviewContents.removeFromSuperview()
        contentView.addSubviews(reviewPhotoCV)
        
        reviewPhotoCV.snp.remakeConstraints { make in
            make.top.equalTo(tagCV.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.height.equalTo(width * (105/375))
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-28)
        }
    }
    
    func setLayoutWithImageAndContents() {
        
        addSubviews(reviewPhotoCV, reviewContents)
        
        let width = UIScreen.main.bounds.width
        reviewContents.isHidden = false
        reviewPhotoCV.isHidden = false
        
        reviewPhotoCV.snp.remakeConstraints { make in
            make.top.equalTo(tagCV.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.height.equalTo(width * (105/375))
            make.width.equalToSuperview()
        }
        
        reviewContents.snp.remakeConstraints { make in
            make.top.equalTo(reviewPhotoCV.snp.bottom).offset(12)
            make.leading.bottom.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-28)
            make.width.equalTo(width - 40)
        }
    }
    
    func setData(reviewData: MyReviewModel,
                 text: String,
                 isFoldRequired: Bool,
                 expanded: Bool) {
        restaurantNameLabel.text = reviewData.restaurantName + "  "
        restaurantNameLabel.sizeToFit()
        starView.rate = CGFloat(reviewData.starRate)
        self.cellViewModel = reviewData
        reviewContents.text = text
        reviewContents.sizeToFit()
        reviewId = reviewData.reviewId
//        restaurantId = reviewData.
        restaurantName = reviewData.restaurantName
        
        if isFoldRequired {
            moreTapButton.isHidden = false
        } else {
            moreTapButton.isHidden = true
        }
        
        if !expanded {
            if isFoldRequired {
                setPartContentsAttributes()
            }
        } else {
            let attributedString = NSMutableAttributedString(string: text)
            reviewContents.attributedText = attributedString
        }
        
        self.contentView.layoutIfNeeded()
    }
    
    private func getIndexPath() -> Int? {
        guard let superView = self.superview as? UICollectionView else {
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath?.row
    }
    
    func setPartContentsAttributes() {
        var textCount = 0
        var length = 0
        if reviewContents.text?.count ?? 0 < 3 {
            textCount = 3
            length = reviewContents.text?.count ?? 0
        } else {
            textCount = reviewContents.text?.count ?? 0
            length = 3
        }
        let fullText = reviewContents.text
        let range = NSRange(location: textCount - 3, length: length)
        
        let attributedString = NSMutableAttributedString(string: fullText ?? "")
        attributedString.addAttribute(.font, value: UIFont.NotoRegular(size: 12), range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.helfmeGray2, range: range)
        reviewContents.attributedText = attributedString
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushMainDetailVC))
        restaurantNameLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func pushMainDetailVC() {
        delegate?.restaurantNameTapped(restaurantId: restaurantId)
    }
}

extension MyReviewCVC: UICollectionViewDelegate {
}

extension MyReviewCVC: UICollectionViewDataSource {
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

extension MyReviewCVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case tagCV:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        case reviewPhotoCV:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        default:
            return .zero
        }
    }
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

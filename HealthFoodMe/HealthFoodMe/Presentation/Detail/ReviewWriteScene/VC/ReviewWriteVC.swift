//
//  ReviewWriteVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/12.
//

import UIKit

import SnapKit

class ReviewWriteVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var restaurantTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "샐러디 태릉입구점"
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 16)
        return lb
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()
    
    private let questionTasteLabel: UILabel = {
        let lb = UILabel()
        lb.text = "맛은 어때요?"
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 14)
        return lb
    }()
    
    private let questionTasteSubLabel: UILabel = {
        let lb = UILabel()
        lb.text = "필수 한 개 선택해주세요! "
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 12)
        return lb
    }()
    
    private lazy var questionTasteStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 4
        sv.addArrangedSubviews(questionTasteLabel, questionTasteSubLabel)
        return sv
    }()
    
    private lazy var tagGood: UIButton = {
        let btn = UIButton()
        btn.setTitle("맛최고", for: .normal)
        btn.tintColor = .helfmeBlack
        btn.backgroundColor = .helfmeLineGray
        return btn
    }()
    
    private lazy var tagSoso: UIButton = {
        let btn = UIButton()
        btn.setTitle("맛그럭저럭", for: .normal)
        btn.tintColor = .helfmeBlack
        btn.backgroundColor = .helfmeLineGray
        return btn
    }()
    
    private lazy var tagBad: UIButton = {
        let btn = UIButton()
        btn.setTitle("맛 별로", for: .normal)
        btn.tintColor = .helfmeBlack
        btn.backgroundColor = .helfmeLineGray
        return btn
    }()
    
    private lazy var tagTasteStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 6
        sv.addArrangedSubviews(tagGood, tagSoso, tagBad)
        return sv
    }()

    private let questionFeelingLabel: UILabel = {
        let lb = UILabel()
        lb.text = "어떤 점이 좋았나요?"
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 14)
        return lb
    }()
    
    private let questionFeelingSubLabel: UILabel = {
        let lb = UILabel()
        lb.text = "식당을 방문하신 후 좋았던 부분에 체크해주세요! (중복가능)"
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 12)
        return lb
    }()
    
    private lazy var questionFeelingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 4
        sv.addArrangedSubviews(questionFeelingLabel, questionFeelingSubLabel)
        return sv
    }()
    
    private lazy var tagDiet: UIButton = {
        let btn = UIButton()
        btn.setTitle("다이어트용", for: .normal)
        btn.tintColor = .helfmeBlack
        btn.backgroundColor = .helfmeLineGray
        return btn
    }()
    
    private lazy var tagHealthFood: UIButton = {
        let btn = UIButton()
        btn.setTitle("건강식", for: .normal)
        btn.tintColor = .helfmeBlack
        btn.backgroundColor = .helfmeLineGray
        return btn
    }()
    
    private lazy var tagCheet: UIButton = {
        let btn = UIButton()
        btn.setTitle("치팅데이용", for: .normal)
        btn.tintColor = .helfmeBlack
        btn.backgroundColor = .helfmeLineGray
        return btn
    }()
    
    private lazy var tagHelpfulStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 6
        sv.addArrangedSubviews(tagDiet, tagHealthFood, tagCheet)
        return sv
    }()
    
    private let reviewLabel: UILabel = {
        let lb = UILabel()
        lb.text = "후기를 남겨주세요."
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 14)
        return lb
    }()
    
    private let reviewSubLabel: UILabel = {
        let lb = UILabel()
        lb.text = "식당 이용 후기, 메뉴추천, 꿀팁 등 자유롭게 작성해주세요!"
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 12)
        return lb
    }()
    
    private lazy var reviewStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 4
        sv.addArrangedSubviews(reviewLabel, reviewSubLabel)
        return sv
    }()
    
    private lazy var reviewTextVeiw: UITextView = {
        let tv = UITextView()
        tv.text = "리뷰를 작성해주세요 (최대 500자)"
        tv.textColor = .helfmeGray2
        tv.backgroundColor = .helfmeBgGray
        tv.layer.cornerRadius = 8
        return tv
    }()
    
    private let pictureLabel: UILabel = {
        let lb = UILabel()
        lb.text = "사진을 올려주세요"
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 14)
        return lb
    }()
    
    private let pictureOptionLabel: UILabel = {
        let lb = UILabel()
        lb.text = "(선택)"
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 10)
        return lb
    }()
    
    private lazy var pictureStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 6
        sv.addArrangedSubviews(pictureLabel, pictureOptionLabel)
        return sv
    }()
    
    private lazy var photoCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setNavigation()
        setLayout()
    }
}

// MARK: - Methods

extension ReviewWriteVC {
    private func setDelegate() {
        scrollView.delegate = self
        reviewTextVeiw.delegate = self
    }
    
    private func setNavigation() {
        self.navigationItem.title = "리뷰 작성"
    }
    
    private func setLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubviews(restaurantTitleLabel, lineView, questionTasteStackView, tagTasteStackView, questionFeelingStackView, tagHelpfulStackView, reviewStackView, reviewTextVeiw, pictureStackView)
        
        restaurantTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(restaurantTitleLabel.snp.bottom).offset(67)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        questionTasteStackView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        tagTasteStackView.snp.makeConstraints { make in
            make.top.equalTo(questionTasteStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        questionFeelingStackView.snp.makeConstraints { make in
            make.top.equalTo(tagTasteStackView.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(20)
        }
        
        tagHelpfulStackView.snp.makeConstraints { make in
            make.top.equalTo(questionFeelingStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        reviewStackView.snp.makeConstraints { make in
            make.top.equalTo(tagHelpfulStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        reviewTextVeiw.snp.makeConstraints { make in
            make.top.equalTo(reviewStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(277)
        }
        
        pictureStackView.snp.makeConstraints { make in
            make.top.equalTo(reviewTextVeiw.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Network

extension ReviewWriteVC {
    
}
//extension ReviewWriteVC: UICollectionViewDelegate, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photoModel.userSelectedImages.count + 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let addPhotoIdentifier = AddPhotoCVC.identifier
//        let listPhotoIdentifer = ListPhotoCVC.identifier
//
//        switch indexPath.item {
//        case Cell.addCell.rawValue:
//            guard let addPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: addPhotoIdentifier, for: indexPath) as? AddPhotoCVC else { fatalError("Failed to dequeue cell for AddPhotoCVC") }
//            addPhotoCell.delegate = self
//            addPhotoCell.countLabel.textColor =  photoModel.userSelectedImages.count == 0 ? UIColor(named: "carrot_linegray") : UIColor(named: "carrot_text_orange")
//            addPhotoCell.countLabel.text = "\(photoModel.userSelectedImages.count)"
//            return addPhotoCell
//        default:
//            guard let listPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: listPhotoIdentifer, for: indexPath) as? ListPhotoCVC else { fatalError("Failed to dequeue cell for ListPhotoCVC") }
//            listPhotoCell.delegate = self
//            listPhotoCell.indexPath = indexPath.item
//
//            if photoModel.userSelectedImages.count > 0 {
//                listPhotoCell.photoImageView.image = photoModel.userSelectedImages[indexPath.item - 1]
//            }
//            return listPhotoCell
//        }
//    }
//}
//
//extension ReviewWriteVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 80, height: 80)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//}
//
//extension ReviewWriteVC: AddImageDelegate {
//    func didPickImagesToUpload(images: [UIImage]) {
//        photoModel.userSelectedImages = images
//    }
//}
//
//extension ReviewWriteVC: ListPhotoCVCDelegate {
//    func didPressDeleteBtn(at index: Int) {
//        photoModel.userSelectedImages.remove(at: index - 1)
//    }
//}

extension ReviewWriteVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .helfmeGray2 {
            textView.text = nil
            textView.textColor = .helfmeBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "리뷰를 작성해주세요 (최대 500자)"
            textView.textColor = .helfmeGray2
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if estimatedSize.height >= 277 {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}

//
//  ReviewWriteVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/12.
//

import UIKit
import Photos

import BSImagePicker
import SnapKit

enum Cell: Int {
    case addCell = 0, photoCell
}

final class ReviewWriteVC: UIViewController, UIScrollViewDelegate {
    
    var isEdited = false
    
    private var photoModel: PhotoDataModel = PhotoDataModel() {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    private var editPhotoModel: PhotoDataModel = PhotoDataModel()
    
    var userName = ""
    var userId = UserManager.shared.getUserId ?? ""
    var restaurantName : String = ""
    var restaurantID = ""
    var reviewId = ""
    var tasteSet = ""
    var feelingArray: [Bool] = [false, false, false]
    
    var currentRate: Double = 2.5
    var tagList: [String] = []
    var selectedAssets: [PHAsset] = [PHAsset]()
    var userSelectedImages: [UIImage] = [UIImage]()
    var content: String = ""
    var imageURLList: [String] = []
    
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
        lb.text = self.restaurantName
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 16)
        return lb
    }()
    
    let sliderView = StarRatingSlider(starWidth: 37)
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()
    
    private let questionTasteLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.questionTaste
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 14)
        return lb
    }()
    
    private let questionTasteSubLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.questionTasteSub
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
    
    private var selectedButton: Int = 0
    private var tasteTagButton: [UIButton] = []
    
    private lazy var tagGood: UIButton = {
        let btn = UIButton()
        btn.setTitle(I18N.Detail.Review.tagGood, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.tag = 0
        tasteTagButton.append(btn)
        return btn
    }()
    
    private lazy var tagSoso: UIButton = {
        let btn = UIButton()
        btn.setTitle(I18N.Detail.Review.tagSoso, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.tag = 1
        tasteTagButton.append(btn)
        return btn
    }()
    
    private lazy var tagBad: UIButton = {
        let btn = UIButton()
        btn.setTitle(I18N.Detail.Review.tagBad, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.tag = 2
        tasteTagButton.append(btn)
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
        lb.text = I18N.Detail.Review.questionFeeling
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 14)
        return lb
    }()
    
    private let questionFeelingSubLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.questionFeelingSub
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
    
    private lazy var tagNoBurden: UIButton = {
        let btn = UIButton()
        btn.setTitle(I18N.Detail.Review.tagNoBurden, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.tag = 0
        btn.addTarget(self, action: #selector(didTapFeelingTag), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tagEasy: UIButton = {
        let btn = UIButton()
        btn.setTitle(I18N.Detail.Review.tagEasy, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.tag = 1
        btn.addTarget(self, action: #selector(didTapFeelingTag), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tagStrong: UIButton = {
        let btn = UIButton()
        btn.setTitle(I18N.Detail.Review.tagStrong, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.tag = 2
        btn.addTarget(self, action: #selector(didTapFeelingTag), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var tagHelpfulStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 6
        sv.addArrangedSubviews(tagNoBurden, tagEasy, tagStrong)
        return sv
    }()
    
    private let reviewLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.questionReview
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 14)
        return lb
    }()
    
    private let reviewSubLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.questionReviewSub
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
    
    private let reviewView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeBgGray
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var reviewTextView: UITextView = {
        let tv = UITextView()
        tv.text = I18N.Detail.Review.reviewPlaceholder
        tv.font = .NotoRegular(size: 12)
        tv.textColor = .helfmeGray2
        tv.backgroundColor = .helfmeBgGray
        tv.showsHorizontalScrollIndicator = false
        return tv
    }()
    
    private lazy var textCountLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.reviewTextCount
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 12)
        return lb
    }()
    
    private let pictureLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.questionPhoto
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 14)
        return lb
    }()
    
    private let pictureOptionLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.questionPhotoOption
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
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private lazy var photoSubLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.Detail.Review.questionPhotoSub
        lb.numberOfLines = 2
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 10)
        return lb
    }()
    
    private lazy var writeReviewButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(I18N.Detail.Review.writeReview, for: .normal)
        btn.setTitleColor(UIColor.helfmeWhite, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoBold(size: 14)
        btn.backgroundColor = .mainRed
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(didTapWriteReview), for: .touchUpInside)
        return btn
    }()
    
    private lazy var checkReviewToastView: UpperToastView = {
        let toastView = UpperToastView(title: I18N.Detail.Review.checkReviewToast)
        toastView.layer.cornerRadius = 20
        toastView.alpha = 0
        return toastView
    }()
    
    private lazy var checkPhotoToastView: UpperToastView = {
        let toastView = UpperToastView(title: I18N.Detail.Review.checkPhotoToast)
        toastView.layer.cornerRadius = 20
        toastView.alpha = 0
        return toastView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setEditedUI()
        setNavigation()
        setLayout()
        registerCell()
        setTextView()
        addTapGesture()
        bindSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setAddTargets()
    }
}

// MARK: - Methods

extension ReviewWriteVC {
    private func setTextView() {
        addToolBar(textView: reviewTextView)
    }
    
    private func setDelegate() {
        scrollView.delegate = self
        reviewTextView.delegate = self
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    private func setEditedUI(){
        if isEdited {
            sliderView.setSliderValue(rate: self.currentRate)
            reviewTextView.text = self.content
            reviewTextView.textColor = .helfmeBlack
            tasteSet = tagList[0]
            for tag in tagList {
                switch tag {
                case I18N.Detail.Review.tagGood:
                    tagGood.isSelected = true
                    setButtonUI(button: tagGood)
                case I18N.Detail.Review.tagSoso:
                    tagSoso.isSelected = true
                    setButtonUI(button: tagSoso)
                case I18N.Detail.Review.tagBad:
                    tagBad.isSelected = true
                    setButtonUI(button: tagBad)
                case I18N.Detail.Review.tagNoBurden:
                    tagNoBurden.isSelected = true
                    setButtonUI(button: tagNoBurden)
                case I18N.Detail.Review.tagEasy:
                    tagEasy.isSelected = true
                    setButtonUI(button: tagEasy)
                case I18N.Detail.Review.tagStrong:
                    tagStrong.isSelected = true
                    setButtonUI(button: tagStrong)
                default:
                    return
                }
            }
            
            for image in imageURLList {
                let url = URL(string: image)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        self.photoModel.userSelectedImages.append(UIImage(data: data!) ?? UIImage())
                    }
                }
            }
            
        }
    }
    
    private func setNavigation() {
        if isEdited {
            self.navigationItem.title = "리뷰 편집"
        } else {
            self.navigationItem.title = "리뷰 작성"
        }
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        view.backgroundColor = .white
        
        let backButton = UIButton()
        backButton.setImage(ImageLiterals.MainDetail.beforeIcon, for: .normal)
        backButton.tintColor = .helfmeBlack
        if isEdited {
            backButton.addAction(UIAction(handler: { _ in
                self.makeAlert(alertType: .logoutAlert,
                               title: "리뷰 편집을 취소하시겠습니까?",
                               subtitle: "편집 취소 시,\n 작성된 글은 저장되지 않습니다.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }), for: .touchUpInside)
        } else {
            backButton.addAction(UIAction(handler: { _ in
                self.makeAlert(alertType: .logoutAlert,
                               title: "리뷰 작성을 취소하시겠습니까?",
                               subtitle: "작성취소 시,\n 수정된 글은 저장되지 않습니다.") {
                    self.navigationController?.dismiss(animated: true)
                }
            }), for: .touchUpInside)
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubviews(restaurantTitleLabel, sliderView, lineView, questionTasteStackView, tagTasteStackView, questionFeelingStackView, tagHelpfulStackView, reviewStackView, reviewView, pictureStackView, photoCollectionView, photoSubLabel, writeReviewButton, checkReviewToastView, checkPhotoToastView)
        
        restaurantTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        sliderView.snp.makeConstraints { make in
            make.top.equalTo(restaurantTitleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(185)
            make.height.equalTo(37)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(sliderView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        questionTasteStackView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        tagGood.snp.makeConstraints { make in
            make.width.equalTo(73)
        }
        
        tagSoso.snp.makeConstraints { make in
            make.width.equalTo(99)
        }
        
        tagBad.snp.makeConstraints { make in
            make.width.equalTo(99)
        }
        
        tagTasteStackView.snp.makeConstraints { make in
            make.top.equalTo(questionTasteStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(28)
        }
        
        questionFeelingStackView.snp.makeConstraints { make in
            make.top.equalTo(tagTasteStackView.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(20)
        }
        
        tagNoBurden.snp.makeConstraints { make in
            make.width.equalTo(131)
        }
        
        tagEasy.snp.makeConstraints { make in
            make.width.equalTo(102)
        }
        
        tagStrong.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        
        tagHelpfulStackView.snp.makeConstraints { make in
            make.top.equalTo(questionFeelingStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(28)
        }
        
        reviewStackView.snp.makeConstraints { make in
            make.top.equalTo(tagHelpfulStackView.snp.bottom).offset(27)
            make.leading.equalToSuperview().inset(20)
        }
        
        reviewView.addSubviews(reviewTextView, textCountLabel)
        
        reviewView.snp.makeConstraints { make in
            make.top.equalTo(reviewStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(297)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(30)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(14)
        }
        
        pictureStackView.snp.makeConstraints { make in
            make.top.equalTo(reviewTextView.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(20)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pictureStackView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(105)
        }
        
        photoSubLabel.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        writeReviewButton.snp.makeConstraints { make in
            make.top.equalTo(photoSubLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(10)
        }
        
        checkReviewToastView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(63)
            make.trailing.equalToSuperview().offset(-63)
            make.bottom.equalToSuperview().offset(40)
            make.height.equalTo(40)
        }
        
        checkPhotoToastView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(63)
            make.trailing.equalToSuperview().offset(-63)
            make.bottom.equalToSuperview().offset(40)
            make.height.equalTo(40)
        }
    }
    
    private func setAddTargets() {
        print("Tag Button count",tasteTagButton.count)
        tasteTagButton.forEach { button in
            button.addTarget(self, action: #selector(didTapTasteTag), for: .touchUpInside)
        }
    }
    
    private func setButtonUI(button: UIButton) {
        if button.isSelected {
            button.layer.borderColor = UIColor.mainRed.cgColor
            button.setTitleColor(UIColor.mainRed, for: UIControl.State.normal)
        } else {
            button.layer.borderColor = UIColor.helfmeGray2.cgColor
            button.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        }
    }
    
    @objc private func didTapTasteTag(_ sender: UIButton) {
        self.selectedButton = sender.tag
        tasteTagButton.forEach { button in
            guard let tagTitle = button.titleLabel?.text else { return }
            button.isSelected = sender == button
            if button.isSelected {
                tasteSet = tagTitle
            }
            setButtonUI(button: button)
        }
    }
    
    @objc private func didTapFeelingTag(_ sender: UIButton) {
        sender.isSelected.toggle()
        feelingArray[sender.tag].toggle()
        if sender.isSelected {
            sender.layer.borderColor = UIColor.mainRed.cgColor
            sender.setTitleColor(UIColor.mainRed, for: UIControl.State.normal)
        } else {
            sender.layer.borderColor = UIColor.helfmeGray2.cgColor
            sender.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        }
        print(feelingArray)
    }
    
    private func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 500 {
            textView.deleteBackward()
        }
    }
    
    private func registerCell() {
        AddPhotoCVC.register(target: photoCollectionView)
        ListPhotoCVC.register(target: photoCollectionView)
    }
    
    private func showStatusActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePictureAction = UIAlertAction(title: "사진 찍기", style: .default) {_ in
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.allowsEditing = true
            camera.cameraDevice = .rear
            camera.cameraCaptureMode = .photo
            camera.delegate = self
            self.present(camera, animated: true, completion: nil)
        }
        let albumAction = UIAlertAction(title: "사진 보관함", style: .default) {_ in
            self.didTapimageAlbum()
        }
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        actionSheet.addAction(takePictureAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    
    @objc private func isAbledPhoto(_ sender: UITapGestureRecognizer) {
        if photoModel.userSelectedImages.count == 3 {
            showPhotoToast()
        } else {
            showStatusActionSheet()
        }
    }
    
    private func didTapimageAlbum() {
        selectedAssets.removeAll()
        userSelectedImages.removeAll()
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 3 - photoModel.userSelectedImages.count
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        self.presentImagePicker(imagePicker, select: { (asset) in
        }, deselect: { (asset) in
        }, cancel: { (assets) in
        }, finish: { (assets) in
            
            for i in 0..<assets.count {
                self.selectedAssets.append(assets[i])
            }
            
            self.convertAssetToImages()
            self.didPickImagesToUpload(images: self.userSelectedImages)
        })
    }
    
    private func convertAssetToImages() {
        if selectedAssets.count != 0 {
            for i in 0..<selectedAssets.count {
                
                let imageManager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: selectedAssets[i],
                                          targetSize: CGSize(width: 200, height: 200),
                                          contentMode: .aspectFit,
                                          options: option) { (result, info) in thumbnail = result! }
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                
                self.userSelectedImages.append(newImage! as UIImage)
            }
        }
    }
    
    private func bindSlider() {
        sliderView.sliderValue = { rate in
            self.currentRate = rate
        }
    }
    
    private func checkReview() -> Bool {
        if self.currentRate > 0 && !tasteSet.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    @objc private func didTapWriteReview(_ sender: UIButton) {
        if !checkReview() {
            showReviewToast()
        } else {
            if isEdited {
                HelfmeLoadingView.shared.show(self.view)
                requestReviewEdit() {
                    HelfmeLoadingView.shared.hide(){
                        print("로딩 종료")
                    }
                }
            } else {
                HelfmeLoadingView.shared.show(self.view)
                requestReviewWrite() {
                    HelfmeLoadingView.shared.hide(){
                        print("로딩 종료")
                    }
                }
            }
        }
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let safeareaHeight = self.view.safeAreaInsets.bottom
            UIView.animate(withDuration: 1) {
                self.contentView.transform =
                CGAffineTransform(translationX: 0, y: -(keyboardHeight - safeareaHeight))
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.contentView
            .transform = .identity
    }
}

extension ReviewWriteVC {
    private func showReviewToast() {
        makeVibrate()
        checkReviewToastView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(63)
            make.trailing.equalToSuperview().offset(-63)
            make.bottom.equalTo(writeReviewButton.snp.top).offset(-10)
            make.height.equalTo(40)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.view.layoutIfNeeded()
            self.checkReviewToastView.alpha = 1
            
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.hideReviewToast()
            }
        }
    }
    
    private func hideReviewToast() {
        checkReviewToastView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(63)
            make.trailing.equalToSuperview().offset(-63)
            make.bottom.equalToSuperview().offset(40)
            make.height.equalTo(40)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.checkReviewToastView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func showPhotoToast() {
        makeVibrate()
        checkPhotoToastView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(63)
            make.trailing.equalToSuperview().offset(-63)
            make.bottom.equalTo(writeReviewButton.snp.top).offset(-10)
            make.height.equalTo(40)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.view.layoutIfNeeded()
            self.checkPhotoToastView.alpha = 1
            
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.hidePhotoToast()
            }
        }
    }
    
    private func hidePhotoToast() {
        checkPhotoToastView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(63)
            make.trailing.equalToSuperview().offset(-63)
            make.bottom.equalToSuperview().offset(40)
            make.height.equalTo(40)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.checkPhotoToastView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Network

extension ReviewWriteVC {
    func requestReviewWrite(completion: @escaping(() -> Void)) {
        let starScore = self.currentRate
        let taste = tasteSet
        var good : [String] = []
        for i in 0...2 {
            if feelingArray[i] == true{
                switch i{
                case 0:
                    good.append(I18N.Detail.Review.tagNoBurden)
                case 1:
                    good.append(I18N.Detail.Review.tagEasy)
                case 2:
                    good.append(I18N.Detail.Review.tagStrong)
                default:
                    print("음")
                }
            }
        }
        
        if reviewTextView.text == I18N.Detail.Review.reviewPlaceholder{
            reviewTextView.text = " "
        }
        guard let content = reviewTextView.text else { return }
        
        let image = photoModel.userSelectedImages
        ReviewService.shared.requestReviewWrite(userName: userName, userId: userId, restaurantName: restaurantName, restaurantId: restaurantID, score: starScore, taste: taste, good: good, content: content, image: image) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? ReviewWriteEntity {
                    print(data, "성공")
                    completion()
                }
                self.dismiss(animated: true)
            default:
                break;
            }
        }
    }
    
    func requestReviewEdit(completion: @escaping(() -> Void)) {
        let reviewId = self.reviewId
        let starScore = self.currentRate
        let taste = tasteSet
        var good : [String] = []
        for i in 0...2 {
            if feelingArray[i] == true{
                switch i{
                case 0:
                    good.append("# 약속 시 부담 없는")
                case 1:
                    good.append("# 양 조절 쉬운")
                case 2:
                    good.append("# 든든한")
                default:
                    print("음")
                }
            }
        }
        
        if reviewTextView.text == I18N.Detail.Review.reviewPlaceholder{
            reviewTextView.text = " "
        }
        guard let content = reviewTextView.text else { return }
        
        let image = photoModel.userSelectedImages
        ReviewService.shared.requestReviewEdit(reviewId: reviewId, score: starScore, taste: taste, good: good, content: content, image: image, nameList: [""]) { networkResult in
            dump(networkResult)
            switch networkResult {
            case .success(let data):
                dump(data)
                if let data = data as? ReviewEditEntity {
                    print(data, "성공")
                    completion()
                }
                self.navigationController?.popViewController(animated: true)
            default:
                break;
            }
        }
    }
}

extension ReviewWriteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModel.userSelectedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case Cell.addCell.rawValue:
            guard let addPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCVC.className, for: indexPath) as? AddPhotoCVC else { fatalError("Failed to dequeue cell for AddPhotoCVC") }
            addPhotoCell.delegate = self
            addPhotoCell.photoCountLabel.text = "\(photoModel.userSelectedImages.count)/3"
            addPhotoCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isAbledPhoto(_:))))
            
            let borderLayer = CAShapeLayer()
            borderLayer.strokeColor = UIColor.helfmeTagGray.cgColor
            borderLayer.lineDashPattern = [4, 4]
            borderLayer.fillColor = nil
            borderLayer.path = UIBezierPath(roundedRect: addPhotoCell.contentView.bounds,
                                            cornerRadius: 8).cgPath
            addPhotoCell.layer.addSublayer(borderLayer)
            
            return addPhotoCell
        default:
            guard let listPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListPhotoCVC.className, for: indexPath) as? ListPhotoCVC else { fatalError("Failed to dequeue cell for ListPhotoCVC") }
            listPhotoCell.delegate = self
            listPhotoCell.indexPath = indexPath.item
            
            if photoModel.userSelectedImages.count > 0 {
                listPhotoCell.setImage(photoModel.userSelectedImages[indexPath.item - 1])
            }
            listPhotoCell.layer.cornerRadius = 8
            listPhotoCell.layer.masksToBounds = true
            listPhotoCell.contentView.clipsToBounds = true
            return listPhotoCell
        }
    }
}

extension ReviewWriteVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 105
        let cellHeight = 105
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ReviewWriteVC: AddImageDelegate {
    func didPickImagesToUpload(images: [UIImage]) {
        photoModel.userSelectedImages += images
    }
    
    func didTakeImagesToUpload(image: UIImage) {
        photoModel.userSelectedImages.append(image)
    }
}

extension ReviewWriteVC: ListPhotoCVCDelegate {
    func didPressDeleteBtn(at index: Int) {
        photoModel.userSelectedImages.remove(at: index - 1)
    }
}

extension ReviewWriteVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !isEdited {
            if textView.textColor == .helfmeGray2 {
                textView.text = nil
                textView.textColor = .helfmeBlack
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !isEdited {
            if textView.text.isEmpty {
                textView.text = "리뷰를 작성해주세요 (최대 500자)"
                textView.textColor = .helfmeGray2
            }
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
        checkMaxLength(textView)
        let count = textView.text.count
        textCountLabel.text = "\(count)/500자"
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}

extension ReviewWriteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            var images = [UIImage]()
            images.append(image)
            didPickImagesToUpload(images: images)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UIViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UIViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                self.view.window?.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                UIView.animate(withDuration: 1) {
                    self.view.window?.frame.origin.y += keyboardHeight
                }
            }
        }
    }
}

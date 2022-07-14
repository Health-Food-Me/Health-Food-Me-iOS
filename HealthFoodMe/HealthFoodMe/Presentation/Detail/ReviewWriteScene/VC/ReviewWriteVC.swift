//
//  ReviewWriteVC.swift
//  HealthFoodMe
//
//  Created by 최영린 on 2022/07/12.
//

import UIKit

import BSImagePicker
import SnapKit
import Photos

enum Cell: Int {
    case addCell = 0, photoCell
}

final class ReviewWriteVC: UIViewController, UIScrollViewDelegate {
    
    private var photoModel: PhotoDataModel = PhotoDataModel() {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    var selectedAssets: [PHAsset] = [PHAsset]()
    var userSelectedImages: [UIImage] = [UIImage]()
    var tasteSet = Set<String>()
    var feelingSet = Set<String>()
    
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
    
    let sliderView = StarRatingSlider(starWidth: 37)
    
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
    
    private var selectedButton: Int = 0
    private var tasteTagButton: [UIButton] = []
    
    private lazy var tagGood: UIButton = {
        let btn = UIButton()
        btn.setTitle("# 맛 최고", for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.tag = 0
        //        btn.addTarget(self, action: #selector(didTapTasteTag), for: .touchUpInside)
        tasteTagButton.append(btn)
        return btn
    }()
    
    private lazy var tagSoso: UIButton = {
        let btn = UIButton()
        btn.setTitle("# 맛 그럭저럭", for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.tag = 1
        //        btn.addTarget(self, action: #selector(didTapTasteTag), for: .touchUpInside)
        tasteTagButton.append(btn)
        return btn
    }()
    
    private lazy var tagBad: UIButton = {
        let btn = UIButton()
        btn.setTitle("# 맛 별로에요", for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.tag = 2
        //        btn.addTarget(self, action: #selector(didTapTasteTag), for: .touchUpInside)
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
    
    private lazy var tagNoBurden: UIButton = {
        let btn = UIButton()
        btn.setTitle("# 약속 시 부담 없는", for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(didTapFeelingTag), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tagEasy: UIButton = {
        let btn = UIButton()
        btn.setTitle("# 양 조절 쉬운", for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(didTapFeelingTag), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tagStrong: UIButton = {
        let btn = UIButton()
        btn.setTitle("# 든든한", for: .normal)
        btn.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.backgroundColor = .helfmeWhite
        btn.layer.borderColor = UIColor.helfmeGray2.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 14
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
    
    private let reviewView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeBgGray
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var reviewTextView: UITextView = {
        let tv = UITextView()
        tv.text = "리뷰를 작성해주세요 (최대 500자)"
        tv.font = .NotoRegular(size: 12)
        tv.textColor = .helfmeGray2
        tv.backgroundColor = .helfmeBgGray
        return tv
    }()
    
    private lazy var textCountLabel: UILabel = {
        let lb = UILabel()
        lb.text = "0/500자"
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 12)
        return lb
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
        lb.text = "해당 가게와 무관한 사진을 첨부하면 노출 제한 처리될 수 있습니다. \n사진첨부 시 개인정보가 노출되지 않도록 유의해주세요."
        lb.numberOfLines = 2
        lb.textColor = .helfmeGray2
        lb.font = .NotoRegular(size: 10)
        return lb
    }()
    
    private lazy var writeReviewButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("리뷰 쓰기", for: .normal)
        btn.setTitleColor(UIColor.helfmeWhite, for: UIControl.State.normal)
        btn.titleLabel?.font = .NotoBold(size: 14)
        btn.backgroundColor = .mainRed
        btn.layer.cornerRadius = 22
        return btn
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setNavigation()
        setLayout()
        registerCell()
        setAddTargets()
    }
}

// MARK: - Methods

extension ReviewWriteVC {
    private func setDelegate() {
        scrollView.delegate = self
        reviewTextView.delegate = self
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
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
        
        contentView.addSubviews(restaurantTitleLabel, sliderView, lineView, questionTasteStackView, tagTasteStackView, questionFeelingStackView, tagHelpfulStackView, reviewStackView, reviewView, pictureStackView, photoCollectionView, photoSubLabel, writeReviewButton)
        
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
    }
    
    private func setAddTargets() {
        tasteTagButton.forEach { button in
            button.addTarget(self, action: #selector(didTapTasteTag), for: .touchUpInside)
        }
    }
    
    @objc func didTapTasteTag(_ sender: UIButton) {
        self.selectedButton = sender.tag
        tasteTagButton.forEach { button in
            guard let tagTitle = button.titleLabel?.text else { return }
            button.isSelected = sender == button
            if button.isSelected {
                button.layer.borderColor = UIColor.mainRed.cgColor
                button.setTitleColor(UIColor.mainRed, for: UIControl.State.normal)
                tasteSet.insert(tagTitle)
            } else {
                button.layer.borderColor = UIColor.helfmeGray2.cgColor
                button.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
                tasteSet.remove(tagTitle)
            }
        }
        print(tasteSet)
    }
    
    @objc func didTapFeelingTag(_ sender: UIButton) {
        guard let tagTitle = sender.titleLabel?.text else { return }
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.layer.borderColor = UIColor.mainRed.cgColor
            sender.setTitleColor(UIColor.mainRed, for: UIControl.State.normal)
            feelingSet.insert(tagTitle)
        } else {
            sender.layer.borderColor = UIColor.helfmeGray2.cgColor
            sender.setTitleColor(UIColor.helfmeGray2, for: UIControl.State.normal)
            feelingSet.remove(tagTitle)
        }
        print(feelingSet)
    }
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 500 {
            textView.deleteBackward()
        }
    }
    
    private func registerCell() {
        AddPhotoCVC.register(target: photoCollectionView)
        ListPhotoCVC.register(target: photoCollectionView)
    }
    
    @objc func showStatusActionSheet(_ sender: UITapGestureRecognizer) {
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
    
    func didTapimageAlbum() {
        selectedAssets.removeAll()
        userSelectedImages.removeAll()
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
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
    
    func convertAssetToImages() {
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
}

// MARK: - Network

extension ReviewWriteVC {
    
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
            addPhotoCell.photoCountLabel.text = "\(photoModel.userSelectedImages.count)/5"
            addPhotoCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showStatusActionSheet(_:))))
            
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
        checkMaxLength(textView)
        let count = textView.text.count
        textCountLabel.text = "\(count)/500자"
    }
}

extension ReviewWriteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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

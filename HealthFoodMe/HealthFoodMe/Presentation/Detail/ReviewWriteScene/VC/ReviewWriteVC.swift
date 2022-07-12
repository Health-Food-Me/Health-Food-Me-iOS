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

    private let questionHelpfulLabel: UILabel = {
        let lb = UILabel()
        lb.text = "어떤 점이 좋았나요?"
        lb.textColor = .helfmeBlack
        lb.font = .NotoBold(size: 14)
        return lb
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
        lb.font = .NotoRegular(size: 10)
        return lb
    }()
    
    private lazy var reviewStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 6
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
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.addSubviews(restaurantTitleLabel, lineView, questionTasteLabel, tagTasteStackView, questionHelpfulLabel, tagHelpfulStackView, reviewStackView, reviewTextVeiw)
        
        restaurantTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(restaurantTitleLabel.snp.bottom).offset(67)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        questionTasteLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        tagTasteStackView.snp.makeConstraints { make in
            make.top.equalTo(questionTasteLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        questionHelpfulLabel.snp.makeConstraints { make in
            make.top.equalTo(tagTasteStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        tagHelpfulStackView.snp.makeConstraints { make in
            make.top.equalTo(questionHelpfulLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        reviewStackView.snp.makeConstraints { make in
            make.top.equalTo(tagHelpfulStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(20)
        }
        
        reviewTextVeiw.snp.makeConstraints { make in
            make.top.equalTo(reviewStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(800)
        }
    }
}

// MARK: - Network

extension ReviewWriteVC {
    
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
    }
}


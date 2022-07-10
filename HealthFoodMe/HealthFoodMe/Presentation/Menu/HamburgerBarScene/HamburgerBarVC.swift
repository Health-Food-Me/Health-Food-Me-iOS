//
//  HamburgerBarVC.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/10.
//

import UIKit

class HamburgerBarVC: UIViewController {

    private lazy var hamburgerBarView = UIView()
    private lazy var helloLabel = UILabel()
    private lazy var nameLabel = UILabel()
    private lazy var sirLabel = UILabel()
    private lazy var todayHelfmeLabel = UILabel()
    private lazy var editNameButton = UIButton()
    private lazy var scrapListButton = UIButton()
    private lazy var myReviewButton = UIButton()
    private lazy var reportStoreButton = UIButton()
    private lazy var repostCorrectionButton = UIButton()
    private lazy var settingButton = UIButton()
    private lazy var logoutButton = UIButton()
    private lazy var firstDividingLineView = UIView()
    private lazy var secondDividingLineView = UIView()
    private lazy var thirdDividingLineView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
    }
    
    private func setUI() {
        let blackColorWithAlpha: UIColor = UIColor(.black).withAlphaComponent(0.6)
        view.backgroundColor = blackColorWithAlpha
        hamburgerBarView.backgroundColor = .helfmeWhite
        
        editNameButton.setImage(UIImage(named: "btn_edit"), for: .normal)
        
        helloLabel.text = I18N.HamburgerBar.hello
        nameLabel.text = "배부른 현우는 행복해요"
        sirLabel.text = I18N.HamburgerBar.sir
        todayHelfmeLabel.text = I18N.HamburgerBar.todayHelfme
        scrapListButton.setTitle(I18N.HamburgerBar.scrapList, for: .normal)
        myReviewButton.setTitle(I18N.HamburgerBar.myReview, for: .normal)
        reportStoreButton.setTitle(I18N.HamburgerBar.reportStore, for: .normal)
        repostCorrectionButton.setTitle(I18N.HamburgerBar.reposrtCorrection, for: .normal)
        settingButton.setTitle(I18N.HamburgerBar.setting, for: .normal)
        logoutButton.setTitle(I18N.HamburgerBar.logout, for: .normal)
        
        helloLabel.textColor = .helfmeBlack
        nameLabel.textColor = .helfmeBlack
        sirLabel.textColor = .helfmeBlack
        todayHelfmeLabel.textColor = .helfmeBlack
        scrapListButton.setTitleColor(.helfmeBlack, for: .normal)
        myReviewButton.setTitleColor(.helfmeBlack, for: .normal)
        reportStoreButton.setTitleColor(.helfmeBlack, for: .normal)
        repostCorrectionButton.setTitleColor(.helfmeBlack, for: .normal)
        settingButton.setTitleColor(.helfmeBlack, for: .normal)
        logoutButton.setTitleColor(.helfmeBlack, for: .normal)
        
        firstDividingLineView.backgroundColor = .helfmeLineGray
        secondDividingLineView.backgroundColor = .helfmeLineGray
        thirdDividingLineView.backgroundColor = .helfmeLineGray
        
        helloLabel.font = UIFont.PretendardRegular(size: 18)
        nameLabel.font = UIFont.PretendardRegular(size: 18)
        sirLabel.font = UIFont.PretendardRegular(size: 18)
        todayHelfmeLabel.font = UIFont.PretendardRegular(size: 18)
        scrapListButton.titleLabel?.font = UIFont.PretendardRegular(size: 16)
        myReviewButton.titleLabel?.font = UIFont.PretendardRegular(size: 16)
        reportStoreButton.titleLabel?.font = UIFont.PretendardRegular(size: 16)
        repostCorrectionButton.titleLabel?.font = UIFont.PretendardRegular(size: 16)
        settingButton.titleLabel?.font = UIFont.PretendardRegular(size: 16)
        logoutButton.titleLabel?.font = UIFont.PretendardRegular(size: 12)
    }
    
    private func setLayout() {
        view.addSubviews(hamburgerBarView, helloLabel, nameLabel,
                         sirLabel, todayHelfmeLabel, editNameButton,
                         scrapListButton, myReviewButton, reportStoreButton,
                         repostCorrectionButton, settingButton, logoutButton,
                         firstDividingLineView, secondDividingLineView, thirdDividingLineView)
        
        hamburgerBarView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.71)
            make.height.equalToSuperview()
            make.top.equalTo(0)
            make.leading.equalTo(0)
        }
        
        helloLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(52)
            make.leading.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.bottom).offset(3)
            make.leading.equalTo(20)
        }
        
        sirLabel.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.bottom).offset(3)
            make.leading.equalTo(nameLabel.snp.trailing).offset(2)
        }
        
        editNameButton.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.bottom).offset(3)
            make.leading.equalTo(sirLabel.snp.trailing).offset(8)
        }
        
        todayHelfmeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.leading.equalTo(20)
        }
        
        firstDividingLineView.snp.makeConstraints { make in
            make.top.equalTo(todayHelfmeLabel.snp.bottom).offset(38)
            make.width.equalTo(hamburgerBarView)
            make.height.equalTo(1)
        }
        
        scrapListButton.snp.makeConstraints { make in
            make.top.equalTo(firstDividingLineView.snp.bottom).offset(28)
            make.leading.equalTo(20)
        }
        
        myReviewButton.snp.makeConstraints { make in
            make.top.equalTo(scrapListButton.snp.bottom).offset(20)
            make.leading.equalTo(20)
        }
        
        secondDividingLineView.snp.makeConstraints { make in
            make.top.equalTo(myReviewButton.snp.bottom).offset(28)
            make.width.equalTo(hamburgerBarView)
            make.height.equalTo(1)
        }
        
        reportStoreButton.snp.makeConstraints { make in
            make.top.equalTo(secondDividingLineView.snp.bottom).offset(20)
            make.leading.equalTo(20)
        }
        
        repostCorrectionButton.snp.makeConstraints { make in
            make.top.equalTo(reportStoreButton.snp.bottom).offset(20)
            make.leading.equalTo(20)
        }
        
        thirdDividingLineView.snp.makeConstraints { make in
            make.top.equalTo(repostCorrectionButton.snp.bottom).offset(20)
            make.width.equalTo(hamburgerBarView)
            make.height.equalTo(1)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(thirdDividingLineView.snp.bottom).offset(28)
            make.leading.equalTo(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.leading.equalTo(20)
        }
    }
}

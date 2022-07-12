//
//  SearchResultVC.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/13.
//

import UIKit

import SnapKit

protocol SearchResultVCDelegate: AnyObject {
    func searchResultVCSearchType(type: SearchType)
}

final class SearchResultVC: UIViewController {
    
    // MARK: - Properties
    
    var searchContent: String = ""
    weak var delegate: SearchResultVCDelegate?
    
    private let mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainRed
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.leftViewMode = .always
        tf.font = .NotoRegular(size: 15)
        tf.text = searchContent
        tf.textColor = .helfmeBlack
        tf.backgroundColor = .helfmeWhite
        tf.leftView = backButton
        return tf
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        btn.setImage(ImageLiterals.Search.beforeIcon, for: .normal)
        btn.addTarget(self, action: #selector(popToSearchVC), for: .touchUpInside)
        return btn
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setDelegate()
    }
}

// MARK: - @objc Methods

extension SearchResultVC {
    @objc func popToSearchVC() {
        delegate?.searchResultVCSearchType(type: .recent)
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - Methods

extension SearchResultVC {
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        view.addSubviews(searchTextField, lineView)
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            $0.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(36)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
    }
    
    private func setDelegate() {
        searchTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension SearchResultVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchResultVCSearchType(type: .search)
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - Network

extension SearchResultVC {
    
}

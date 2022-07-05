//
//  SearchTopView.swift
//  HealthFoodMe
//
//  Created by 김영인 on 2022/07/05.
//

import UIKit

import SnapKit

class SearchTopView: UIView {
    
    // MARK: - Properties
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.leftViewMode = .always
        tf.rightViewMode = .never
        tf.attributedPlaceholder = NSAttributedString(string: "식당, 음식 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.textColor = .black
        tf.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        btn.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        btn.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var clearButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "x.circle"), for: .normal)
        btn.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
        return btn
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc Methods
    
    @objc func didTapBackButton() {
        
    }
    
    @objc func didTapClearButton() {
        searchTextField.text?.removeAll()
        searchTextField.rightViewMode = .never
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if searchTextField.isEmpty {
            searchTextField.rightViewMode = .never
        } else {
            searchTextField.rightViewMode = .always
        }
    }
}

// MARK: - Methods

extension SearchTopView {
    private func setUI() {
        searchTextField.leftView = backButton
        searchTextField.rightView = clearButton
    }
    
    private func setLayout() {
        addSubviews(searchTextField, lineView)
        
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(0.5)
        }
    }

    private func setDelegate() {
        searchTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension SearchTopView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pushToSearchResult(textField.text ?? "")
        return true
    }
    
    private func pushToSearchResult(_ search: String) {
        print(search)
    }
}

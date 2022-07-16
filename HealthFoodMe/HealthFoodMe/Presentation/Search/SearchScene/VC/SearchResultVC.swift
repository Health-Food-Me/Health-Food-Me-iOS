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
    private var isBottom: Bool = true
    var searchResultList: [SearchResultDataModel] = []
    let height = UIScreen.main.bounds.height
    
    // MARK: - UI Components
    
    private let mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainGreen
        return view
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeWhite
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.leftViewMode = .always
        tf.rightViewMode = .always
        tf.font = .NotoRegular(size: 15)
        tf.text = searchContent
        tf.textColor = .helfmeBlack
        tf.backgroundColor = .helfmeWhite
        tf.leftView = backButton
        tf.rightView = resultCloseButton
        return tf
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 12)
        btn.setImage(ImageLiterals.Search.beforeIcon, for: .normal)
        btn.addTarget(self, action: #selector(popToSearchVC), for: .touchUpInside)
        return btn
    }()
    
    private lazy var resultCloseButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.xIcon, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        btn.addTarget(self, action: #selector(popToMainMapVC), for: .touchUpInside)
        return btn
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()
    
    private let searchResultHeaderView: UIView = UIView()
    
    private lazy var searchResultHeaderButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.viewMapBtn, for: .normal)
        btn.setTitle(I18N.Search.searchMap, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray1, for: .normal)
        btn.titleLabel?.font = .NotoRegular(size: 14)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(moveSearchResultView), for: .touchUpInside)
        btn.semanticContentAttribute = .forceLeftToRight
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        return btn
    }()
    
    private lazy var searchResultTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.rowHeight = 127
        tv.backgroundColor = .helfmeWhite
        tv.keyboardDismissMode = .onDrag
        tv.tableHeaderView = searchResultHeaderView
        tv.tableHeaderView?.frame.size.height = 42
        tv.layer.applyShadow(color: .black,
                             alpha: 0.1,
                             x: 0,
                             y: -3,
                             blur: 4,
                             spread: 0)
        return tv
    }()
    
    private let searchResultLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setUI()
        setLayout()
        setDelegate()
        registerCell()
    }
}

// MARK: - @objc Methods

extension SearchResultVC {
    @objc func popToSearchVC() {
        delegate?.searchResultVCSearchType(type: .recent)
        navigationController?.popViewController(animated: false)
    }
    
    @objc func moveSearchResultView() {
        initUI()
    }
    
    @objc func popToMainMapVC() {
        guard let vcs = navigationController?.viewControllers else { return }
        for vc in vcs {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
}

// MARK: - Methods

extension SearchResultVC {
    private func initUI() {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: self.height - self.height/3.3)
        })
        searchResultTableView.layer.shadowOpacity = 0.1
        searchResultHeaderButton.isHidden = true
        searchResultLineView.isHidden = false
        searchResultTableView.layer.cornerRadius = 15
        isBottom = true
    }
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .helfmeWhite
    }
    
    private func setLayout() {
        view.addSubviews(topView,
                         searchTextField,
                         lineView,
                         mapView,
                         searchResultTableView)
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(91)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(56)
        }
        
        resultCloseButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(44)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchResultHeaderView.addSubviews(searchResultHeaderButton)
        
        searchResultHeaderButton.snp.makeConstraints {
            $0.trailing.equalTo(searchResultHeaderView.snp.trailing).inset(20)
            $0.centerY.equalTo(searchResultHeaderView)
            $0.width.equalTo(105)
            $0.height.equalTo(20)
        }
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchResultTableView.addSubviews(searchResultLineView)
        
        searchResultLineView.snp.makeConstraints {
            $0.top.equalTo(searchResultTableView.snp.top).inset(8)
            $0.width.equalTo(70)
            $0.height.equalTo(3)
            $0.centerX.equalTo(searchResultTableView)
        }
    }
    
    private func setDelegate() {
        searchTextField.delegate = self
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
    
    private func registerCell() {
        SearchResultTVC.register(target: searchResultTableView)
    }
}

// MARK: - UITextFieldDelegate

extension SearchResultVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchResultVCSearchType(type: .search)
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - UITableViewDelegate

extension SearchResultVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension SearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTVC.className, for: indexPath) as? SearchResultTVC else { return UITableViewCell() }
        cell.setData(data: searchResultList[indexPath.row])
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension SearchResultVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 && isBottom {
            self.searchResultTableView.isScrollEnabled = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
                self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.searchResultHeaderButton.isHidden = false
            } completion: { _ in
                self.view.bringSubviewToFront(self.topView)
                self.view.bringSubviewToFront(self.searchTextField)
            }
        }
        isBottom = false
        searchResultTableView.layer.cornerRadius = 0
        searchResultTableView.layer.shadowOpacity = 0
        searchResultLineView.isHidden = true
        searchResultTableView.isScrollEnabled = true
    }
}

// MARK: - Network

extension SearchResultVC {
    
}

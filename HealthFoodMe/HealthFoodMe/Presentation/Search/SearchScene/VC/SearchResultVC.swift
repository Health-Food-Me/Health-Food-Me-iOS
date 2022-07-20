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
    private var isMapView: Bool = true
    var searchResultList: [SearchResultDataModel] = []
    private let mapViewController: SupplementMapVC = {
        let vc = ModuleFactory.resolve().makeSupplementMapVC(forSearchVC: true)
        return vc
    }()
    let height = UIScreen.main.bounds.height
    
    // MARK: - UI Components
    
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
        return btn
    }()
    
    private lazy var resultCloseButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.xIcon, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return btn
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .helfmeLineGray
        return view
    }()
    
    private let searchResultHeaderView: UIView = UIView()
    
    private lazy var viewMapButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.viewMapBtn, for: .normal)
        btn.setTitle(I18N.Search.searchMap, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray1, for: .normal)
        btn.titleLabel?.font = .NotoRegular(size: 12)
        btn.isHidden = true
        btn.semanticContentAttribute = .forceLeftToRight
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        return btn
    }()
    
    private lazy var viewListButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.Search.viewListBtn, for: .normal)
        btn.setTitle(I18N.Search.searchList, for: .normal)
        btn.setTitleColor(UIColor.helfmeGray1, for: .normal)
        btn.titleLabel?.font = .NotoRegular(size: 12)
        btn.isHidden = true
        btn.semanticContentAttribute = .forceLeftToRight
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
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
        setChildViewController()
        setUI()
        addBtnAction()
        setLayout()
        setDelegate()
        registerCell()
    }
}

// MARK: - Methods

extension SearchResultVC {
    private func setChildViewController() {
        self.addChild(mapViewController)
        self.view.addSubview(mapViewController.view)
        mapViewController.setSupplementMapType(mapType: .search)
        mapViewController.delegate = self
        mapViewController.didMove(toParent: self)
    }
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .helfmeWhite
        viewMap()
    }
    
    private func addBtnAction() {
        backButton.press {
            if self.isMapView {
                self.viewList()
            } else {
                self.delegate?.searchResultVCSearchType(type: .recent)
                self.navigationController?.popViewController(animated: false)
            }
        }
        
        resultCloseButton.press {
            guard let vcs = self.navigationController?.viewControllers else { return }
            for vc in vcs {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        
        viewMapButton.press {
            self.viewMap()
        }
        
        viewListButton.press {
            self.viewList()
        }
    }
    
    private func setLayout() {
        view.addSubviews(topView,
                         searchTextField,
                         lineView,
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
        
        searchResultHeaderView.addSubviews(viewMapButton, viewListButton)
        
        viewMapButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(67)
            $0.height.equalTo(16)
        }
        
        viewListButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(67)
            $0.height.equalTo(14)
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
    
    private func viewMap() {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: 585)
        })
        searchResultTableView.tableHeaderView?.frame.size.height = 40
        isMapView = true
        searchResultTableView.layer.shadowOpacity = 0.1
        searchResultTableView.layer.cornerRadius = 15
        searchResultLineView.isHidden = false
        viewMapButton.isHidden = true
        viewListButton.isHidden = false
    }
    
    private func viewList() {
        UIView.animate(withDuration: 0.2) {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.viewMapButton.isHidden = false
        } completion: { _ in
            self.view.bringSubviewToFront(self.topView)
            self.view.bringSubviewToFront(self.searchTextField)
        }
        searchResultTableView.tableHeaderView?.frame.size.height = 50
        isMapView = false
        searchResultTableView.layer.cornerRadius = 0
        searchResultTableView.layer.shadowOpacity = 0
        searchResultLineView.isHidden = true
        viewMapButton.isHidden = false
        viewListButton.isHidden = true
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
        if scrollView.contentOffset.y == 0 {
            if isMapView {
                viewList()
            }
        }
    }
}

extension SearchResultVC: SupplementMapVCDelegate {
    func supplementMapClicked() {
        UIView.animate(withDuration: 0.2) {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: 585)
        }
    }
    
    func supplementMapMarkerClicked() {
        UIView.animate(withDuration: 0.2) {
            self.searchResultTableView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        } completion: { _ in
            self.mapViewController.showSummaryView()
        }
    }
}

// MARK: - Network

extension SearchResultVC {
    
}

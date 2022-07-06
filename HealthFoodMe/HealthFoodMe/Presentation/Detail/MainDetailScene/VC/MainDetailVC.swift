//
//  MainDetailVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class MainDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var viewModel: MainDetailViewModel!
    private var detailTabTVC = DetailTabTVC()
    private var detailTabTitleHeader = DetailTabTitleHeader()
    
    // MARK: - UI Components
    
    private lazy var mainTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.clipsToBounds = true
        tv.allowsSelection = false
        tv.sectionFooterHeight = 0
        if #available(iOS 15, *) {
            tv.sectionHeaderTopPadding = 0
        }
        tv.estimatedRowHeight = 100
        tv.estimatedSectionHeaderHeight = 80
        return tv
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        registerCell()
        setDelegate()
        bindViewModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Methods

extension MainDetailVC {
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubviews(mainTableView)
        
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func registerCell() {
        MainInfoTVC.register(target: mainTableView)
        DetailTabTVC.register(target: mainTableView)
        DetailTabTitleHeader.register(target: mainTableView)
    }
    
    private func setDelegate() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    private func bindViewModels() {
        let input = MainDetailViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
}

// MARK: TableViewDelegate

extension MainDetailVC: UITableViewDelegate {
   
    // TODO: expendable 고려해서 로직 짜기
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return MainInfoTVC.caculateRowHeihgt()
        } else {
            return UIScreen.main.bounds.height - 104
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1,
              let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailTabTitleHeader.className) as? DetailTabTitleHeader else { return nil }
        headerCell.titleButtonTapped.asDriver(onErrorJustReturn: 0)
            .drive { selectedIndex in
                self.detailTabTVC.scrollToSelectedIndex(index: selectedIndex)
            }.disposed(by: headerCell.disposeBag)
        detailTabTitleHeader = headerCell
        return headerCell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // let scrollHeaderHeight = friendsTableView.sectionHeaderHeight
        let scrollHeaderHeight = mainTableView.rowHeight
        
        if scrollView.contentOffset.y <= scrollHeaderHeight {
            if scrollView.contentOffset.y >= 0 {
                scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            }
        } else if (scrollView.contentOffset.y >= scrollHeaderHeight) {
            scrollView.contentInset = UIEdgeInsets(top: -scrollHeaderHeight, left: 0, bottom: 0, right: 0)
        }
    }
}

// MARK: TableViewDataSource

extension MainDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainInfoTVC.className, for: indexPath) as? MainInfoTVC else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTabTVC.className, for: indexPath) as? DetailTabTVC else { return UITableViewCell() }
            detailTabTVC = cell
            cell.scrollRatio.asDriver(onErrorJustReturn: 0)
                .drive { ratio in
                    self.detailTabTitleHeader.moveWithContinuousRatio(ratio: ratio)
                }.disposed(by: cell.disposeBag)
            return cell
        }
    }
}

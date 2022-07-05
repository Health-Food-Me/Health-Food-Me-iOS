//
//  MainDetailVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import RxSwift
import SnapKit

class MainDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var viewModel: MainDetailViewModel!
    
    // MARK: - UI Components
    
    private let detailSummaryView = DetailSummaryView()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindViewModels()
    }
}

// MARK: - Methods

extension MainDetailVC {
    
    private func setUI() {
        view.backgroundColor = .blue
    }
    
    private func setLayout() {
        view.addSubviews(detailSummaryView)
        
        detailSummaryView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModels() {
        let input = MainDetailViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
}

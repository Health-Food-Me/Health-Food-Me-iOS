//
//  MainDetailVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/05.
//

import UIKit

import RxSwift

class MainDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var viewModel: MainDetailViewModel!
    
    // MARK: - UI Components
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModels()
    }
}

// MARK: - Methods

extension MainDetailVC {
    
    private func setUI() {
        view.backgroundColor = .blue
    }
    
    private func bindViewModels() {
        let input = MainDetailViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }
}

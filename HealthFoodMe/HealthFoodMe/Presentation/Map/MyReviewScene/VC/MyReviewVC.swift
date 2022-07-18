//
//  MyReviewVC.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/19.
//

import UIKit

import RxSwift

class MyReviewVC: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var viewModel: MyReviewViewModel!
  
    // MARK: - UI Components
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
    }
}

// MARK: - Methods

extension MyReviewVC {
  
    private func bindViewModels() {
        let input = MyReviewViewModel.Input()
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
    }

}

// MARK: - Network

extension MyReviewVC {

}

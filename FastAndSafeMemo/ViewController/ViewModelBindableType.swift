//
//  ViewModelBindableType.swift
//  FastAndSafeMemo
//
//  Created by APPLE on 2021/03/05.
//

import UIKit

// 뷰모델의 타입은 뷰컨트롤러마다 달라지므로 protocol을 제네릭 프로토콜로 선언
protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    // 뷰컨트롤러에 추가된 뷰모델 속성에 실제 뷰모델을 저장하고 바인드뷰모델 메소드를 자동으로 호출하는 메소드를 구현
    mutating func bind(viewModel: Self.ViewModelType) {
        // 개별 뷰 컨트롤러에서 바인드 뷰모델을 직접 호출할 필요가 없기 때문에 코드가 단순해진다
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}

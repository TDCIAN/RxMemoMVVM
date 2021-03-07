//
//  MemoDetailViewModel.swift
//  FastAndSafeMemo
//
//  Created by APPLE on 2021/03/05.
//

import Foundation
import RxSwift
import RxCocoa
import Action

// 메모 보기 화면에서 사용할 뷰모델
class MemoDetailViewModel: CommonViewModel {
    let memo: Memo
    
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    // 왜 비헤이비어서브젝트인가?
    // 메모를 편집한 다음에 다시 보기 화면으로 오면 편집된 화면이 반영되어야 한다
    // 이러기 위해서는 새로운 문자열을 방출해야 한다.
    // 일반 옵저버블로 선언하면 그게 불가능하기 때문에 비헤이비어서브젝트로 선언해야 한다
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    // back button과 바인딩할 액션
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
    }
}

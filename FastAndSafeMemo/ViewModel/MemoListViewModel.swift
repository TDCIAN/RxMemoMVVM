//
//  MemoListViewModel.swift
//  FastAndSafeMemo
//
//  Created by APPLE on 2021/03/05.
//

import Foundation
import RxSwift
import RxCocoa
import Action

// 메모 목록 화면에서 사용할 뷰모델
class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input).map { _ in }
        }
    }
    

    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map { _ in }
        }
    }
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.createMemo(content: "")
                .flatMap { memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(title: "New Memo", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    let composeScene = Scene.compose(composeViewModel)
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }
                }
        }
    }
    // 클로저 내부에서 셀프에 접근해야 하기 때문에 lazy로 선언했다
    lazy var detailAction: Action<Memo, Void> = {
        return Action { memo in
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "Show Memo", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().map { _ in }
        }
    }()
    
    // back button과 바인딩할 액션
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
    }
    
    lazy var deleteAction: Action<Memo, Swift.Never> = {
        return Action { memo in
            return self.storage.delete(memo: memo).ignoreElements()
        }
    }()
}

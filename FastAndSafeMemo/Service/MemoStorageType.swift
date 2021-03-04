//
//  MemoStorageType.swift
//  FastAndSafeMemo
//
//  Created by APPLE on 2021/03/05.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    // return형이 Observable -> 구독자가 작업 결과를 원하는 방식으로 처리 가능
    @discardableResult // 작업 결과가 필요 없는 경우를 위해서 메소드에 discardableResult 특성을 추가
    func createMemo(content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}

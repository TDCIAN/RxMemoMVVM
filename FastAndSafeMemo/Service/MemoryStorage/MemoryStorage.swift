//
//  MemoryStorage.swift
//  FastAndSafeMemo
//
//  Created by APPLE on 2021/03/05.
//

import Foundation
import RxSwift

// 메모리에 메모를 저장하는 클래스
class MemoryStorage: MemoStorageType {
    
    // 클래스 외부에서 배열에 직접 접근할 필요가 없기 때문에 private
    // 메모를 저장할 배열 -> 배열은 Observable을 통해 외부로 공개된다
    // Observable은 배열의 상태가 업데이트 되면 새로운 next 이벤트를 방출해야 한다
    // 그냥 Observable 형식으로 만들면 이런 게 불가능해짐 -> 그러므로 Subject로 만들어야 한다
    // 초기에 더미데이터를 표시해야 하니까 Subject 중에서 BehaviorSubject로 만들어야 함
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Lorem Ipsum", insertDate: Date().addingTimeInterval(-20))
    ]
    // list를 기반으로 만드는 새로운 섹션모델
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    // 기본값을 리스트배열로 선언하기 위해 레이지로 선언, 서브젝트 역시 외부에서 직접 접근할 필요가 없으므로 프라이빗으로 선언
//    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel])
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        // 새로운 메모를 생성하고 배열에 추가
        let memo = Memo(content: content)
//        list.insert(memo, at: 0)
        sectionModel.items.insert(memo, at: 0)

        // 서브젝트에서 새로운 넥스트 이벤트를 방출하고
//        store.onNext(list)
        store.onNext([sectionModel])
        // 새로운 메모를 방출하는 옵저버블을 리턴
        return Observable.just(memo)
    }
    
    @discardableResult
//    func memoList() -> Observable<[Memo]> {
    func memoList() -> Observable<[MemoSectionModel]> {
        // 서브젝트를 리턴 -> 클래스 외부에서는 이 메소드를 통해서 서브젝트로 접근
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        // 업데이트된 메모 인스턴스를 생성
        let updated = Memo(original: memo, updatedContent: content)
        // 그 다음 배열에 저장된 원본 인스턴스를 새로운 인스턴스로 교체
//        if let index = list.firstIndex(where: { $0 == memo }) {
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
//            list.remove(at: index)
            sectionModel.items.remove(at: index)
//            list.insert(updated, at: index)
            sectionModel.items.insert(updated, at: index)
        }
        // 서브젝트에서 새로운 넥스트 이벤트를 방출하고
//        store.onNext(list)
        store.onNext([sectionModel])
        // 마지막으로 업데이트 된 메모를 방출하는 옵저버블을 리턴
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        // 리스트 배열에서 메모를 삭제하고 서브젝트에서 새로운 넥스트 이벤트를 방출
//        if let index = list.firstIndex(where: { $0 == memo }) {
        if let index = sectionModel.items.firstIndex(where: { $0 == memo }) {
//            list.remove(at: index)
            sectionModel.items.remove(at: index)
        }
        
//        store.onNext(list)
        store.onNext([sectionModel])
        // 삭제된 메모를 방출하는 옵저버블을 리턴
        return Observable.just(memo)
    }
    
    
}

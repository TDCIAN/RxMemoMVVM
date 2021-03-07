//
//  Memo.swift
//  FastAndSafeMemo
//
//  Created by APPLE on 2021/03/05.
//

import Foundation
import RxDataSources /* tableView와 collectionView에 바인딩할 수 있는 dataSource를 제공한다. dataSource에 저장되는 모든 데이터는 반드시 IdentifiableType 프로토콜을 채용해야 한다. IdentifiableType 프로토콜에는 identity 속성이 선언되어 있다. identity 속성의 형식은 Hashable 프로토콜을 채용한 형식으로 제한되어 있다. */
import CoreData
import RxCoreData

struct Memo: Equatable, IdentifiableType {
    var content: String // 메모 저장
    var insertDate: Date // 생성 날짜
    var identity: String // 메모를 구분할 때 사용 -> String은 Hashable 프로토콜을 채용한 형식이므로 프로토콜이 요구하는 조건을 충족시킨다.
    
    // 생성자 추가
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    // 업데이트된 내용으로 새로운 메모 인스턴스를 생성할 때 사용
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
    }
}

/* Persistable 프로토콜 채용 */
extension Memo: Persistable {
    public static var entityName: String {
        return "Memo"
    }
    
    // id로 사용되는 필드를 리턴
    static var primaryAttributeName: String {
        return "identity"
    }
    
    init(entity: NSManagedObject) {
        content = entity.value(forKey: "content") as! String
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    // 현재 instance에 저장된 데이터로 NSManagedObject를 업데이트하는 메소드
    func update(_ entity: NSManagedObject) {
        entity.setValue(content, forKey: "content")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
}

//
//  Memo.swift
//  FastAndSafeMemo
//
//  Created by APPLE on 2021/03/05.
//

import Foundation

struct Memo: Equatable {
    var content: String // 메모 저장
    var insertDate: Date // 생성 날짜
    var identity: String // 메모를 구분할 때 사용
    
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

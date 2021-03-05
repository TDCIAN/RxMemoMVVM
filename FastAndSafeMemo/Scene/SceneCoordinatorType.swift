//
//  SceneCoordinatorType.swift
//  FastAndSafeMemo
//
//  Created by APPLE on 2021/03/05.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    // 리턴형이 Completable -> 여기에 구독자를 추가하고 화면 전환이 완료된 후에 원하는 작업을 구현할 수 있다. 필요 없다면 사용하지 않아도 된다(discardableResult)
    
    // 새로운 신을 표시하는 메소드 -> 파라미터로 대상 Scene과 트랜지션 스타일, 애니메이션 플래그를 전달한다
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    // 현재 Scene을 닫고 이전 Scene신으로 돌아간다
    @discardableResult
    func close(animated: Bool) -> Completable
}

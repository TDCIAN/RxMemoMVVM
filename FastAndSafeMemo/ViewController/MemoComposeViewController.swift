//
//  MemoComposeViewController.swift
//  FastAndSafeMemo
//
//  Created by APPLE on 2021/03/05.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoComposeViewModel!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        // 메모 쓰기 모드에서는 빈 문자열이, 메모 편집 모드에서는 편집할 메모가 나온다
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
        
        // 반복 탭을 막기 위해 쓰로틀 사용한다 (0.5초)
        saveButton.rx.tap.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
        
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        let keyboardObservable = Observable.merge(willShowObservable, willHideObservable).share()
        
        keyboardObservable
//            .map { [unowned self] height -> UIEdgeInsets in
//                var inset = self.contentTextView.contentInset
//                inset.bottom = height
//                return inset
//            }
            .toContentInset(of: contentTextView)
//            .subscribe(onNext: { [weak self] height in
//            guard let strongSelf = self else { return }
//            var inset = strongSelf.contentTextView.contentInset
//            inset.bottom = height
//
//            // scroll Indicator에도 하단 여백 추가
//            var scrollInset = strongSelf.contentTextView.scrollIndicatorInsets
//            scrollInset.bottom = height
//
//            UIView.animate(withDuration: 0.3) {
//                strongSelf.contentTextView.contentInset = inset
//                strongSelf.contentTextView.scrollIndicatorInsets = scrollInset
//            }
//        })
            .bind(to: contentTextView.rx.contentInset)
            .disposed(by: rx.disposeBag)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}

// Element 형식을 CGFloat 형식으로 제한. 여기서 구현하는 연산자는 CGFloat를 방출하는 Observable에서만 사용 가능
extension ObservableType where Element == CGFloat {
    func toContentInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var inset = textView.contentInset
            inset.bottom = height
            return inset
        }
    }
}

extension Reactive where Base: UITextView {
    var contentInset: Binder<UIEdgeInsets> {
        return Binder(self.base) { textView, inset in
            textView.contentInset = inset
            textView.scrollIndicatorInsets = inset
        }
    }
}

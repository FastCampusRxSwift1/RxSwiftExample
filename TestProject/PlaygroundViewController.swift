//
//  PlaygroundViewController.swift
//  TestProject
//
//  Created by Leonard on 2017. 11. 17..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import RxSwift

class PlaygroundViewController: UIViewController {
    var disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        rxCreate()
//        rxSubject()
//        rxCombine()
//        rxTransform()
        rxFiltering()
    }
}

extension PlaygroundViewController {
    func rxCreate() {
        /*
         create
         just
         from
         empty
         never
         error
         do
         repeatElement
         */
        
        print("\njust")
        Observable<Int>.just(1).subscribe { (event: Event) in
            switch event {
            case let .next(element):
                print("\(element)")
            case let .error(error):
                print(error.localizedDescription)
            case .completed:
                print("completed")
            }
        }.disposed(by: disposeBag)
        
        
        let subscribe: (Event<Int>) -> Void = { (event: Event) in
            switch event {
            case let .next(element):
                print("\(element)")
            case let .error(error):
                print(error.localizedDescription)
            case .completed:
                print("completed")
            }
        }
        
        print("\nFrom")
        Observable.from([1,2,3,4,5]).subscribe(subscribe).disposed(by: disposeBag)
        
        print("\nOf")
        Observable.of(1,2,3,4,5).debug("of").subscribe(subscribe).disposed(by: disposeBag)
        
        print("\nEmpty")
        Observable<Int>.empty().debug("empty").subscribe(subscribe).disposed(by: disposeBag)
        
        print("\nNever")
        Observable<Int>.never().debug("never").subscribe(subscribe).disposed(by: disposeBag)
        
        print("\nError")
        Observable<Int>.error(NSError(domain: "RxDomain", code: 1118, userInfo: nil)).subscribe(subscribe).disposed(by: disposeBag)
        
        print("\nError")
        Observable<Int>.error(NSError(domain: "RxDomain", code: 1118, userInfo: nil)).subscribe(subscribe).disposed(by: disposeBag)
        
        print("\nCreate")
        Observable<Int>.create { (anyObserver: AnyObserver<Int>) -> Disposable in
            
            anyObserver.on(Event.next(1))
            anyObserver.on(Event.next(2))
            anyObserver.on(Event.next(3))
            anyObserver.on(Event.next(4))
            anyObserver.on(Event.next(5))
            anyObserver.on(Event.completed)
            return Disposables.create {
                print("dispose")
            }
        }.subscribe(subscribe).disposed(by: disposeBag)
        
        print("\nRepeatElement")
        Observable<Int>.repeatElement(3).take(10).subscribe(subscribe).disposed(by: disposeBag)
        
        print("\nInterval")
        Observable<Int>.interval(0.5, scheduler: MainScheduler.instance).take(20).subscribe(subscribe).disposed(by: disposeBag)

        print("\nDoOn")
        Observable<Int>.from([1,2,3,4,5]).do(onNext: { (value) in
            print("do onNext: \(value)")
        }, onError: { (error) in
            print("do error: \(error)")
        }, onCompleted: {
            print("do completed")
        }, onSubscribe: {
            print("do subscribe")
        }, onSubscribed: {
            print("do subscribed")
        }, onDispose: {
            print("do disposed")
        }).debug("array").subscribe(onNext: {
            print($0)

        }).disposed(by: disposeBag)
    }
    
    func rxSubject() {
        
        let subscribe: (Event<Int>) -> Void = { (event: Event) in
            switch event {
            case let .next(element):
                print("\(element)")
            case let .error(error):
                print(error.localizedDescription)
            case .completed:
                print("completed")
            }
        }
        
        print("\nPublish Subject")
        let publishSuject: PublishSubject<Int> = PublishSubject()
        publishSuject.subscribe(subscribe).disposed(by: disposeBag)
        publishSuject.on(.next(1))
        publishSuject.onNext(2)
        publishSuject.onNext(4)
        publishSuject.onCompleted()
        publishSuject.onNext(10)
        
        
        let behaviorSubject: BehaviorSubject<Int> = BehaviorSubject(value: 100)
        behaviorSubject.subscribe(subscribe).disposed(by: disposeBag)
        behaviorSubject.onNext(10)
        behaviorSubject.onNext(20)
        behaviorSubject.onNext(30)
        
        let value = (try? behaviorSubject.value()) ?? 0
        print("value: \(value)")
        
        
        let behaviorSubjectArray: BehaviorSubject<[Int]> = BehaviorSubject(value: [])
        behaviorSubjectArray.subscribe(onNext: { (array: [Int]) in
            print("array: \(array)")
        }).disposed(by: disposeBag)
        behaviorSubjectArray.onNext([10, 20, 30])
        behaviorSubjectArray.onNext([10, 20, 30, 40])
        behaviorSubjectArray.onNext([10, 20, 30, 40, 50])
        
        let arrayValue = (try? behaviorSubjectArray.value()) ?? []
        print("arrayValue: \(arrayValue)")
        
        
    }
    
    
    func rxCombine() {
        /*
         merge
         zip
         combineLatest
         */
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        let subscribe: (Event<Int>) -> Void = { (event: Event) in
            switch event {
            case let .next(element):
                print("\(element)")
            case let .error(error):
                print(error.localizedDescription)
            case .completed:
                print("completed")
            }
        }
        
        Observable.merge([subject1, subject2]).debug("merge").subscribe(subscribe).disposed(by: disposeBag)
        
//        Observable<Int>.zip([subject1,subject2]) { (elementArray: [Int]) -> Int in
//            return elementArray.reduce(0, +)
//        }.debug("zip").subscribe(subscribe).disposed(by: disposeBag)
//
//        Observable.combineLatest([subject1, subject2]) { (elementArray: [Int]) -> Int in
//            return elementArray.reduce(0, +)
//            }.debug("combineLatest").subscribe(subscribe).disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext(2)
        subject1.onNext(3)
        subject2.onNext(4)
        subject1.onNext(5)
        subject2.onNext(6)
        
    }
    
    func rxTransform() {
        
        Observable<Int>.just(100).map { value -> String in
            return "value is \(value)"
            }.subscribe(onNext: { (value: String) in
                print(value)
            }).disposed(by: disposeBag)
        
        let subject = PublishSubject<Void>()
        subject.flatMap { (_) -> Observable<Int> in
            return Observable<Int>.of(10,9,8,7)
            }.subscribe(onNext: { (value: Int) in
                print("value: \(value)")
            }).disposed(by: disposeBag)
        subject.onNext(())
        subject.onNext(())
        subject.onNext(())
        
    }
    
    func rxFiltering() {
        let subscribe: (Event<Int>) -> Void = { (event: Event) in
            switch event {
            case let .next(element):
                print("\(element)")
            case let .error(error):
                print(error.localizedDescription)
            case .completed:
                print("completed")
            }
        }
        print("\n filter")
        Observable.from([1,2,3,4,5,6,7,8,9,10]).filter { (value) -> Bool in
            value % 2 == 0
        }.subscribe(subscribe).disposed(by: disposeBag)
        
        
        print("\n distinctUntilChanged")
        Observable.from([0,0,0,0,0,1,2,2,2,3,3,4,5,6,6,7,4,4,3,2]).distinctUntilChanged().subscribe(subscribe).disposed(by: disposeBag)
        print("\n distinctUntilChanged")
        Observable.from([0,0,0,0,0,1,2,2,7,2,3,3,4,10,5,6,6,7,4,4,3,6,2]).distinctUntilChanged { (lhs, rhs) -> Bool in
            return abs(lhs - rhs) > 3
        }.subscribe(subscribe).disposed(by: disposeBag)
        
        print("\n take(1)")
        Observable.from([9,8,7,6,5,4,3,2,1]).take(1).subscribe(subscribe).disposed(by: disposeBag)
        print("\n take(4)")
        Observable.from([9,8,7,6,5,4,3,2,1]).take(4).subscribe(subscribe).disposed(by: disposeBag)
        print("\n skip(1)")
        Observable.from([1,2,3,4,5,6,7,8,9]).skip(1).subscribe(subscribe).disposed(by: disposeBag)
        print("\n skip(4)")
        Observable.from([1,2,3,4,5,6,7,8,9]).skip(4).subscribe(subscribe).disposed(by: disposeBag)
        
    }
}








//
//  ABCViewController.swift
//  TestProject
//
//  Created by Leonard on 2017. 11. 14..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ABCViewController: UIViewController {
    
    @IBOutlet var aTextField: UITextField!
    @IBOutlet var bTextField: UITextField!
    @IBOutlet var cLabel: UILabel!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let aObservable: Observable<Int> =
            aTextField.rx.text.orEmpty.map { Int($0) ?? 0 }
        let bObservable: Observable<Int> =
            bTextField.rx.text.orEmpty.map { Int($0) ?? 0 }
        
        Observable.combineLatest(aObservable,
                                 bObservable,
                                 resultSelector: + )
            .map { "\($0)" }.bind(to: cLabel.rx.text).disposed(by: disposeBag)
        
        
        
        //        Observable.combineLatest(aObservable, bObservable) { (a: Int, b: Int) -> Int in
        //            return a + b
        //            }.map { "\($0)" }.bind(to: cLabel.rx.text).disposed(by: disposeBag)
        
    }
    
}


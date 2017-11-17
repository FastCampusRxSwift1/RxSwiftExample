//
//  ExampleViewController.swift
//  TestProject
//
//  Created by Leonard on 2017. 11. 14..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextFieldExampleViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var label: UILabel!
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.rx.text.subscribe(onNext: { [weak self] (text: String?) in
                self?.label.text = text
            }).disposed(by: disposeBag)
        
        //        textField.rx.text.bind(to: label.rx.text).disposed(by: disposeBag)
        
        
    }
}

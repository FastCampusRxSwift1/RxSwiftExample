//
//  ViewController.swift
//  TestProject
//
//  Created by Leonard on 2017. 10. 22..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var alert: UIAlertController = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        alert.addAction(UIAlertAction(title: "action", style: .cancel, handler: { [weak self] (_) in
            self?.title = "title"
        }))
        self.present(alert, animated: true, completion: nil)

        
        let a = "ab2v9bc13j5jf4jv21".characters.flatMap { (char: Character) -> Int? in
            return Int(String(char)) }.filter { $0 % 2 != 0 }
            .map { $0 * $0 }.reduce(0, +)
        
        
    }

    deinit {
        print("deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


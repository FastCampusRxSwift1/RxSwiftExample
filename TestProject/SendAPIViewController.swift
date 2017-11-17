//
//  SendAPIViewController.swift
//  TestProject
//
//  Created by Leonard on 2017. 11. 18..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class SendAPIViewController: UIViewController {

    @IBOutlet var button: UIButton!
    var disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        rxAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rxAction() {
        button.rx.tap.asObservable().flatMap { _ -> Observable<Model1> in
            API.api1()
            }.subscribe(onNext: { (model: Model1) in
                
            }, onError: { (error: Error) in
                
            }).disposed(by: disposeBag)
    }

}


struct Model1 {
    
}

struct API {
    static func api1() -> Observable<Model1> {
        return APIRouter.api1.buildRequest(parameter: [:]).map { (data) -> Model1 in
            return Model1()
        }
    }
    
    func api2() -> Observable<Model1> {
        return APIRouter.api2.buildRequest(parameter: [:]).map { (data) -> Model1 in
            return Model1()
        }
    }
}

enum APIRouter {
    case api1
    case api2
}

extension APIRouter {
    var host: String { return "https://api.server.com" }
    var path: String {
        switch self {
        case .api1:
            return "/api1"
        case .api2:
            return "/api2"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .api1, .api2:
            return .get
        }
    }
    
    var url: URL {
        return URL(string: "\(host)/\(path)")!
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .api1:
            return URLEncoding.default
        case .api2:
            return URLEncoding.default
        }
    }
    
    func buildRequest(parameter: Parameters) -> Observable<Data> {
        return Observable<Data>.create { observer -> Disposable in
           let request =  Alamofire.request(self.url, method: self.method, parameters: parameter, encoding: self.encoding, headers: nil).responseData(completionHandler: { (dataResponse: DataResponse<Data>) in
                switch dataResponse.result {
                case let .success(value):
                    observer.onNext(value)
                    observer.onCompleted()
                    return
                case let .failure(error):
                    observer.onError(error)
                    return
                }
            })
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}


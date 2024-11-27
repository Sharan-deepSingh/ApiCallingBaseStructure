//
//  ViewController.swift
//  ApiCallingBaseStructure
//
//  Created by Sharandeep Singh on 01/09/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params = ["userId": "64be1b2e654cdde2018adaa1"]
        
//        RestManager<TokenResponse>().makeRequest(on: .initialSwapProfileToken,
//                                                 ofType: .get,
//                                                 withQueryParams: params) { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//                
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        let httpBody: [String: Any] = ["phone": "+916280007351"]
        
        RestManager<DefaultPost>().makeRequest(on: .verifyPhone, ofType: .post, and: httpBody) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}


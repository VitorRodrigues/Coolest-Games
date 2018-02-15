//
//  UIViewController+Extensions.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit
extension UIViewController {
    func showError(_ error: Error) {
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            if nsError.code == NSURLErrorCancelled { return }
        }
        
        showBasicAlert(title: "Error",
                       message: error.localizedDescription,
                       buttonText: "Fechar",
                       handler: nil)
    }
    
    func showBasicAlert(title: String?, message: String?, buttonText: String, handler: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        
        let close = UIAlertAction(title: buttonText, style: .cancel, handler: handler)
        alert.addAction(close)
        
        self.present(alert, animated: true, completion: nil)
    }
}

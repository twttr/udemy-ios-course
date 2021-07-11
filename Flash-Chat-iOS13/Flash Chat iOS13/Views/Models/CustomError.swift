//
//  Error.swift
//  Flash Chat iOS13
//
//  Created by Pavel Romanishkin on 23.03.21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

struct CustomError {
    static func present(error: Error, controller: UIViewController) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil
        )

        alert.addAction(cancelAction)
        controller.present(alert, animated: true, completion: nil)
    }
}

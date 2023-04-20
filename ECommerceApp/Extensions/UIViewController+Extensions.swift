import Foundation
import UIKit

extension UIViewController {

    func showWarningMessage(
        title: String,
        message: String,
        handlerOkay: (() -> Void)?,
        handlerCancel: (() -> Void)?
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(
            UIAlertAction(
                title: "Okay",
                style: .default,
                handler: { _ in
                    handlerOkay?()
                }
            )
        )

        if handlerCancel != nil {
            alertController.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .default,
                    handler: { _ in
                        handlerCancel?()
                    }
                )
            )
        }

        self.present(alertController, animated: true, completion: nil)
    }
}

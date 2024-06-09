import UIKit

struct ErrorModel {
    let message: String
    let actionText: String
    let action: () -> Void
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {
    func showError(_ model: ErrorModel) {
        DispatchQueue.main.async {
            let title = NSLocalizedString("Error.title", comment: "")
            let alert = UIAlertController(
                title: title,
                message: model.message,
                preferredStyle: .alert
            )
            
            let mainAction = UIAlertAction(title: model.actionText, style: .default) { _ in
                model.action()
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Отменить", comment: ""), style: .destructive)

            alert.addAction(mainAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }
}

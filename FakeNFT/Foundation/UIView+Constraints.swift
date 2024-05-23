import UIKit

extension UIView {

    func constraintEdges(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func constraintCenters(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func addSubViews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    func round(squareSize: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: squareSize).isActive = true
        self.widthAnchor.constraint(equalToConstant: squareSize).isActive = true
        self.clipsToBounds = true
        self.layer.cornerRadius = squareSize / 2
    }

    func fullViewWithSafeAreas(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(subview)

        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

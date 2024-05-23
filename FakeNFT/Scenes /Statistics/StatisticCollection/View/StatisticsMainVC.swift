import UIKit

final class StatisticsMainVC: UIViewController {
    private let presenter: StatisticPresenter
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = ConstantsMainVC.tableViewRowHeight
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(presenter: StatisticPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupView()
        setupNavBar()
        setupTableView()
    }
    
    private func setupView() {
        presenter.onSortButtonTap = { [weak self] in
            self?.presentSortAlertController()
        }
        presenter.onUsersListChange = { [weak self] in
            self?.tableView.reloadData()
        }
        presenter.onUserProfileDidTap = { [weak self] user in
            self?.pushUserInfoViewController(withUser: user)
        }
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: UIBarPosition.any,
            barMetrics: UIBarMetrics.default
        )
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let sortButton = UIBarButtonItem(
            image: UIImage(named: "sortButton"),
            style: .plain,
            target: self,
            action: #selector(Self.sortButtonDidTap))
        sortButton.tintColor = UIColor.segmentActive
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupTableView() {
        tableView.register(RatingCell.self, forCellReuseIdentifier: "ratingCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ConstantsMainVC.tableViewHorizontalInset
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -ConstantsMainVC.tableViewHorizontalInset)
        ])
    }
    
    @objc private func sortButtonDidTap() {
        presenter.sortButtonDidTap()
    }
    
    private func presentSortAlertController() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(
            title: "По имени",
            style: .default
        ) { [weak self] _ in
            self?.presenter.sortByNameDidTap()
        })
        
        alert.addAction(UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { [weak self] _ in
            self?.presenter.sortByRatingDidTap()
        })
        
        alert.addAction(UIAlertAction(
            title: "Закрыть",
            style: .cancel) { _ in })
        
        present(alert, animated: true, completion: nil)
    }
    
    private func pushUserInfoViewController(withUser user: User) {
        let userInfoViewController = StatisticProfileVC(user: user)
        let presenter = UserInfoPresenter(view: userInfoViewController, user: user)
        userInfoViewController.presenter = presenter
        navigationController?.pushViewController(userInfoViewController, animated: true)
    }

}

extension StatisticsMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.allUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as? RatingCell

        let user = presenter.allUsers[indexPath.row]
        cell?.setupCell(userData: user)

        guard let cell = cell else {
            return RatingCell()
        }

        return cell
    }
}

extension StatisticsMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.userProfileDidTap(withIndex: indexPath)
    }
}

private enum ConstantsMainVC {
    static let tableViewHorizontalInset: CGFloat = 16
    static let tableViewTopInset: CGFloat = 12
    static let tableViewRowHeight: CGFloat = 88
}

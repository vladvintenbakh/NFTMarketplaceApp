//
//  OnboardingVC.swift
//  Tracker
//
//  Created by Kirill Sklyarov on 04.04.2024.
//

import UIKit

final class OnboardingVC: UIPageViewController {

    // MARK: - Properties
    var pages = [UIViewController]()
    let pageController = UIPageControl()
    let initialPage = 0

    // MARK: - Init
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageVC()
    }

    // MARK: - IB Actions
    @objc private func pageControllerTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true)
    }

    // MARK: - Private methods
    private func setupPageVC() {
        dataSource = self
        delegate = self

        pageController.addTarget(self, action: #selector(pageControllerTapped), for: .valueChanged)

        let firstScreen = OnboardingCustomScreen(image: "image1", titleText: "Исследуйте", subTitleText: "Присоединяйтесь и откройте новый мир уникальных NFT для коллекционеров", isButtonHidden: true)
        let secondScreen = OnboardingCustomScreen(image: "image2", titleText: "Коллекционируйте", subTitleText: "Пополняйте свою коллекцию эксклюзивными картинками, созданными нейросетью!", isButtonHidden: true)
        let thirdScreen = OnboardingCustomScreen(image: "image3", titleText: "Состязайтесь", subTitleText: "Смотрите статистику других и покажите всем, что у вас самая ценная коллекция", isButtonHidden: false)

        pages.append(firstScreen)
        pages.append(secondScreen)
        pages.append(thirdScreen)

        setViewControllers([pages[initialPage]], direction: .forward, animated: true)

        pageController.translatesAutoresizingMaskIntoConstraints = false
        pageController.currentPageIndicatorTintColor = .white
        pageController.pageIndicatorTintColor = .gray
        pageController.numberOfPages = pages.count
        pageController.currentPage = initialPage

        if #available(iOS 14.0, *) {
            guard let progressImage = UIImage(named: "paginator") else {return}
            pageController.preferredIndicatorImage = progressImage
        }

        view.addSubview(pageController)
        NSLayoutConstraint.activate([
            pageController.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            pageController.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageController.heightAnchor.constraint(equalToConstant: 28),
        ])
    }
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension OnboardingVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex == 0 {
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex == pages.count - 1 {
            return pages.first
        } else {
            return pages[currentIndex + 1]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let visibleViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: visibleViewController) {
            pageController.currentPage = index
        }
    }
}

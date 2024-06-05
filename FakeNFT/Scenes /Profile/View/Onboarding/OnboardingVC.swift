//
//  OnboardingVC.swift
//  Tracker
//
//  Created by Kirill Sklyarov on 04.04.2024.
//

import UIKit

final class OnboardingVC: UIPageViewController {

    // MARK: - UI Properties
    private var pages = [UIViewController]()
    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.progressViewStyle = .default
        bar.progressTintColor = .white
        bar.layer.cornerRadius = 16
        bar.layer.masksToBounds = true
        return bar
    } ()

    // MARK: - Other Properties
    private var timer: Timer?
    private var timerStep = Float(0.05)
    private var currentIndex = 0
    private var progress = Float(0.0)
    private var elapsedTime = Float(0.0)
    private var totalTime = Float(6.0)
    private var timePerScreen: Float {
        Float(totalTime) / Float(pages.count)
    }

    // MARK: - Init
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageVC()
        setupProgressBar()
        startTimer()
    }

    // MARK: - IB Actions
    @objc private func timerNext() {
        elapsedTime += timerStep

        needToShowNextPage()
        needToShowFirstPage()
        showNextPage()

        updateProgress()
    }

    // MARK: - Private methods
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerStep), target: self, selector: #selector(timerNext), userInfo: nil, repeats: true)
    }

    private func needToShowNextPage() {
        if elapsedTime > timePerScreen {
            currentIndex += 1
            elapsedTime = 0
        }
    }

    private func needToShowFirstPage() {
        if currentIndex > pages.count - 1 {
            currentIndex = 0
        }
    }

    private func showNextPage() {
        let nextVC = pages[currentIndex]
        setViewControllers([nextVC], direction: .forward, animated: true)
    }

    private func updateProgress() {
        let screenTime = Float(currentIndex) / Float(pages.count)
        progress = screenTime + Float(elapsedTime / totalTime)
        progressBar.progress = progress
    }

    private func setupPageVC() {
        dataSource = self
        delegate = self

        let firstScreen = OnboardingCustomScreen(image: "image1", titleText: "Исследуйте", subTitleText: "Присоединяйтесь и откройте новый мир уникальных NFT для коллекционеров", isButtonHidden: true)
        let secondScreen = OnboardingCustomScreen(image: "image2", titleText: "Коллекционируйте", subTitleText: "Пополняйте свою коллекцию эксклюзивными картинками, созданными нейросетью!", isButtonHidden: true)
        let thirdScreen = OnboardingCustomScreen(image: "image3", titleText: "Состязайтесь", subTitleText: "Смотрите статистику других и покажите всем, что у вас самая ценная коллекция", isButtonHidden: false)

        pages.append(firstScreen)
        pages.append(secondScreen)
        pages.append(thirdScreen)
    }

    private func setupProgressBar() {
        view.addSubViews([progressBar])
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 6),
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
}

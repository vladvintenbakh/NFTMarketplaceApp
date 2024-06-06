//
//  OnboardingVC.swift
//  Tracker
//
//  Created by Kirill Sklyarov on 04.04.2024.
//

import UIKit

final class OnboardingVC: UIPageViewController {

    // MARK: - UI Properties
    private lazy var pages = [UIViewController]()
    private lazy var firstProgressBar = setupProgressBar()
    private lazy var secondProgressBar = setupProgressBar()
    private lazy var thirdProgressBar = setupProgressBar()

    // MARK: - Other Properties
    private var timer: Timer?
    private var timerStep = Float(0.05)
    private var currentIndex = 0
    private var elapsedTime = Float(0)
    private var totalTime = Float(6)
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
        setupUI()
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
    private func setupUI() {
        setupPageVC()
        setupProgressStack()
    }

    private func setupProgressStack() {
        let progressStack = UIStackView(arrangedSubviews: [firstProgressBar, secondProgressBar, thirdProgressBar])
        progressStack.axis = .horizontal
        progressStack.spacing = 10
        progressStack.distribution = .fillEqually

        view.addSubViews([progressStack])
        NSLayoutConstraint.activate([
            progressStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            progressStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressStack.heightAnchor.constraint(equalToConstant: 4),
        ])
    }

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
            secondProgressBar.progress = Float(0)
            thirdProgressBar.progress = Float(0)
        }
    }

    private func showNextPage() {
        let nextVC = pages[currentIndex]
        setViewControllers([nextVC], direction: .forward, animated: true)
    }

    private func updateProgress() {
        var progress = Float(elapsedTime / timePerScreen)

        switch currentIndex {
        case 0: firstProgressBar.progress = progress
        case 1: secondProgressBar.progress = progress
        case 2: thirdProgressBar.progress = progress
        default: break
        }
    }

    private func setupProgressBar() -> UIProgressView {
        let bar = UIProgressView()
        bar.progressViewStyle = .default
        bar.progressTintColor = .white
        bar.layer.cornerRadius = 2
        bar.layer.masksToBounds = true
        return bar
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

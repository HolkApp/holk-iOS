import UIKit
import Combine

protocol OnboardingContainerDelegate: AnyObject {
    func onboardingStopped(_ onboardingContainerViewController: OnboardingContainerViewController)
    func onboardingFinished(_ onboardingContainerViewController: OnboardingContainerViewController)
}

final class OnboardingContainerViewController: UIViewController {
    // MARK: - Public Variables
    weak var delegate: OnboardingContainerDelegate?

    // MARK: - Private Variables
    private let storeController: StoreController
    private let progressView = HolkProgressBarView()
    private let closeButton = HolkButton()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var newUserViewController: NewUserViewController?
    private weak var insuranceProviderTypeViewController: OnboardingInsuranceTypeViewController?
    private weak var insuranceProviderViewController: OnboardingInsuranceProviderViewController?
    private weak var consentViewController: OnboardingConsentViewController?
    private var onboardingViewControllers = [UIViewController]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private lazy var collectionView: UICollectionView = {
        let onboardingLayoutSection = UICollectionViewCompositionalLayout.makeOnboardingViewSection()
        onboardingLayoutSection.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
            let lastVisibleItemIndex = visibleItems.last?.indexPath.item
            lastVisibleItemIndex.flatMap { self?.progressView.currentStep = $0 + 1 }
        }
        let layout = UICollectionViewCompositionalLayout(section: onboardingLayoutSection)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private var progressViewTopAnchor: NSLayoutConstraint?
    private var progressViewHeightAnchor: NSLayoutConstraint?
    private var providerType: InsuranceProviderType?
    private var insuranceProvider: InsuranceProvider?
    private var cancellables = Set<AnyCancellable>()

    init(storeController: StoreController) {
        self.storeController = storeController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func loading() {
        progressView.update(.spinner, animated: false)
        collectionView.isHidden = true
    }

    func startOnboarding(_ user: User) {
        if user.isNewUser {
            showAddNewUser(user)
        } else {
            progressBarToTop(animated: true, completion: { [weak self] in
                self?.showInsuranceType()
            })
        }
    }

    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(resumeLoadingAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseLoadingAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Color.mainBackground

        progressView.totalSteps = 4
        progressView.progressTintColor = Color.mainHighlight
        progressView.trackTintColor = Color.placeholder
        progressView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = Color.mainBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.registerCell(OnboardingCell.self)

        closeButton.set(
            color: Color.mainForeground,
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium)
        )
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(stopOnboarding(_:)), for: .touchUpInside)

        view.addSubview(collectionView)
        view.addSubview(progressView)
        view.addSubview(closeButton)

        setupLayout()
    }

    private func setupLayout() {
        let progressViewTopAnchor = progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 2 - 100)
        let progressViewHeightAnchor = progressView.heightAnchor.constraint(equalToConstant: 150)

        self.progressViewTopAnchor = progressViewTopAnchor
        self.progressViewHeightAnchor = progressViewHeightAnchor
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressViewTopAnchor,
            progressViewHeightAnchor,
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }

    private func showAddNewUser(_ user: User) {
        let newUserViewController = NewUserViewController(user: user)
        newUserViewController.delegate = self
        addChild(newUserViewController)
        newUserViewController.view.frame = view.bounds
        view.addSubview(newUserViewController.view)
        newUserViewController.didMove(toParent: self)
        self.newUserViewController = newUserViewController
    }

    private func showInsuranceType() {
        if let insuranceProviderTypeViewController = insuranceProviderTypeViewController {
            if !onboardingViewControllers.contains(insuranceProviderTypeViewController) {
                onboardingViewControllers.append(insuranceProviderTypeViewController)
            }
        } else {
            let viewController = OnboardingInsuranceTypeViewController(storeController: storeController)
            viewController.delegate = self
            progressView.isHidden = false
            self.insuranceProviderTypeViewController = viewController
            self.onboardingViewControllers.append(viewController)
        }
    }

    private func showInsuranceAggregatedConfirmation(_ addedInsuranceList: [Insurance]) {
        let confirmationViewController = OnboardingConfirmationViewController(storeController, addedInsuranceList: addedInsuranceList)
        confirmationViewController.delegate = self
        onboardingViewControllers.append(confirmationViewController)
        collectionView.scrollToItem(at: IndexPath(item: 3, section: 0), at: .centeredHorizontally, animated: true)
    }

    private func progressBarToTop(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.progressView.update(.bar, animated: animated) {
                if animated {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.progressViewTopAnchor?.constant = 40
                        self.progressViewHeightAnchor?.constant = 40
                        self.view.layoutIfNeeded()
                    }) { _ in
                        self.collectionView.isHidden  = false
                        self.progressView.isHidden = false
                        completion?()
                    }
                } else {
                    self.progressViewTopAnchor?.constant = 40
                    self.progressViewHeightAnchor?.constant = 40
                    self.collectionView.isHidden = false
                    self.progressView.isHidden = false
                    completion?()
                }
            }
        }
    }

    private func progressSpinnerToCenter() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.progressViewTopAnchor?.constant = self.view.bounds.height / 2 - 100
            self.progressViewHeightAnchor?.constant = 150
            self.progressView.update(.spinner, animated: false)
            self.collectionView.isHidden = true
        }
    }

    @objc private func pauseLoadingAnimation() {
        guard !progressView.isHidden else { return }
        progressView.setLoading(false)
    }

    @objc private func resumeLoadingAnimation() {
        guard !progressView.isHidden else { return }
        progressView.setLoading(true)
    }

    @objc private func stopOnboarding(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to cancel", message: nil, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alert.dismiss(animated: true)
            })
        )
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                alert.dismiss(animated: true) {
                    self.delegate?.onboardingStopped(self)
                    self.onboardingViewControllers.removeAll()
                }
            })
        )
        present(alert, animated: true)
    }

    private func showError(_ error: APIError, requestName: String) {
        let alert = UIAlertController(title: requestName + " \(error.code)", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(
            title: "Close",
            style: .default,
            handler: { action in
                alert.dismiss(animated: true)
            })
        )

        present(alert, animated: true)
    }
}

extension OnboardingContainerViewController: NewUserViewControllerDelegate {
    func newUserViewController(_ viewController: NewUserViewController, add email: String) {
        progressView.setLoading(true)
        collectionView.isHidden = true
        progressView.isHidden = false

        newUserViewController?.removeFromParent()
        newUserViewController?.view.removeFromSuperview()

        storeController.userStore.addEmail(email) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.progressBarToTop()
                    self?.showInsuranceType()
                }
            case .failure(let error):
                self?.showError(error, requestName: "authorize/user/email")
            }
        }
    }
}

extension OnboardingContainerViewController: OnboardingInsuranceTypeViewControllerDelegate {
    func onboardingInsuranceProviderType(_ viewController: OnboardingInsuranceTypeViewController, didSelect providerType: InsuranceProviderType) {
        self.providerType = providerType
        if let insuranceProviderViewController = insuranceProviderViewController {
            if !onboardingViewControllers.contains(insuranceProviderViewController) {
                onboardingViewControllers.append(insuranceProviderViewController)
            }
        } else {
            let viewController = OnboardingInsuranceProviderViewController(storeController: storeController)
            viewController.delegate = self
            insuranceProviderViewController = viewController
            onboardingViewControllers.append(viewController)
        }
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension OnboardingContainerViewController: OnboardingInsuranceProviderViewControllerDelegate {
    func onboardingInsuranceProvider(_ viewController: OnboardingInsuranceProviderViewController, didSelect provider: InsuranceProvider) {
        self.insuranceProvider = provider
        if let consentViewController = consentViewController {
            onboardingViewControllers.removeAll { consentViewController == $0 }
        }
        let viewController = OnboardingConsentViewController(storeController: storeController, insuranceProvider: provider)
        viewController.delegate = self
        consentViewController = viewController
        onboardingViewControllers.append(viewController)
        collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension OnboardingContainerViewController: OnboardingConsentViewControllerDelegate {
    func onboardingConsent(_ viewController: OnboardingConsentViewController, didSelect insuranceProvider: InsuranceProvider) {
        progressSpinnerToCenter()
        storeController
            .insuranceStore
            .addInsurance(insuranceProvider) { [weak self] result in
                self?.handleInsuranceIntegration(result)
        }
        storeController
            .insuranceStore
            .insuranceStatus
            .sink { [weak self] result in
                guard let self = self else { return }
                // TODO: remove the print
                print(result)
                switch result {
                case .success(let scrapingStatus):
                    switch scrapingStatus {
                    case .completed:
                        let insuranceList = self.storeController.insuranceStore.insuranceList
                        self.storeController.suggestionStore.fetchAllSuggestions()
                        self.storeController.insuranceStore.fetchAllInsurances()
                        self.showInsuranceAggregatedConfirmation(insuranceList)
                        self.progressBarToTop()
                    default:
                        break
                    }
                case .failure(let error):
                    self.showError(error, requestName: "insurance/scraping/status/id")
                }
        }.store(in: &cancellables)
    }

    private func handleInsuranceIntegration(_ result: Result<IntegrateInsuranceResponse, APIError>) {
        switch result {
        case .success(let integrateInsuranceResponse):
            BankIDService.autostart(
                autoStart: nil,
                redirectLink: BankIDService.holkRedirectLink,
                successHandler: { [weak self] in
                    guard let self = self else { return }
                    self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                        UIApplication.shared.endBackgroundTask(self.backgroundTask)
                    })
                    self.storeController
                        .insuranceStore
                        .pollInsuranceStatus(integrateInsuranceResponse.scrapeSessionId)
                }
            ) { _ in
                self.storeController
                    .insuranceStore
                    .pollInsuranceStatus(integrateInsuranceResponse.scrapeSessionId)
            }
        case .failure(let error):
            showError(error, requestName: "insurance/scraping")
        }
    }
}

extension OnboardingContainerViewController: OnboardingConfirmationViewControllerDelegate {
    func onboardingConfirmation(_ viewController: OnboardingConfirmationViewController) {
        delegate?.onboardingFinished(self)
        onboardingViewControllers.removeAll()
    }
}

extension OnboardingContainerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingViewControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let onboardingCell = collectionView.dequeueCell(OnboardingCell.self, indexPath: indexPath)
        let viewController = onboardingViewControllers[indexPath.item]
        if !children.contains(viewController) {
            addChild(viewController)
            viewController.didMove(toParent: self)
        }
        onboardingCell.configure(onboardingView: viewController.view)
        return onboardingCell
    }
}

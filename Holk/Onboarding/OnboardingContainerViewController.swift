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
    private var newUserViewController: NewUserViewController?
    private lazy var insuranceProviderTypeViewController: OnboardingInsuranceTypeViewController = OnboardingInsuranceTypeViewController(storeController: storeController)
    private lazy var insuranceProviderViewController: OnboardingInsuranceProviderViewController = OnboardingInsuranceProviderViewController(storeController: storeController)
    private var consentViewController: OnboardingConsentViewController?
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
        view.backgroundColor = Color.mainBackgroundColor

        progressView.totalSteps = 4
        progressView.progressTintColor = Color.mainHighlightColor
        progressView.trackTintColor = Color.placeHolderColor
        progressView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = Color.mainBackgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)

        closeButton.set(
            color: Color.mainForegroundColor,
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
            collectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),

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
        insuranceProviderTypeViewController.delegate = self
        progressView.isHidden = false
        if !onboardingViewControllers.contains(insuranceProviderTypeViewController) {
            onboardingViewControllers.append(insuranceProviderTypeViewController)
        }
    }

    private func showInsuranceAggregatedConfirmation() {
        let confirmationViewController = OnboardingConfirmationViewController()
        confirmationViewController.delegate = self
        onboardingViewControllers.append(confirmationViewController)
        collectionView.scrollToItem(at: IndexPath(item: 3, section: 0), at: .centeredHorizontally, animated: true)
        storeController.insuranceStore.fetchAllInsurances { result in
            // TODO Need to change this with real data
            switch result {
            case .success(let allInsuranceResponse):
                confirmationViewController.addedInsurance = allInsuranceResponse.insuranceList.first
            case .failure(let error):
                confirmationViewController.addedInsurance = AllInsuranceResponse.mockInsurnace
                print(error)
                break
            }
        }
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
                }
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
                print(error)
                break
            }
        }
    }
}

extension OnboardingContainerViewController: OnboardingInsuranceTypeViewControllerDelegate {
    func onboardingInsuranceProviderType(_ viewController: OnboardingInsuranceTypeViewController, didSelect providerType: InsuranceProviderType) {
        self.providerType = providerType
        insuranceProviderViewController.delegate = self
        if !onboardingViewControllers.contains(insuranceProviderViewController) {
            onboardingViewControllers.append(insuranceProviderViewController)
        }
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension OnboardingContainerViewController: OnboardingInsuranceProviderViewControllerDelegate {
    func onboardingInsuranceProvider(_ viewController: OnboardingInsuranceProviderViewController, didSelect provider: InsuranceProvider) {
        self.insuranceProvider = provider
        let onboardingConsentViewController = OnboardingConsentViewController(storeController: storeController, insuranceProvider: provider)
        onboardingConsentViewController.delegate = self
        if let consentViewController = consentViewController {
            onboardingViewControllers.removeAll { consentViewController == $0 }
        }
        onboardingViewControllers.append(onboardingConsentViewController)
        collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
        self.consentViewController = onboardingConsentViewController
    }
}

extension OnboardingContainerViewController: OnboardingConsentViewControllerDelegate {
    func onboardingConsent(_ viewController: OnboardingConsentViewController, didSelect insuranceProvider: InsuranceProvider) {
        progressSpinnerToCenter()
        storeController
            .insuranceCredentialStore
            .addInsurance(insuranceProvider)
        storeController
            .insuranceCredentialStore
            .insuranceStatus.sink { [weak self] scrapingStatus in
            print(scrapingStatus)
            switch scrapingStatus {
            case .completed:
                self?.showInsuranceAggregatedConfirmation()
                self?.progressBarToTop()
            default:
                break
            }
        }.store(in: &cancellables)
    }
}

extension OnboardingContainerViewController: OnboardingConfirmationViewControllerDelegate {
    func onboardingConfirmation(_ viewController: OnboardingConfirmationViewController) {
        delegate?.onboardingFinished(self)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.identifier, for: indexPath)
        if let onboardingCell = cell as? OnboardingCell {
            let viewController = onboardingViewControllers[indexPath.item]
            if !children.contains(viewController) {
                addChild(viewController)
                viewController.didMove(toParent: self)
            }
            onboardingCell.configure(onboarding: viewController.view)
        }
        return cell
    }
}

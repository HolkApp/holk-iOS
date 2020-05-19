import UIKit
import Combine

protocol AddInsuranceContainerViewControllerDelegate: AnyObject {
    func addInsuranceDidFinish(_ viewController: AddInsuranceContainerViewController)
}

final class AddInsuranceContainerViewController: UIViewController {
    // MARK: - Public Variables
    weak var delegate: AddInsuranceContainerViewControllerDelegate?

    // MARK: - Private Variables
    private let storeController: StoreController
    private let progressView = HolkProgressBarView()
    private let closeButton = HolkButton()
    private lazy var insuranceProviderTypeViewController: AddInsuranceTypeViewController =
        AddInsuranceTypeViewController(storeController: storeController)
    private lazy var insuranceProviderViewController: AddInsuranceProviderViewController = AddInsuranceProviderViewController(storeController: storeController)
    private var consentViewController: AddInsuranceConsentViewController?
    private var addInsuranceViewControllers = [UIViewController]() {
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
        closeButton.addTarget(self, action: #selector(stopAddingInsurance(_:)), for: .touchUpInside)

        view.addSubview(collectionView)
        view.addSubview(progressView)
        view.addSubview(closeButton)

        setupLayout()
        startOnboarding()
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

    private func startOnboarding() {
        progressView.isHidden = true
        progressBarToTop(animated: false, completion: { [weak self] in
            self?.showInsuranceType()
        })
    }
    private func showInsuranceType() {
        insuranceProviderTypeViewController.delegate = self
        progressView.isHidden = false
        if !addInsuranceViewControllers.contains(insuranceProviderTypeViewController) {
            addInsuranceViewControllers.append(insuranceProviderTypeViewController)
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

    private func showInsuranceAggregatedConfirmation() {
        let confirmationViewController = AddInsuranceConfirmationViewController()
        confirmationViewController.delegate = self
        addInsuranceViewControllers.append(confirmationViewController)
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

    @objc private func pauseLoadingAnimation() {
        guard !progressView.isHidden else { return }
        progressView.setLoading(false)
    }

    @objc private func resumeLoadingAnimation() {
        guard !progressView.isHidden else { return }
        progressView.setLoading(true)
    }

    @objc private func stopAddingInsurance(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension AddInsuranceContainerViewController: AddInsuranceTypeViewControllerDelegate {
    func addInsuranceProviderType(_ viewController: AddInsuranceTypeViewController, didSelect providerType: InsuranceProviderType) {
        self.providerType = providerType
        insuranceProviderViewController.delegate = self
        if !addInsuranceViewControllers.contains(insuranceProviderViewController) {
            addInsuranceViewControllers.append(insuranceProviderViewController)
        }
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension AddInsuranceContainerViewController: AddInsuranceProviderViewControllerDelegate {
    func addInsuranceProvider(_ viewController: AddInsuranceProviderViewController, didSelect provider: InsuranceProvider) {
        guard let providerType = providerType else { fatalError("No providerType selected") }
        self.insuranceProvider = provider
        let addInsuranceConsentViewController = AddInsuranceConsentViewController(storeController: storeController, insuranceProvider: provider, providerType: providerType)
        addInsuranceConsentViewController.delegate = self
        if let consentViewController = consentViewController {
            addInsuranceViewControllers.removeAll { consentViewController == $0 }
        }
        addInsuranceViewControllers.append(addInsuranceConsentViewController)
        self.consentViewController = addInsuranceConsentViewController
        collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension AddInsuranceContainerViewController: AddInsuranceConsentViewControllerDelegate {
    func addInsuranceConsent(_ viewController: AddInsuranceConsentViewController) {
        guard let insuranceProvider = insuranceProvider else {
            fatalError("insuranceProvider or providerType is null")
        }
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
            }
        .store(in: &cancellables)
    }
}

extension AddInsuranceContainerViewController: AddInsuranceConfirmationViewControllerDelegate {
    func addInsuranceFinished(_ viewController: AddInsuranceConfirmationViewController) {
        delegate?.addInsuranceDidFinish(self)
    }
}

extension AddInsuranceContainerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        addInsuranceViewControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.identifier, for: indexPath)
        if let onboardingCell = cell as? OnboardingCell {
            let viewController = addInsuranceViewControllers[indexPath.item]
            onboardingCell.configure(onboarding: viewController.view)
        }
        return cell
    }
}

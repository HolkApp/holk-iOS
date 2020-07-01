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
    private weak var insuranceProviderTypeViewController: AddInsuranceTypeViewController?
    private weak var insuranceProviderViewController: AddInsuranceProviderViewController?
    private weak var consentViewController: AddInsuranceConsentViewController?
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
        view.backgroundColor = Color.mainBackground

        progressView.totalSteps = 4
        progressView.progressTintColor = Color.mainHighlight
        progressView.trackTintColor = Color.placeHolder
        progressView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = Color.mainBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)

        closeButton.set(
            color: Color.mainForeground,
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium)
        )
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(stopAddingInsurance(_:)), for: .touchUpInside)

        view.addSubview(collectionView)
        view.addSubview(progressView)
        view.addSubview(closeButton)

        setupLayout()
        startAddingInsurance()
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
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func startAddingInsurance() {
        progressView.isHidden = true
        progressBarToTop(animated: false, completion: { [weak self] in
            self?.showInsuranceType()
        })
    }

    private func showInsuranceType() {
        if let insuranceProviderTypeViewController = insuranceProviderTypeViewController {
            if !addInsuranceViewControllers.contains(insuranceProviderTypeViewController) {
                addInsuranceViewControllers.append(insuranceProviderTypeViewController)
            }
        } else {
            let viewController = AddInsuranceTypeViewController(storeController: storeController)
            viewController.delegate = self
            progressView.isHidden = false
            self.insuranceProviderTypeViewController = viewController
            self.addInsuranceViewControllers.append(viewController)
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

    private func showInsuranceAggregatedConfirmation(_ addedInsuranceList: [Insurance]) {
        let confirmationViewController = AddInsuranceConfirmationViewController(addedInsuranceList)
        confirmationViewController.delegate = self
        addInsuranceViewControllers.append(confirmationViewController)
        collectionView.scrollToItem(at: IndexPath(item: 3, section: 0), at: .centeredHorizontally, animated: true)
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
                    self.dismiss(animated: true)
                    self.addInsuranceViewControllers.removeAll()
                }
            })
        )
        present(alert, animated: true)
    }
}

extension AddInsuranceContainerViewController: AddInsuranceTypeViewControllerDelegate {
    func addInsuranceProviderType(_ viewController: AddInsuranceTypeViewController, didSelect providerType: InsuranceProviderType) {
        self.providerType = providerType
        if let insuranceProviderViewController = insuranceProviderViewController {
            if !addInsuranceViewControllers.contains(insuranceProviderViewController) {
                addInsuranceViewControllers.append(insuranceProviderViewController)
            }
        } else {
            let viewController = AddInsuranceProviderViewController(storeController: storeController)
            viewController.delegate = self
            insuranceProviderViewController = viewController
            addInsuranceViewControllers.append(viewController)
        }
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension AddInsuranceContainerViewController: AddInsuranceProviderViewControllerDelegate {
    func addInsuranceProvider(_ viewController: AddInsuranceProviderViewController, didSelect provider: InsuranceProvider) {
        guard let providerType = providerType else { fatalError("No providerType selected") }
        self.insuranceProvider = provider
        if let consentViewController = consentViewController {
            addInsuranceViewControllers.removeAll { consentViewController == $0 }
        }
        let viewController = AddInsuranceConsentViewController(storeController: storeController, insuranceProvider: provider, providerType: providerType)
        viewController.delegate = self
        consentViewController = viewController
        addInsuranceViewControllers.append(viewController)
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
            .insuranceStore
            .addInsurance(insuranceProvider)
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
                        let insuranceList = self.storeController.insuranceStore.insuranceList.value
                        self.storeController.suggestionStore.fetchAllSuggestions()
                        self.showInsuranceAggregatedConfirmation(insuranceList)
                        self.progressBarToTop()
                    default:
                        break
                    }
                case .failure(let error):
                    break
                }
        }.store(in: &cancellables)
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
        let onboardingCell = collectionView.dequeueCell(ofType: OnboardingCell.self, indexPath: indexPath)
        let viewController = addInsuranceViewControllers[indexPath.item]
        if !children.contains(viewController) {
            addChild(viewController)
            viewController.didMove(toParent: self)
        }
        onboardingCell.configure(onboardingView: viewController.view)
        return onboardingCell
    }
}

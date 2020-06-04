//
//  InsuranceDetailViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-29.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceDetailViewController: UIViewController {
    // MARK: - Public variables
    let tableView = UITableView()
    let ringChart = HolkRingChart()
    var insurance: Insurance
    
    weak var coordinator: InsuranceCoordinator?

    init(insurance: Insurance) {
        self.insurance = insurance

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barTintColor = Color.secondaryBackgroundColor
    }

    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Color.secondaryBackgroundColor

        ringChart.dataSource = self
        ringChart.translatesAutoresizingMaskIntoConstraints = false

        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 224
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .zero
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset.top = 200
        tableView.setContentOffset(CGPoint(x: 0, y: -200), animated: false)

        tableView.register(HomeInsuranceDetailTableViewCell.self, forCellReuseIdentifier: HomeInsuranceDetailTableViewCell.identifier)

        view.addSubview(ringChart)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            ringChart.widthAnchor.constraint(equalToConstant: 100),
            ringChart.heightAnchor.constraint(equalTo: ringChart.widthAnchor),
            ringChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            ringChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension InsuranceDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIViewController()
        viewController.title = "Subinsurance Title"
        viewController.view.backgroundColor = .white
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

// MARK: - UITableViewDataSource
extension InsuranceDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insurance.segments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeInsuranceDetailTableViewCell.identifier, for: indexPath)
        let segment = insurance.segments[indexPath.item]
        if let cell = cell as? HomeInsuranceDetailTableViewCell {
            cell.configure(with: segment)
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = (scrollView.adjustedContentOffset.y / 80).clamped(min: 0, max: 1)
        ringChart.alpha = (1 - y)
    }
}

extension InsuranceDetailViewController: HolkRingChartDataSource {
        private var mockNumberOfSegments: Int {
        return 6
    }

    func numberOfSegments(_ ringChart: HolkRingChart) -> Int {
        return mockNumberOfSegments
    }

    func ringChart(_ ringChart: HolkRingChart, sizeForSegmentAt index: Int) -> CGFloat {
        return 1 / CGFloat(numberOfSegments(ringChart))
    }

    func ringChart(_ ringChart: HolkRingChart, colorForSegmentAt index: Int) -> UIColor? {
        if index == 0 {
            return Color.mainForegroundColor
        } else if index == 1 {
            return Color.mainHighlightColor
        } else if index == 2 {
            return Color.successColor
        } else if index == 3 {
            return .green
        } else if index == 4 {
            return .red
        } else {
            return .cyan
        }
    }

    func ringChart(_ ringChart: HolkRingChart, ringChartWidthAt index: Int) -> CGFloat? {
        return 8
    }

    func ringChart(_ ringChart: HolkRingChart, iconForSegmentAt index: Int) -> UIImage? {
        if index == 0 {
            return UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
        } else if index == 1 {
            return UIImage(named: "Plane")?.withRenderingMode(.alwaysTemplate)
        } else if index == 2{
            return UIImage(named: "Shoe")?.withRenderingMode(.alwaysTemplate)
        } else {
            return UIImage(named: "Car")?.withRenderingMode(.alwaysTemplate)
        }
    }
}

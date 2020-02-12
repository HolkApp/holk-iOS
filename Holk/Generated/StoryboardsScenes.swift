// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum InsuranceOverview: StoryboardType {
    internal static let storyboardName = "InsuranceOverview"

    internal static let insuranceCostViewController = SceneType<InsuranceCostViewController>(storyboard: InsuranceOverview.self, identifier: "InsuranceCostViewController")

    internal static let insuranceDetailViewController = SceneType<InsuranceDetailViewController>(storyboard: InsuranceOverview.self, identifier: "InsuranceDetailViewController")

    internal static let insuranceOverviewViewController = SceneType<InsuranceOverviewViewController>(storyboard: InsuranceOverview.self, identifier: "InsuranceOverviewViewController")

    internal static let insurancesViewController = SceneType<InsurancesViewController>(storyboard: InsuranceOverview.self, identifier: "InsurancesViewController")
  }
  internal enum InsuranceProtection: StoryboardType {
    internal static let storyboardName = "InsuranceProtection"

    internal static let insuranceProtectionViewController = SceneType<InsuranceProtectionViewController>(storyboard: InsuranceProtection.self, identifier: "InsuranceProtectionViewController")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Onboarding: StoryboardType {
    internal static let storyboardName = "Onboarding"

    internal static let newUserViewController = SceneType<NewUserViewController>(storyboard: Onboarding.self, identifier: "NewUserViewController")

    internal static let onboardingConfirmedViewController = SceneType<OnboardingConfirmedViewController>(storyboard: Onboarding.self, identifier: "OnboardingConfirmedViewController")

    internal static let onboardingInfoViewController = SceneType<OnboardingInfoViewController>(storyboard: Onboarding.self, identifier: "OnboardingInfoViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}

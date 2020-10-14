//
//  LocalizedString.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-13.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct LocalizedString {
    enum Generic {
        static let close = NSLocalizedString("Generic.Close", value: "Close", comment: "Generic text for close")
        static let ok = NSLocalizedString("Generic.OK", value: "OK", comment: "Generic text for OK")
        static let cancel = NSLocalizedString("Generic.Cancel", value: "Cancel", comment: "Generic text for Cancel")
        static let loading = NSLocalizedString("Generic.Loading", value: "Loading, please wait", comment: "Generic description text for loading text")

        enum Alert {
            static let stopAggregationTitle = NSLocalizedString("Generic.Alert.StopAggregationTitle", value: "Do you want to stop insurance aggregation", comment: "Alert title text for asking user before quite the insurnace aggregation flow")
        }

        enum Error {
            static let title = NSLocalizedString("Generic.Error.Title", value: "Error", comment: "Generic text for error title")
        }
    }

    enum Onboarding {
        enum Landing {
            static let login = NSLocalizedString("Onboarding.Landing.Login", value: "Logga in", comment: "Login text on landing view")
            static let firstTitle = NSLocalizedString("Onboarding.Landing.FirstTitle", value: "Hitta dina luckor", comment: "First title text on horizontal scrollable landing view")
            static let secondTitle = NSLocalizedString("Onboarding.Landing.SecondTitle", value: "Förstå din försäkring", comment: "Second title text on horizontal scrollable landing view")
            static let thirdTitle = NSLocalizedString("Onboarding.Landing.ThirdTitle", value: "Bli bättre skyddad", comment: "Third title text on horizontal scrollable landing view")
        }
        
        enum Information {
            static let title = NSLocalizedString("Onboarding.Information.Title", value: "Så här funkar det", comment: "Title text for onboarding information view")
            static let subtitle = NSLocalizedString("Onboarding.Information.Subtitle", value: "Först granskar och analyseriar vi din försäkring och sedan jämför vi den med hur ditt vardagsliv ser ut.", comment: "Subtitle text for onboarding information view")
            static let steps = NSLocalizedString("Onboarding.Information.Steps", value: "3 enkla steg", comment: "Steps header text for onboarding information view")

            static let firstStep = NSLocalizedString("Onboarding.Information.FirstStep", value: "Hämta din försäkring med Bank-ID.", comment: "First step text on the onboarding information view")
            static let secondStep = NSLocalizedString("Onboarding.Information.SecondStep", value: "Svara på några enkla frågor om din vardag", comment: "Second step text on the onboarding information view")
            static let thirdStep = NSLocalizedString("Onboarding.Information.ThirdStep", value: "Holks AI motor analyserar och letar luckor och saknade skydd som du bör tänka på.", comment: "Third step text on the onboarding information view")
        }

        enum NewUser {
            static let title = NSLocalizedString("Onboarding.NewUser.Title", value: "Hi %@,", comment: "Welcome title text for onboarding new user view")
            static let subtitle = NSLocalizedString("Onboarding.NewUser.Subtitle", value: "Great to see that you want to sign up for Holk", comment: "Welcome subtitle text for onboarding new user view")
            static let description = NSLocalizedString("Onboarding.NewUser.Description", value: "Enter your mail adress in order to complete your account", comment: "Description text for asking email address on onboarding new user view")
            static let emailPlaceholder = NSLocalizedString("Onboarding.NewUser.EmailPlaceholder", value: "E-post adress", comment: "Email placeholder text for on onboarding new user view")


        }
    }
}

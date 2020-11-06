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
        static let piece = NSLocalizedString("Generic.Piece", value: "%@ st", comment: "Number of things, singular")
        static let pieces = NSLocalizedString("Generic.Pieces", value: "%@ st", comment: "Number of things, plural")

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

    enum Insurance {
        static let text = NSLocalizedString("Insurance.Text", value: "Försäkringar", comment: "Insurance text")
        static let company = NSLocalizedString("Insurance.Company", value: "Bolag", comment: "Insurance company text")

        static let daysLeft = NSLocalizedString("Insurance.DaysLeft", value: "Dagar kvar", comment: "Days left text to show how many days left before the insurance is expired, in plural")
        static let dayLeft = NSLocalizedString("Insurance.DayLeft", value: "Dag kvar", comment: "Day left text to show how many days left before the insurance is expired, in singular")
        static let expiresToday = NSLocalizedString("Insurance.ExpiresToday", value: "Expires today", comment: "Expires today text to when the insurance is expiring")
        static let expired = NSLocalizedString("Insurance.Expired", value: "Expired", comment: "Expired text to when the insurance is expired")
        static let validUntil = NSLocalizedString("Insurance.ValidUntil", value: "Gäller till", comment: "Valid until text to show when the insurance is expiring")
        static let homeInsurance = NSLocalizedString("Insurance.HomeInsurance", value: "Hemförsäkring", comment: "Translation for home insurance")

        enum Aggregate {
            static let navigationTitle = NSLocalizedString("Insurance.Aggregate.NavigationTitle", value: "Start finding your gaps", comment: "Start title text on the navigation bar for aggregate new insurance")
            static let selectInsuranceProvider = NSLocalizedString("Insurance.Aggregate.SelectInsuranceProvider", value: "Pick an insurance company", comment: "Text for select which insurance company provider to aggregate the insurance")
            static let selectInsurance = NSLocalizedString("Insurance.Aggregate.SelectInsurance", value: "Pick an insurance type", comment: "Text for select which insurance type to aggregate the insurance")
            static let addInsurance = NSLocalizedString("Insurance.Aggregate.AddInsurance", value: "Add your insurance", comment: "Header text to let the user to aggregate the insurance")
            static let description = NSLocalizedString("Insurance.Aggregate.Description", value: "We will fetch your insurance from %@. \n[Our terms and policies](http://google.com)", comment: "Description text to ask the user to aggregate the insurance and the text to show a link to terms and condition")
            static let comingSoon = NSLocalizedString("Insurance.Aggregate.ComingSoon", value: "Coming Soon", comment: "Coming soon text to show when for not supported insurance type when aggregate the insurance")
            static let temporaryUnavailable = NSLocalizedString("Insurance.Aggregate.TemporaryUnavailable", value: "Temporary unavailable", comment: "Temporary unavailable text to show when the provider is not available for aggregate at the momnent")

            enum Confirmation {
                static let title = NSLocalizedString("Insurance.Aggregate.Confirmation.Title", value: "Great,", comment: "Title text when the aggregation is finished")
                static let insuranceFound = NSLocalizedString("Insurance.Aggregate.Confirmation.InsuranceFound", value: "We found your insurance at %@", comment: "Text to show when the aggregation is success and find the insurance")
                static let insuranceNotFound = NSLocalizedString("Insurance.Aggregate.Confirmation.InsuranceNotFound", value: "Sorry, but we cannot find your insurance", comment: "Text to show when not finding the insurance after aggregation")
                static let done = NSLocalizedString("Insurance.Aggregate.Confirmation.Done", value: "Add to Holk", comment: "Text for the done button text to close the confirmation screen")
            }
        }

        enum Details {
            static let title = NSLocalizedString("Insurance.Details.Title", value: "Dina skydd", comment: "Title Text to show on the insurnace detials view")
            static let protections = NSLocalizedString("Insurance.Details.Protections", value: "Skydd", comment: "Protections text to show on how many subinsurance you have from the insurnace")
            static let validForPerson = NSLocalizedString("Insurance.Details.ValidForPerson", value: "Gäller för", comment: "Valid for text to show who is the insurance protection for")
            static let cost = NSLocalizedString("Insurance.Details.Cost", value: "Kostnad", comment: "Text to show the cost of the insurance")
            static let costPerMonth = NSLocalizedString("Insurance.Details.CostPerMonth", value: "%@ kr/mån", comment: "Text to show the cost per month unit of the insurance")
            static let basicProtections = NSLocalizedString("Insurance.Details.BasicProtections", value: "Grundskydd", comment: "Text to show the basic protections(subinsurances) of the insurance")
            static let additionalProtections = NSLocalizedString("Insurance.Details.AdditionalProtections", value: "Grundskydd", comment: "Text to show the additional protections(subinsurances) of the insurance")
        }
    }

    enum Suggestion {
        enum Gap {
            static let gap = NSLocalizedString("Suggestion.Gap.Gap", value: "Lukor", comment: "Gaps suggestion text, singular")
            static let gaps = NSLocalizedString("Suggestion.Gap.Gaps", value: "Lukor", comment: "Gaps suggestion text, plural")
            static let title = NSLocalizedString("Suggestion.Gap.Title", value: "Luckor som finns i ditt skydd", comment: "Gaps suggestion title text on the suggestion list")
            static let actionButton = NSLocalizedString("Suggestion.Gap.ActionButton", value: "Skaffa skydd", comment: "Button text on the gap suggestion detail view for the call to action to get more insurance")
        }

        enum ThinkOf {
            static let thinkOf = NSLocalizedString("Suggestion.ThinkOf.ThinkOf", value: "Tänk på", comment: "Thinkofs suggestion text, singular")
            static let thinkOfs = NSLocalizedString("Suggestion.ThinkOf.ThinkOfs", value: "Tänk på", comment: "Thinkofs suggestion text, plural")
            static let title = NSLocalizedString("Suggestion.ThinkOf.Title", value: "Viktiga saker att tänka på", comment: "Thinkofs suggestion title text on the suggestion list")
            static let detailTitle = NSLocalizedString("Suggestion.ThinkOf.DetailTitle", value: "Din info", comment: "Thinkofs suggestion detail title text on the think of suggestion detail")
        }
    }
}

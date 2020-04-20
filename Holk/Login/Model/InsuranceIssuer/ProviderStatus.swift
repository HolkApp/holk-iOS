//
// ProviderStatus.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct InsuranceProvider: Codable {

    public enum InsuranceIssuerStatus: String, Codable { 
        case available = "AVAILABLE"
        case underImplementation = "UNDER_IMPLEMENTATION"
        case notImplemented = "NOT_IMPLEMENTED"
    }
    public var _description: String?
    public var displayName: String
    public var insuranceIssuerStatus: InsuranceIssuerStatus
    public var internalName: String
    public var logoUrl: String
    public var websiteUrl: String

    public init(_description: String, displayName: String, insuranceIssuerStatus: InsuranceIssuerStatus, internalName: String, logoUrl: String, websiteUrl: String) {
        self._description = _description
        self.displayName = displayName
        self.insuranceIssuerStatus = insuranceIssuerStatus
        self.internalName = internalName
        self.logoUrl = logoUrl
        self.websiteUrl = websiteUrl
    }

    public enum CodingKeys: String, CodingKey { 
        case _description = "description"
        case displayName
        case insuranceIssuerStatus
        case internalName
        case logoUrl
        case websiteUrl
    }
}

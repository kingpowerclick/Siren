//
//  AppStoreCountry.swift
//  Siren
//
//  Created by Harlan Kellaway on 11/9/20.
//  Copyright © 2020 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// Region or country of an App Store in which an app can be available.
///
/// [List of country codes](https://help.apple.com/app-store-connect/#/dev997f9cf7c)
public struct AppStoreCountry
{
    /// Raw country code. ex. "US" for United States.
    public let code: String?
}

extension AppStoreCountry
{
  public static let afghanistan: AppStoreCountry = "AFG"
  public static let unitedArabEmirates: AppStoreCountry = "AE"
  public static let antiguaAndBarbuda: AppStoreCountry = "AG"
  public static let anguilla: AppStoreCountry = "AI"
  public static let albania: AppStoreCountry = "AL"
  public static let armenia: AppStoreCountry = "AM"
  public static let angola: AppStoreCountry = "AO"
  public static let argentina: AppStoreCountry = "AR"
  public static let austria: AppStoreCountry = "AT"
  public static let australia: AppStoreCountry = "AU"
  public static let azerbaijan: AppStoreCountry = "AZ"
  public static let barbados: AppStoreCountry = "BB"
  public static let belgium: AppStoreCountry = "BE"
  public static let bosniaAndHerzegovina: AppStoreCountry = "BIH"
  public static let burkinaFaso: AppStoreCountry = "BF"
  public static let bulgaria: AppStoreCountry = "BG"
  public static let bahrain: AppStoreCountry = "BH"
  public static let benin: AppStoreCountry = "BJ"
  public static let bermuda: AppStoreCountry = "BM"
  public static let brunei: AppStoreCountry = "BN"
  public static let bolivia: AppStoreCountry = "BO"
  public static let brazil: AppStoreCountry = "BR"
  public static let bahamas: AppStoreCountry = "BS"
  public static let bhutan: AppStoreCountry = "BT"
  public static let botswana: AppStoreCountry = "BW"
  public static let belarus: AppStoreCountry = "BY"
  public static let belize: AppStoreCountry = "BZ"
  public static let cameroon: AppStoreCountry = "CMR"
  public static let canada: AppStoreCountry = "CA"
  public static let congoRepublic: AppStoreCountry = "CG"
  public static let switzerland: AppStoreCountry = "CH"
  public static let coteDIvoire: AppStoreCountry = "CIV"
  public static let chile: AppStoreCountry = "CL"
  public static let china: AppStoreCountry = "CN"
  public static let colombia: AppStoreCountry = "CO"
  public static let congoDemocraticRepublic: AppStoreCountry = "COD"
  public static let costaRica: AppStoreCountry = "CR"
  public static let capeVerde: AppStoreCountry = "CV"
  public static let cyprus: AppStoreCountry = "CY"
  public static let czechRepublic: AppStoreCountry = "CZ"
  public static let germany: AppStoreCountry = "DE"
  public static let denmark: AppStoreCountry = "DK"
  public static let dominica: AppStoreCountry = "DM"
  public static let dominicanRepublic: AppStoreCountry = "DO"
  public static let algeria: AppStoreCountry = "DZ"
  public static let ecuador: AppStoreCountry = "EC"
  public static let estonia: AppStoreCountry = "EE"
  public static let egypt: AppStoreCountry = "EG"
  public static let spain: AppStoreCountry = "ES"
  public static let finland: AppStoreCountry = "FI"
  public static let fiji: AppStoreCountry = "FJ"
  public static let micronesia: AppStoreCountry = "FM"
  public static let france: AppStoreCountry = "FR"
  public static let gabon: AppStoreCountry = "GAB"
  public static let unitedKingdom: AppStoreCountry = "GB"
  public static let grenada: AppStoreCountry = "GD"
  public static let georgia: AppStoreCountry = "GEO"
  public static let ghana: AppStoreCountry = "GH"
  public static let gambia: AppStoreCountry = "GM"
  public static let greece: AppStoreCountry = "GR"
  public static let guatemala: AppStoreCountry = "GT"
  public static let guineaBissau: AppStoreCountry = "GW"
  public static let guyana: AppStoreCountry = "GY"
  public static let hongKong: AppStoreCountry = "HK"
  public static let honduras: AppStoreCountry = "HN"
  public static let croatia: AppStoreCountry = "HR"
  public static let hungary: AppStoreCountry = "HU"
  public static let indonesia: AppStoreCountry = "ID"
  public static let ireland: AppStoreCountry = "IE"
  public static let israel: AppStoreCountry = "IL"
  public static let india: AppStoreCountry = "IN"
  public static let iraq: AppStoreCountry = "IRQ"
  public static let iceland: AppStoreCountry = "IS"
  public static let italy: AppStoreCountry = "IT"
  public static let jamaica: AppStoreCountry = "JM"
  public static let jordan: AppStoreCountry = "JO"
  public static let japan: AppStoreCountry = "JP"
  public static let kenya: AppStoreCountry = "KE"
  public static let kyrgyzstan: AppStoreCountry = "KG"
  public static let cambodia: AppStoreCountry = "KH"
  public static let stKittsAndNevis: AppStoreCountry = "KN"
  public static let korea: AppStoreCountry = "KR"
  public static let kuwait: AppStoreCountry = "KW"
  public static let caymanIslands: AppStoreCountry = "KY"
  public static let kazakhstan: AppStoreCountry = "KZ"
  public static let laos: AppStoreCountry = "LA"
  public static let lebanon: AppStoreCountry = "LB"
  public static let libya: AppStoreCountry = "LBY"
  public static let stLucia: AppStoreCountry = "LC"
  public static let sriLanka: AppStoreCountry = "LK"
  public static let liberia: AppStoreCountry = "LR"
  public static let lithuania: AppStoreCountry = "LT"
  public static let luxembourg: AppStoreCountry = "LU"
  public static let latvia: AppStoreCountry = "LV"
  public static let morocco: AppStoreCountry = "MAR"
  public static let moldova: AppStoreCountry = "MD"
  public static let maldives: AppStoreCountry = "MDV"
  public static let madagascar: AppStoreCountry = "MG"
  public static let northMacedonia: AppStoreCountry = "MK"
  public static let mali: AppStoreCountry = "ML"
  public static let myanmar: AppStoreCountry = "MMR"
  public static let mongolia: AppStoreCountry = "MN"
  public static let montenegro: AppStoreCountry = "MNE"
  public static let macau: AppStoreCountry = "MO"
  public static let mauritania: AppStoreCountry = "MR"
  public static let montserrat: AppStoreCountry = "MS"
  public static let malta: AppStoreCountry = "MT"
  public static let mauritius: AppStoreCountry = "MU"
  public static let malawi: AppStoreCountry = "MW"
  public static let mexico: AppStoreCountry = "MX"
  public static let malaysia: AppStoreCountry = "MY"
  public static let mozambique: AppStoreCountry = "MZ"
  public static let namibia: AppStoreCountry = "NA"
  public static let niger: AppStoreCountry = "NE"
  public static let nigeria: AppStoreCountry = "NG"
  public static let nicaragua: AppStoreCountry = "NI"
  public static let netherlands: AppStoreCountry = "NL"
  public static let norway: AppStoreCountry = "NO"
  public static let nepal: AppStoreCountry = "NP"
  public static let nauru: AppStoreCountry = "NRU"
  public static let newZealand: AppStoreCountry = "NZ"
  public static let oman: AppStoreCountry = "OM"
  public static let panama: AppStoreCountry = "PA"
  public static let peru: AppStoreCountry = "PE"
  public static let papuaNewGuinea: AppStoreCountry = "PG"
  public static let philippines: AppStoreCountry = "PH"
  public static let pakistan: AppStoreCountry = "PK"
  public static let poland: AppStoreCountry = "PL"
  public static let portugal: AppStoreCountry = "PT"
  public static let palau: AppStoreCountry = "PW"
  public static let paraguay: AppStoreCountry = "PY"
  public static let qatar: AppStoreCountry = "QA"
  public static let romania: AppStoreCountry = "RO"
  public static let russia: AppStoreCountry = "RU"
  public static let rwanda: AppStoreCountry = "RWA"
  public static let saudiArabia: AppStoreCountry = "SA"
  public static let solomonIslands: AppStoreCountry = "SB"
  public static let seychelles: AppStoreCountry = "SC"
  public static let sweden: AppStoreCountry = "SE"
  public static let singapore: AppStoreCountry = "SG"
  public static let slovenia: AppStoreCountry = "SI"
  public static let slovakia: AppStoreCountry = "SK"
  public static let sierraLeone: AppStoreCountry = "SL"
  public static let senegal: AppStoreCountry = "SN"
  public static let suriname: AppStoreCountry = "SR"
  public static let serbia: AppStoreCountry = "SRB"
  public static let saoTomeAndPrincipe: AppStoreCountry = "ST"
  public static let elSalvador: AppStoreCountry = "SV"
  public static let swaziland: AppStoreCountry = "SZ"
  public static let turksAndCaicosIslands: AppStoreCountry = "TC"
  public static let chad: AppStoreCountry = "TD"
  public static let thailand: AppStoreCountry = "TH"
  public static let tajikistan: AppStoreCountry = "TJ"
  public static let turkmenistan: AppStoreCountry = "TM"
  public static let tunisia: AppStoreCountry = "TN"
  public static let tonga: AppStoreCountry = "TON"
  public static let turkey: AppStoreCountry = "TR"
  public static let trinidadAndTobago: AppStoreCountry = "TT"
  public static let taiwan: AppStoreCountry = "TW"
  public static let tanzania: AppStoreCountry = "TZ"
  public static let ukraine: AppStoreCountry = "UA"
  public static let uganda: AppStoreCountry = "UG"
  public static let unitedStates: AppStoreCountry = "US"
  public static let uruguay: AppStoreCountry = "UY"
  public static let uzbekistan: AppStoreCountry = "UZ"
  public static let stVincentAndTheGrenadines: AppStoreCountry = "VC"
  public static let venezuela: AppStoreCountry = "VE"
  public static let britishVirginIslands: AppStoreCountry = "VG"
  public static let vietnam: AppStoreCountry = "VN"
  public static let vanuatu: AppStoreCountry = "VUT"
  public static let kosovo: AppStoreCountry = "XKS"
  public static let yemen: AppStoreCountry = "YE"
  public static let southAfrica: AppStoreCountry = "ZA"
  public static let zambia: AppStoreCountry = "ZMB"
  public static let zimbabwe: AppStoreCountry = "ZW"
}

extension AppStoreCountry: Equatable { }
/// Adds ability to equate instances of `AppStoreCountry` to each other.
/// - Parameters:
///   - lhs: First instance of`AppStoreCountry`
///   - rhs: Second instance of`AppStoreCountry`
/// - Returns: `true` if instances are equal. Otherwise, `false`.
public func == (lhs: AppStoreCountry, rhs: AppStoreCountry) -> Bool
{
    return lhs.code?.uppercased() == rhs.code?.uppercased()
}

extension AppStoreCountry: ExpressibleByStringLiteral
{
    /// Allows for `AppStoreCountry` to be initialized by a string literal.
    /// - Parameter value: An instance of `AppStoreCountry` that can be represented as a `String`.
    public init(stringLiteral value: StringLiteralType)
    {
      self.init(code: value)
    }
}

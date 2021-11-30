//
//  Timezone+Extensions.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import Foundation

extension TimeZone {
    public static var utc: TimeZone { return TimeZone(identifier: "UTC")! }
    
    public var cityName: String {
        let countryCityName = self.identifier
        return (countryCityName.components(separatedBy: "/").last ?? "").replacingOccurrences(of: "_", with: " ")
    }
    
    public static var knownTimeZones: [TimeZone] {
        let identifiers = TimeZone.knownTimeZoneIdentifiers.filter({ $0 != "Asia/Katmandu" })
        return identifiers.compactMap({ TimeZone(identifier: $0) }).sorted(by: { zone1, zone2 in
            let seconds1 = zone1.secondsFromGMT()
            let seconds2 = zone2.secondsFromGMT()
            if seconds1 == seconds2 {
                return zone1.cityName < zone2.cityName
            }
            return zone1.secondsFromGMT() < zone2.secondsFromGMT()
        })
    }
    
    public var shortDescription: String { // GMT+1:30
        let plusDelimeter = "+"
        let minusDelimeter = "-"
        let timeDelimeter = ":"
        
        let abbreviation = self.abbreviation()
        let timeZoneTimeValue: String
        let delimeter: String
        
        var finalAbbreviation: String
        var timeString: String
        
        if let separated = abbreviation?.components(separatedBy: plusDelimeter), separated.count != 1 {
            finalAbbreviation = separated.first ?? ""
            timeZoneTimeValue = separated.last ?? ""
            delimeter = plusDelimeter
        } else if let separated = abbreviation?.components(separatedBy: minusDelimeter), separated.count != 1 {
            finalAbbreviation = separated.first ?? ""
            timeZoneTimeValue = separated.last ?? ""
            delimeter = minusDelimeter
        } else {
            finalAbbreviation = "\(abbreviation ?? "") +0"
            return finalAbbreviation
        }
        
        let timeDelimeted = timeZoneTimeValue.components(separatedBy: timeDelimeter)
        var hours: String
        var minutes: String? = nil
        
        if timeDelimeted.count == 1 {
            hours = timeDelimeted.first ?? ""
        } else {
            hours = timeDelimeted.first ?? ""
            minutes = timeDelimeted.last ?? ""
        }
        if let minuteValue = minutes {
            timeString = " \(delimeter)\(hours):\(minuteValue)"
        } else {
            timeString = " \(delimeter)\(hours)"
        }
        
        return finalAbbreviation+timeString
    }
    
    public var fullDescription: String { // GMT+01:30 City
        
        let plusDelimeter = "+"
        let minusDelimeter = "-"
        let timeDelimeter = ":"
        
        let abbreviation = self.abbreviation()
        let timeZoneTimeValue: String
        let delimeter: String
        
        var finalAbbreviation: String
        var timeString: String
        var city: String
        
        if let separated = abbreviation?.components(separatedBy: plusDelimeter), separated.count != 1 {
            finalAbbreviation = separated.first ?? ""
            timeZoneTimeValue = separated.last ?? ""
            delimeter = plusDelimeter
        } else if let separated = abbreviation?.components(separatedBy: minusDelimeter), separated.count != 1 {
            finalAbbreviation = separated.first ?? ""
            timeZoneTimeValue = separated.last ?? ""
            delimeter = minusDelimeter
        } else {
            finalAbbreviation = abbreviation ?? ""
            let countryCityName = self.identifier
            city = (countryCityName.components(separatedBy: "/").last ?? "").replacingOccurrences(of: "_", with: " ")
            return "(\(finalAbbreviation) + 00:00) \(city)"
        }
        
        let timeDelimeted = timeZoneTimeValue.components(separatedBy: timeDelimeter)
        var hours: String
        var minutes: String
        
        if timeDelimeted.count == 1 {
            hours = timeDelimeted.first ?? ""
            minutes = "00"
        } else {
            hours = timeDelimeted.first ?? ""
            minutes = timeDelimeted.last ?? ""
        }
        
        if hours.count == 1 {
            hours = "0" + hours
        }
        
        timeString = delimeter + "\(hours):\(minutes)"
        return "(\(finalAbbreviation)\(timeString)) \(self.cityName)"
    }
}

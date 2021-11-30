//
//  Date+Extensions.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//
import Foundation

extension Date {
    public func convert(from initTimeZone: TimeZone, to targetTimeZone: TimeZone) -> Date {
        let delta = TimeInterval(initTimeZone.secondsFromGMT() - targetTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }
}



// MARK: - Date comparition
extension Date {
    public func equal(to date: Date) -> Bool {
        return self.comparable().compare(date.comparable()) == .orderedSame
    }
    
    public func less(then date: Date) -> Bool {
        return self.comparable().compare(date.comparable()) == .orderedAscending
    }
    
    public func greater(then date: Date) -> Bool {
        return self.comparable().compare(date.comparable()) == .orderedDescending
    }
    
    public var milleseconds: Int64 {
        return Int64(self.timeIntervalSince1970)*1000
    }
}

extension Date {
    public var yearsFromNow:   Int { return Calendar.current.dateComponents([.year],       from: self, to: Date()).year        ?? 0 }
    public var monthsFromNow:  Int { return Calendar.current.dateComponents([.month],      from: self, to: Date()).month       ?? 0 }
    public var weeksFromNow:   Int { return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear  ?? 0 }
    public var daysFromNow:    Int { return Calendar.current.dateComponents([.day],        from: self, to: Date()).day         ?? 0 }
    public var hoursFromNow:   Int { return Calendar.current.dateComponents([.hour],       from: self, to: Date()).hour        ?? 0 }
    public var minutesFromNow: Int { return Calendar.current.dateComponents([.minute],     from: self, to: Date()).minute      ?? 0 }
    public var secondsFromNow: Int { return Calendar.current.dateComponents([.second],     from: self, to: Date()).second      ?? 0 }
    
    public var  relativeTime: String {
        
        if yearsFromNow   > 0 { return "\(yearsFromNow) year"    + (yearsFromNow    > 1 ? "s" : "") }
        if monthsFromNow  > 0 { return "\(monthsFromNow) month"  + (monthsFromNow   > 1 ? "s" : "") }
        if weeksFromNow   > 0 { return "\(weeksFromNow) week"    + (weeksFromNow    > 1 ? "s" : "") }
        if daysFromNow    > 0 { return daysFromNow == 1 ? "Yesterday" : "\(daysFromNow) days" }
        //        if daysFromNow    > 0 { return daysFromNow == 1 ? "1d" : "\(daysFromNow)d" }
        if hoursFromNow   > 0 { return "\(hoursFromNow) hour"     + (hoursFromNow   > 1 ? "s" : "") }
        //        if hoursFromNow   > 0 { return "\(hoursFromNow)h" }
        if minutesFromNow > 0 { return "\(minutesFromNow) minute" + (minutesFromNow > 1 ? "s" : "") }
        //        if minutesFromNow > 0 { return "\(minutesFromNow)m" }
        if secondsFromNow > 0 { return secondsFromNow < 15 ? "Just now" : "\(secondsFromNow) second" + (secondsFromNow > 1 ? "s" : "") }
        
        if secondsFromNow > 0 { return "\(secondsFromNow)s" }
        return "1s"
    }
}

extension Date {
    public func getLast6Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)
    }
    
    public func getLast3Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -3, to: self)
    }
    
    public func getYesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    public func getLast7Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }
    public func getLast30Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }
    
    public func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    // This Month Start
    public func getThisMonthStart() -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        //        components.hour = 0
        //        components.minute = 0
        return Calendar.current.date(from: components)!
    }
    
    public func getThisMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    
    
    //Last Month Start
    public func getLastMonthStart() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    //Last Month End
    public func getLastMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    
    public var startOfWeek: Date? {
        
        var calendar = Calendar.current
        calendar.timeZone = .utc
        
        let newDate: Date
        if calendar.firstWeekday == 1, calendar.component(.weekday, from: self) == 1 {
            newDate = calendar.date(byAdding: .day, value: -1, to: self)!
        } else {
            newDate = self
        }
        
        var first = calendar.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: newDate))!
        
        var components = calendar.dateComponents([.year, .weekOfYear], from: newDate)
        components.weekday = 2
        first = calendar.date(from: components)!
        first = calendar.startOfDay(for: first)
        return first
    }
    
    
    
    public func getThisWeekStart() -> Date? {
        
        let components = Calendar.current.dateComponents([.year, .weekOfYear, .weekday], from: self) as NSDateComponents
        components.weekday = 7
        components.weekday -= 7
        
        return Calendar.current.date(from: components as DateComponents)!
        
        
    }
    
    public func getThisWeekEnd() -> Date? {
        
        var components = Calendar.current.dateComponents([.year, .weekOfYear], from: self)
        components.weekday = 7
        return Calendar.current.date(from: components)!
        
    }
}


extension Date {
    public enum DateInPeriod {
        case none
        case begin
        case middle(weekday: Int)
        case end
    }
    
    public func comparable(components: Set<Calendar.Component> = [.year, .month, .day]) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(components, from: self)
        return calendar.date(from: dateComponents)!
    }
}

extension Date {
    public func dateSuffix() -> String {
        let day = Calendar.current.component(.day, from: self)
        
        guard day >= 1, day <= 31 else {
            return ""
        }
        if day >= 11, day <= 13 {
            return "th"
        }
        switch day % 10 {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
    
    static public func daysBetween(start: Date, end: Date) -> [Date]? {
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        let date1Components = calendar.dateComponents([.year, .month, .day], from: date1)
        var date2Components = calendar.dateComponents([.year, .month, .day], from: date2)
        
        guard date1Components != date2Components else {
            date2Components.hour = 23
            date2Components.minute = 59
            date2Components.second = 59
            let resultingDate = date2Components.date ?? end
            return [resultingDate]
        }
        
        guard start < end else { return nil }
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let daysAmount = components.day ?? 0
        
        var result = [ start ]
        
        guard daysAmount > 1 else {
            return result
        }
        
        for index in 1...(daysAmount - 1) {
            let prevDay = result[index - 1]
            guard let newDay = calendar.date(byAdding: .day, value: 1, to: prevDay) else {
                continue
            }
            result.append(newDay)
        }
        return result
    }
}


extension Date {
    static let dateTransformationFormat = "YYYY MMMM dd HH mm"
    
    public func sameDate(from currentTimeZone: TimeZone, to selectedTimeZone: TimeZone) -> Date? {
        var originalCalendar = Calendar.init(identifier: .gregorian)
        originalCalendar.timeZone = currentTimeZone
        
        let originalFormatter = DateFormatter()
        originalFormatter.timeZone = currentTimeZone
        originalFormatter.dateFormat = Date.dateTransformationFormat
        
        let initialString = originalFormatter.string(from: self)
        
        
        let targetFormatter = DateFormatter()
        targetFormatter.timeZone = selectedTimeZone
        targetFormatter.dateFormat = Date.dateTransformationFormat
        
        return targetFormatter.date(from: initialString)
    }
}

extension Date {
    public init(milliseconds: Int) {
        self.init(timeIntervalSince1970:TimeInterval(milliseconds / 1000 ))
    }
}


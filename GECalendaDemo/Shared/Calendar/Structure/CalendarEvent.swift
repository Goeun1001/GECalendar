//
//  CalendarEvent.swift
//  GECalendaDemo (iOS)
//
//  Created by GoEun Jeong on 2021/08/21.
//

import Foundation

/// Type to store a speficic data point a given date. Date will be striped of hour/minute/second components.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct CalendarEvent<T:Hashable> {
    public var date:Date
    public var data:T
    
    public var calendar:Calendar
    
    public init(calendar:Calendar = Calendar.current, date:Date, data:T) {
        self.calendar = calendar
        self.data = data
        self.date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    }
    
    public init(calendar:Calendar = Calendar.current, dateString:String, dateFormat:String = "MM/dd/yyyy", data:T) {
        self.calendar = calendar
        self.data = data
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from:dateString)!
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.date = calendar.date(from:components)!
    }
}

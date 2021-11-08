//
//  File.swift
//  
//
//  Created by GoEun Jeong on 2021/08/25.
//

import SwiftUI

#if os(iOS) || os(OSX)

/// Header's position
public enum HeaderType {
    /// Text on the left, two buttons on the right
    case leading
    
    /// Text in the center, one button on the left, one button on the right
    case center
    
    /// Text on the right, two buttons on the left
    case trailing
}

/// A Model of Events appearing on the calendar
public struct Event: Hashable {
    /// Event date
    var date: Date
    
    /// Event title
    var title: String
    
    /// Event display color
    var color: Color
    
    /// Create an Event with date, title, color
    /// - Parameters:
    ///   - date: Event date
    ///   - title: Event title
    ///   - color: Event display color
    public init(date: Date, title: String, color: Color) {
        self.date = date
        self.title = title
        self.color = color
    }
}

/// Shape of events in calendar
public enum EventType {
    /// Small circles in the event color under the date
    case circle
    
    /// Fill in the space behind the date with a rounded rectangle that is the color of the event.
    case fill
    
    /// Shows a line with the title of the event under the date.
    case line
    
    /// Change the text color of the date, which is an event.
    case text
}

public enum ShapeType {
    /// Circle behind the date
    case circle
    
    /// RoundedRectangle behind the date
    case roundedRectangle(cornerRadius: CGFloat)
    
    /// Rectangle behind the date
    case rectangle
}

/// Customize the calendar.
@available(iOS 14, macOS 11, *)
public class Appearance: ObservableObject {
    /// Date Array with at most one event per date
    @Published public var singleEvents: [Date] = []
    /// Event color for single event
    @Published public var singleEventColor: Color = Color.gray
    /// Whether to show multiple events per date
    ///
    /// If `true`, ``multipleEvents`` are displayed, if `false`, ``singleEvents`` are displayed in the calendar.
    @Published public var isMultipleEvents: Bool = false
    /// Event array showing multiple events per date
    @Published public var multipleEvents: [Event] = []
    
    /// Event display type
    @Published public var eventType: EventType = .line
    
    /// Selected date display type
    @Published public var selectedDateShape: ShapeType? = .circle
    /// Default date display type
    ///
    /// You can empty or fill in the background behind the default date.
    @Published public var defaultDateShape: ShapeType? = nil
    
    /// Max width of date background in macOS
    @Published public var osxMaxWidth: CGFloat? = nil // macOS의 날짜 최대 크기
    /// Max height of date background in macOS
    @Published public var osxMaxHeight: CGFloat? = nil // macOS의 날짜 최대 크기
    
    /// Whether to display headers
    @Published public var isHeader: Bool = true
    /// Whether to display a button to go back to today
    @Published public var isTodayButton: Bool = true
    
    
    /// Selected date color
    @Published public var selectedDateColor: Color = Color.blue
    /// Today's date color
    @Published public var todayColor: Color = Color.blue.opacity(0.2)
    /// Unselected date color
    @Published public var defaultDateColor: Color = Color.clear
    /// Header text color
    @Published public var headerTextColor: Color = Color.white
    /// Week text color
    @Published public var weekTextColor: Color = Color.white
    /// Day text color
    @Published public var dayTextColor: Color = Color.white
    /// Different lunar days transparency
    @Published public var extraDayOpacity: Double = 0.2
    
    /// Header font
    @Published public var headerFont: Font = .title // 헤더 폰트
    /// Week text font
    @Published public var weekTextFont: Font = .body // 주 폰트
    /// Day text font
    @Published public var dayTextFont: Font = .body // 바디 폰트
    
    /// Header left button image
    @Published public var headerLeftButtonImage: Image = Image(systemName: "chevron.left")
    /// Header today button image
    @Published public var headerTodayButtonImage: Image = Image(systemName: "dot.square")
    /// Header right button image
    @Published public var headerRightButtonImage: Image = Image(systemName: "chevron.right")
    /// Header position type
    @Published public var headerType: HeaderType = .center
    
    /// Locale of header, week text, day
    @Published public var locale: Locale = Locale(identifier: "ko-KR") // locale
    /// Header text dateformatter
    @Published public var headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    /// Week text dateformatter
    @Published public var weekTextDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        return formatter
    }()
    /// Day text dateformatter
    @Published public var dayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    // MARK: - Initializer

#if os(iOS)
    /// Create an appearance with settings to customize the calendar
    ///
    /// - Parameters:
    ///   - singleEvents: Date Array with at most one event per date
    ///   - singleEventColor: Event color for single event
    ///   - isMultipleEvents: Whether to show multiple events per date
    ///   - multipleEvents: Event array showing multiple events per date
    ///   - eventType: Event display type
    ///   - selectedDateShape: Selected date display type
    ///   - defaultDateShape: Default date display type
    ///   - isHeader: Whether to display headers
    ///   - isTodayButton: Whether to display a button to go back to today
    ///   - selectedDateColor: Selected date color
    ///   - todayColor: Today's date color
    ///   - defaultDateColor: Unselected date color
    ///   - headerTextColor: Header text color
    ///   - weekTextColor: Week text color
    ///   - dayTextColor: Day text color
    ///   - extraDayOpacity: Different lunar days transparency
    ///   - headerFont: Header font
    ///   - weekTextFont: Week text font
    ///   - dayTextFont: Day text font
    ///   - headerLeftButtonImage: Header left button image
    ///   - headerTodayButtonImage: Header today button image
    ///   - headerRightButtonImage: Header right button image
    ///   - headerType: Header position type
    ///   - locale: Locale of header, week text, day
    ///   - headerDateFormatter: Header text dateformatter
    ///   - weekTextDateFormatter: Week text dateformatter
    ///   - dayDateFormatter: Day text dateformatter
    public init(singleEvents: [Date] = [],
                singleEventColor: Color = Color.gray,
                isMultipleEvents: Bool = false,
                multipleEvents: [Event] = [],
                eventType: EventType = .line,
                selectedDateShape: ShapeType? = .circle,
                defaultDateShape: ShapeType? = nil,
                isHeader: Bool = true,
                isTodayButton: Bool = true,
                selectedDateColor: Color = Color.blue,
                todayColor: Color = Color.blue.opacity(0.2),
                defaultDateColor: Color = Color.clear,
                headerTextColor: Color = Color.black,
                weekTextColor: Color = Color.black,
                dayTextColor: Color = Color.black,
                extraDayOpacity: Double = 0.2,
                headerFont: Font = .title,
                weekTextFont: Font = .body,
                dayTextFont: Font = .body,
                headerLeftButtonImage: Image = Image(systemName: "chevron.left"),
                headerTodayButtonImage: Image = Image(systemName: "dot.square"),
                headerRightButtonImage: Image = Image(systemName: "chevron.right"),
                headerType: HeaderType = .center,
                locale: Locale = Locale(identifier: "ko-KR"),
                headerDateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM"
                    return formatter
                }(),
                weekTextDateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEEE"
                    return formatter
                }(),
                dayDateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d"
                    return formatter
                }()
    ) {
        self.singleEvents = singleEvents
        self.eventType = eventType
        self.singleEventColor = singleEventColor
        self.selectedDateShape = selectedDateShape
        self.defaultDateShape = defaultDateShape
        self.multipleEvents = multipleEvents
        self.isHeader = isHeader
        self.isTodayButton = isTodayButton
        self.isMultipleEvents = isMultipleEvents
        self.selectedDateColor = selectedDateColor
        self.todayColor = todayColor
        self.defaultDateColor = defaultDateColor
        self.headerTextColor = headerTextColor
        self.weekTextColor = weekTextColor
        self.dayTextColor = dayTextColor
        self.extraDayOpacity = extraDayOpacity
        self.headerFont = headerFont
        self.weekTextFont = weekTextFont
        self.dayTextFont = dayTextFont
        self.headerLeftButtonImage = headerLeftButtonImage
        self.headerTodayButtonImage = headerTodayButtonImage
        self.headerRightButtonImage = headerRightButtonImage
        self.headerType = headerType
        self.locale = locale
        self.headerDateFormatter = headerDateFormatter
        self.weekTextDateFormatter = weekTextDateFormatter
        self.dayDateFormatter = dayDateFormatter
        
        self.headerDateFormatter.locale = self.locale
        self.weekTextDateFormatter.locale = self.locale
        self.dayDateFormatter.locale = self.locale
    }
    #endif
    
#if os(OSX)
    /// Create an appearance with settings to customize the calendar
    ///
    /// - Parameters:
    ///   - singleEvents: Date Array with at most one event per date
    ///   - singleEventColor: Event color for single event
    ///   - isMultipleEvents: Whether to show multiple events per date
    ///   - multipleEvents: Event array showing multiple events per date
    ///   - eventType: Event display type
    ///   - selectedDateShape: Selected date display type
    ///   - defaultDateShape: Default date display type
    ///   - osxMaxWidth : Max width of date background in macOS
    ///   - osxMaxHeight : Max height of date background in macOS
    ///   - isHeader: Whether to display headers
    ///   - isTodayButton: Whether to display a button to go back to today
    ///   - selectedDateColor: Selected date color
    ///   - todayColor: Today's date color
    ///   - defaultDateColor: Unselected date color
    ///   - headerTextColor: Header text color
    ///   - weekTextColor: Week text color
    ///   - dayTextColor: Day text color
    ///   - extraDayOpacity: Different lunar days transparency
    ///   - headerFont: Header font
    ///   - weekTextFont: Week text font
    ///   - dayTextFont: Day text font
    ///   - headerLeftButtonImage: Header left button image
    ///   - headerTodayButtonImage: Header today button image
    ///   - headerRightButtonImage: Header right button image
    ///   - headerType: Header position type
    ///   - locale: Locale of header, week text, day
    ///   - headerDateFormatter: Header text dateformatter
    ///   - weekTextDateFormatter: Week text dateformatter
    ///   - dayDateFormatter: Day text dateformatter
    public init(singleEvents: [Date] = [],
                singleEventColor: Color = Color.gray,
                isMultipleEvents: Bool = false,
                multipleEvents: [Event] = [],
                eventType: EventType = .line,
                selectedDateShape: ShapeType? = .circle,
                defaultDateShape: ShapeType? = nil,
                osxMaxWidth: CGFloat? = 30,
                osxMaxHeight: CGFloat? = 30,
                isHeader: Bool = true,
                isTodayButton: Bool = true,
                selectedDateColor: Color = Color.blue,
                todayColor: Color = Color.blue.opacity(0.2),
                defaultDateColor: Color = Color.clear,
                headerTextColor: Color = Color.white,
                weekTextColor: Color = Color.white,
                dayTextColor: Color = Color.white,
                extraDayOpacity: Double = 0.2,
                headerFont: Font = .title,
                weekTextFont: Font = .body,
                dayTextFont: Font = .body,
                headerLeftButtonImage: Image = Image(systemName: "chevron.left"),
                headerTodayButtonImage: Image = Image(systemName: "dot.square"),
                headerRightButtonImage: Image = Image(systemName: "chevron.right"),
                headerType: HeaderType = .center,
                locale: Locale = Locale(identifier: "ko-KR"),
                headerDateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM"
                    return formatter
                }(),
                weekTextDateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEEE"
                    return formatter
                }(),
                dayDateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d"
                    return formatter
                }()
    ) {
        self.singleEvents = singleEvents
        self.eventType = eventType
        self.singleEventColor = singleEventColor
        self.selectedDateShape = selectedDateShape
        self.defaultDateShape = defaultDateShape
        self.multipleEvents = multipleEvents
        self.osxMaxWidth = osxMaxWidth
        self.osxMaxHeight = osxMaxHeight
        self.isHeader = isHeader
        self.isTodayButton = isTodayButton
        self.isMultipleEvents = isMultipleEvents
        self.selectedDateColor = selectedDateColor
        self.todayColor = todayColor
        self.defaultDateColor = defaultDateColor
        self.headerTextColor = headerTextColor
        self.weekTextColor = weekTextColor
        self.dayTextColor = dayTextColor
        self.extraDayOpacity = extraDayOpacity
        self.headerFont = headerFont
        self.weekTextFont = weekTextFont
        self.dayTextFont = dayTextFont
        self.headerLeftButtonImage = headerLeftButtonImage
        self.headerTodayButtonImage = headerTodayButtonImage
        self.headerRightButtonImage = headerRightButtonImage
        self.headerType = headerType
        self.locale = locale
        self.headerDateFormatter = headerDateFormatter
        self.weekTextDateFormatter = weekTextDateFormatter
        self.dayDateFormatter = dayDateFormatter
        
        self.headerDateFormatter.locale = self.locale
        self.weekTextDateFormatter.locale = self.locale
        self.dayDateFormatter.locale = self.locale
    }
    #endif
}

#endif

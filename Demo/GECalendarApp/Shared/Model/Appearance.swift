//
//  Appearance.swift
//  GECalendaDemo
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI

public enum HeaderType {
    case leading
    case center
    case trailing
}

public struct Event: Hashable {
    var date: Date
    var title: String
    var color: Color
}

public enum EventType {
    case circle
    case fill
    case line
    case text
}

public enum ShapeType {
    case circle
    case roundedRectangle(cornerRadius: CGFloat)
    case rectangle
}

public class Appearance: ObservableObject {
    // MARK: - Event
    @Published var events: [Date] = [] // 이벤트 배열
    @Published var eventType: EventType = .line // 이벤트 표시 타입
    @Published var eventColor: Color = Color.gray // 이벤트 표시 타입
    
    @Published var selectionShape: ShapeType? = .circle  // 선택된 날짜 표시 타입
    @Published var defaultShape: ShapeType? = nil  // 기본 날짜 표시 타입
    
    @Published var multipleEvents: [Event] = [] // 여러 이벤트 설명 배열
    
    // MARK: - Size
    @Published var osxMaxWidth: CGFloat? = nil // macOS의 날짜 최대 크기
    @Published var osxMaxHeight: CGFloat? = nil // macOS의 날짜 최대 크기
    
    // MARK: - Bool
    @Published var isHeader: Bool = true // 헤더 표시할 건지
    @Published var isTodayButton: Bool = true // 오늘로 돌아가는 버튼 표시할건지
    @Published var isMultipleEvents: Bool = false // 이벤트가 여러 개 표시될건지
    
    // MARK: - Color
    @Published var selectionColor: Color = Color.blue  // 선택된 날짜 색
    @Published var todayColor: Color = Color.blue.opacity(0.2) // 오늘의 날짜 색
    @Published var defaultColor: Color = Color.clear // 선택되지 않은 날짜 색
    @Published var headerColor: Color = Color.white // 헤더 컬러
    @Published var weekDayColor: Color = Color.white // 주 컬러
    @Published var dayColor: Color = Color.white // 일 색상
    @Published var extraDayOpacity: Double = 0.2 // 다른 달의 일 투명도
    
    // MARK: - Font
    @Published var headerFont: Font = .title // 헤더 폰트
    @Published var weekDayFont: Font = .body // 주 폰트
    @Published var dayFont: Font = .body // 바디 폰트
    
    // MARK: - Header
    @Published var headerLeftButtonImage: Image = Image(systemName: "chevron.left") // 헤더 왼쪽 버튼 이미지
    @Published var headerTodayButtonImage: Image = Image(systemName: "dot.square") // 헤더 투데이 버튼 이미지
    @Published var headerRightButtonImage: Image = Image(systemName: "chevron.right") // 헤더 왼쪽 버튼 이미지
    @Published var headerType: HeaderType = .center
    
    // MARK:-  Local & DateFormatter
    @Published var locale: Locale = Locale(identifier: "ko-KR") // locale
    @Published var headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }() // 헤더 날짜 포매터
    @Published var weekDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        return formatter
    }() // 주 날짜 포매터
    @Published var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }() // 일 날짜 포매터
    
    // MARK: - Initializer

    #if os(iOS)
    public init(events: [Date] = [],
                eventType: EventType = .line, // 이벤트 표시 타입,
                eventColor: Color = Color.gray, // 이벤트 표시 타입
                selectionShape: ShapeType? = .circle,  // 선택된 날짜 표시 타입
                defaultShape: ShapeType? = nil,
                multipleEvents: [Event] = [], // 여러 이벤트 설명 배열
                isHeader: Bool = true, // 헤더 표시할 건지
                isTodayButton: Bool = true, // 오늘로 돌아가는 버튼 표시할건지
                isMultipleEvents: Bool = false, // 이벤트가 여러 개 표시될건지
                selectionColor: Color = Color.blue,  // 선택된 날짜 색
                todayColor: Color = Color.blue.opacity(0.2), // 오늘의 날짜 색
                defaultColor: Color = Color.clear, // 선택되지 않은 날짜 색
                headerColor: Color = Color.black, // 헤더 컬러
                weekDayColor: Color = Color.black, // 주 컬러
                dayColor: Color = Color.black, // 일 색상
                extraDayOpacity: Double = 0.2, // 다른 달의 일 투명도
                headerFont: Font = .title, // 헤더 폰트
                weekDayFont: Font = .body, // 주 폰트
                dayFont: Font = .body, // 바디 폰트
                headerLeftButtonImage: Image = Image(systemName: "chevron.left"), // 헤더 왼쪽 버튼 이미지
                headerTodayButtonImage: Image = Image(systemName: "dot.square"), // 헤더 투데이 버튼 이미지
                headerRightButtonImage: Image = Image(systemName: "chevron.right"), // 헤더 왼쪽 버튼 이미지
                headerType: HeaderType = .center,
                locale: Locale = Locale(identifier: "ko-KR"), // locale
                headerDateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM"
                    return formatter
                }(), // 헤더 날짜 포매터
                weekDayFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEEE"
                    return formatter
                }(), // 주 날짜 포매터
                dayFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d"
                    return formatter
                }()
    ) {
        self.events = events
        self.eventType = eventType
        self.eventColor = eventColor
        self.selectionShape = selectionShape
        self.defaultShape = defaultShape
        self.multipleEvents = multipleEvents
        self.isHeader = isHeader
        self.isTodayButton = isTodayButton
        self.isMultipleEvents = isMultipleEvents
        self.selectionColor = selectionColor
        self.todayColor = todayColor
        self.defaultColor = defaultColor
        self.headerColor = headerColor
        self.weekDayColor = weekDayColor
        self.dayColor = dayColor
        self.extraDayOpacity = extraDayOpacity
        self.headerFont = headerFont
        self.weekDayFont = weekDayFont
        self.dayFont = dayFont
        self.headerLeftButtonImage = headerLeftButtonImage
        self.headerTodayButtonImage = headerTodayButtonImage
        self.headerRightButtonImage = headerRightButtonImage
        self.headerType = headerType
        self.locale = locale
        self.headerDateFormatter = headerDateFormatter
        self.weekDayFormatter = weekDayFormatter
        self.dayFormatter = dayFormatter
        
        self.headerDateFormatter.locale = self.locale
        self.weekDayFormatter.locale = self.locale
        self.dayFormatter.locale = self.locale
    }
    #endif
    
    #if os(OSX)
    public init(events: [Date] = [],
                eventType: EventType = .line, // 이벤트 표시 타입,
                eventColor: Color = Color.gray, // 이벤트 표시 타입
                selectionShape: ShapeType? = .circle,  // 선택된 날짜 표시 타입
                defaultShape: ShapeType? = nil,
                multipleEvents: [Event] = [], // 여러 이벤트 설명 배열
                osxMaxWidth: CGFloat? = 30, // macOS의 날짜 최대 크기
                osxMaxHeight: CGFloat? = 30, // macOS의 날짜 최대 크기
                isHeader: Bool = true, // 헤더 표시할 건지
                isTodayButton: Bool = true, // 오늘로 돌아가는 버튼 표시할건지
                isMultipleEvents: Bool = false, // 이벤트가 여러 개 표시될건지
                selectionColor: Color = Color.blue,  // 선택된 날짜 색
                todayColor: Color = Color.blue.opacity(0.2), // 오늘의 날짜 색
                defaultColor: Color = Color.clear, // 선택되지 않은 날짜 색
                headerColor: Color = Color.white, // 헤더 컬러
                weekDayColor: Color = Color.white, // 주 컬러
                dayColor: Color = Color.white, // 일 색상
                extraDayOpacity: Double = 0.2, // 다른 달의 일 투명도
                headerFont: Font = .title, // 헤더 폰트
                weekDayFont: Font = .body, // 주 폰트
                dayFont: Font = .body, // 바디 폰트
                headerLeftButtonImage: Image = Image(systemName: "chevron.left"), // 헤더 왼쪽 버튼 이미지
                headerTodayButtonImage: Image = Image(systemName: "dot.square"), // 헤더 투데이 버튼 이미지
                headerRightButtonImage: Image = Image(systemName: "chevron.right"), // 헤더 왼쪽 버튼 이미지
                headerType: HeaderType = .center,
                locale: Locale = Locale(identifier: "ko-KR"), // locale
                headerDateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM"
                    return formatter
                }(), // 헤더 날짜 포매터
                weekDayFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEEE"
                    return formatter
                }(), // 주 날짜 포매터
                dayFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d"
                    return formatter
                }()
    ) {
        self.events = events
        self.eventType = eventType
        self.eventColor = eventColor
        self.selectionShape = selectionShape
        self.defaultShape = defaultShape
        self.multipleEvents = multipleEvents
        self.osxMaxWidth = osxMaxWidth
        self.osxMaxHeight = osxMaxHeight
        self.isHeader = isHeader
        self.isTodayButton = isTodayButton
        self.isMultipleEvents = isMultipleEvents
        self.selectionColor = selectionColor
        self.todayColor = todayColor
        self.defaultColor = defaultColor
        self.headerColor = headerColor
        self.weekDayColor = weekDayColor
        self.dayColor = dayColor
        self.extraDayOpacity = extraDayOpacity
        self.headerFont = headerFont
        self.weekDayFont = weekDayFont
        self.dayFont = dayFont
        self.headerLeftButtonImage = headerLeftButtonImage
        self.headerTodayButtonImage = headerTodayButtonImage
        self.headerRightButtonImage = headerRightButtonImage
        self.headerType = headerType
        self.locale = locale
        self.headerDateFormatter = headerDateFormatter
        self.weekDayFormatter = weekDayFormatter
        self.dayFormatter = dayFormatter
        
        self.headerDateFormatter.locale = self.locale
        self.weekDayFormatter.locale = self.locale
        self.dayFormatter.locale = self.locale
    }
    #endif
}

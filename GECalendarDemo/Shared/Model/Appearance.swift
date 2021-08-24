//
//  Appearance.swift
//  GECalendaDemo
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI

enum EventType {
    case circle
    case fill
    case line
    case text
}

enum ShapeType {
    case circle
    case roundedRectangle(cornerRadius: CGFloat)
    case rectangle
}

public class Appearance: ObservableObject {
    // MARK: - Event
    @Published var events: [Date] = [Date(), Calendar.current.date(byAdding: .weekday, value: -1, to: Date())!, Calendar.current.date(byAdding: .weekday, value: +1, to: Date())!] // 이벤트 배열
    @Published var eventType: EventType = .circle // 이벤트 표시 타입
    @Published var eventColor: [Color]? = [Color.gray] // 이벤트 표시 타입
    
    @Published var selectionShape: ShapeType? = .circle  // 선택된 날짜 표시 타입
    
    // MARK: - Bool
    @Published var isHeader: Bool = true // 헤더 표시할 건지
    @Published var isTodayButton: Bool = true // 오늘로 돌아가는 버튼 표시할 건지
    
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
    
    // MARK: - Imagee
    @Published var headerLeftButtonImage: Image = Image(systemName: "chevron.left") // 헤더 왼쪽 버튼 이미지
    @Published var headerRightButtonImage: Image = Image(systemName: "chevron.right") // 헤더 왼쪽 버튼 이미지
    
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
    public init() {
        self.headerDateFormatter.locale = self.locale
        self.weekDayFormatter.locale = self.locale
        self.dayFormatter.locale = self.locale
    }
}

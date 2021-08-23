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
}

enum ShapeType {
    case circle
    case roundedRectangle
    case rectangle
}

class Appearance: ObservableObject {
    @Published var selectionColor: Color = Color.blue  // 선택된 날짜 색
    @Published var todayColor: Color = Color.blue.opacity(0.2) // 오늘의 날짜 색
    @Published var defaultColor: Color = Color.clear // 선택되지 않은 날짜 색
    @Published var events: [Date] = [Date]() // 이벤트 배열
    @Published var eventType: EventType = .fill // 이벤트 표시 타입
    @Published var today: Date? = Date() // 오늘 표시할 건지
    @Published var locale: Locale = Locale(identifier: "en-US") // locale
    @Published var titleFont: UIFont = UIFont.preferredFont(forTextStyle: .body) // 타이틀 폰트
    @Published var shapeType: ShapeType = .circle // 날짜 모양 타입
}

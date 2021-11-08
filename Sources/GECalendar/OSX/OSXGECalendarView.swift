//
//  File.swift
//  
//
//  Created by GoEun Jeong on 2021/08/25.
//

#if os(OSX)

import SwiftUI

/// Calendar showing events and selected date
@available(macOS 11, *)
public struct GECalendar: View {
    @Environment(\.calendar) var calendar
    private var quarter: DateInterval {
        calendar.dateInterval(of: .quarter, for: Date())!
    }
    @Binding private var selectedDate: Date?
    @Binding private var appearance: Appearance
    private let onChanged: (Date) -> ()
    
    /// Create an GECalendar with selectedDate, appearance, onChanged
    ///
    /// - Parameters:
    ///   - selectedDate: Selected date
    ///   - appearance: Appearance class
    ///   - onChanged: Behavior when the month changes
    public init(selectedDate: Binding<Date?>,
                appearance: Binding<Appearance>,
                onChanged: @escaping (Date) -> () = { _ in }) {
        self._selectedDate = selectedDate
        self._appearance = appearance
        self.onChanged = onChanged
    }
    
    public var body: some View {
        GeometryReader { geo in
            CalendarView(interval: self.quarter, onChanged: self.onChanged) { date in
                Button(action: {
                    self.selectedDate = date
                }, label: {
                    Text("00")
                        .hidden()
                        .padding(.vertical, geo.size.height / 15)
                        .padding(.horizontal, geo.size.width / 15)
                        
                        .background(
                            ZStack(alignment: .center) {
                                if calendar.isDateInToday(date) {
                                    appearance.todayColor
                                        .modifier(
                                            ShapeModifier(shape: appearance.selectedDateShape)
                                        )
                                        .frame(maxWidth: appearance.osxMaxWidth, maxHeight: appearance.osxMaxHeight)
                                }
                                
                                // mutiple events
                                if appearance.isMultipleEvents {
                                    if appearance.eventType == .fill && appearance.multipleEvents.contains(where: {
                                        calendar.isDate(date, inSameDayAs: $0.date)
                                    }) {
                                        appearance.multipleEvents.filter { calendar.isDate(date, inSameDayAs: $0.date) }.first!.color
                                    } else if appearance.eventType == .circle && appearance.multipleEvents.contains(where: {
                                        calendar.isDate(date, inSameDayAs: $0.date)
                                    }) {
                                        HStack {
                                            ForEach(appearance.multipleEvents.filter { calendar.isDate(date, inSameDayAs: $0.date) }, id: \.self) {
                                                event in
                                                Circle().frame(width: 10, height: 10)
                                                    .foregroundColor(event.color)
                                            }
                                            .offset(y: geo.size.height / 20)
                                        }
                                    } else if appearance.eventType == .line && appearance.multipleEvents.contains(where: {
                                        calendar.isDate(date, inSameDayAs: $0.date)
                                    }) {
                                        VStack {
                                            ForEach(appearance.multipleEvents.filter { calendar.isDate(date, inSameDayAs: $0.date) }, id: \.self) {
                                                event in
                                                RectangleView(title: event.title, color: event.color)
                                            }
                                            .offset(y: geo.size.height / 20)
                                        }
                                    }
                                    
                                } else {
                                    // single events
                                    if appearance.eventType == .fill && appearance.singleEvents.contains(where: {
                                        calendar.isDate(date, inSameDayAs: $0)
                                    }) {
                                        appearance.singleEventColor
                                    } else if appearance.eventType == .circle && appearance.singleEvents.contains(where: {
                                        calendar.isDate(date, inSameDayAs: $0)
                                    }) {
                                        Circle().frame(width: 10, height: 10)
                                            .foregroundColor(appearance.singleEventColor)
                                            .offset(y: geo.size.height / 20)
                                    } else if appearance.eventType == .line && appearance.singleEvents.contains(where: {
                                        calendar.isDate(date, inSameDayAs: $0)
                                    }) {
                                        HStack {
                                            Rectangle()
                                                .frame(width: geo.size.width / 20, height: 10)
                                                .offset(y: geo.size.height / 30)
                                        }
                                    }
                                }
                                
                                // common dates
                                if selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!) {
                                    appearance.selectedDateColor
                                        .modifier(
                                            ShapeModifier(shape: appearance.selectedDateShape)
                                        )
                                        .frame(maxWidth: appearance.osxMaxWidth, maxHeight: appearance.osxMaxHeight)
                                }  else {
                                    appearance.defaultDateColor
                                        .modifier(
                                            ShapeModifier(shape: appearance.selectedDateShape)
                                        )
                                        .frame(maxWidth: appearance.osxMaxWidth, maxHeight: appearance.osxMaxHeight)
                                }
                            }
                        )
                        
                        .cornerRadius(4)
                        .overlay(
                            Group {
                                if appearance.eventType == .text && appearance.singleEvents.contains(where: {
                                    calendar.isDate(date, inSameDayAs: $0)
                                }) {
                                    Text(String(self.calendar.component(.day, from: date)))
                                        .foregroundColor(appearance.singleEventColor)
                                } else { // Event: None
                                    Text(String(self.calendar.component(.day, from: date)))
                                        .foregroundColor(appearance.dayTextColor)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                }).buttonStyle(PlainButtonStyle())
            }
            .environmentObject(appearance)
        }
    }
}

struct RectangleView: View {
    let title: String
    let color: Color
    let rounded = false
    let cornerRadius: CGFloat = 10.0
    let trailing = true
    
    var body: some View {
        if trailing {
            HStack {
                Spacer()
                Text(title)
                    .lineLimit(1)
                    .font(.caption)
                    .padding(.trailing, 5)
            }
            .padding(.vertical, 3)
            .background(
                ZStack {
                    if rounded {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .foregroundColor(color)
                    } else {
                        Rectangle()
                            .foregroundColor(color)
                    }
                }
            )
        } else {
            HStack {
                Text(title)
                    .lineLimit(1)
                    .font(.caption)
                    .padding(.leading, 5)
                Spacer()
            }
            .padding(.vertical, 3)
            .background(
                ZStack {
                    if rounded {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .foregroundColor(color)
                    } else {
                        Rectangle()
                            .foregroundColor(color)
                    }
                }
            )
        }
    }
}

#endif

//
//  File.swift
//  
//
//  Created by GoEun Jeong on 2021/08/25.
//

#if os(OSX)

import SwiftUI

@available(macOS 11, *)
public struct GECalendar: View {
    @Environment(\.calendar) var calendar
    private var quarter: DateInterval {
        calendar.dateInterval(of: .quarter, for: Date())!
    }
    @Binding private var selectedDate: Date?
    @ObservedObject var appearance: Appearance
    
    public init(selectedDate: Binding<Date?>,
                appearance: Appearance) {
        self._selectedDate = selectedDate
        self.appearance = appearance
    }
    
    public var body: some View {
        GeometryReader { geo in
            CalendarView(interval: self.quarter) { date in
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
                                            ShapeModifier(shape: appearance.selectionShape)
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
                                    if appearance.eventType == .fill && appearance.events.contains(where: {
                                        calendar.isDate(date, inSameDayAs: $0)
                                    }) {
                                        appearance.eventColor
                                    } else if appearance.eventType == .circle && appearance.events.contains(where: {
                                        calendar.isDate(date, inSameDayAs: $0)
                                    }) {
                                        Circle().frame(width: 10, height: 10)
                                            .foregroundColor(appearance.eventColor)
                                            .offset(y: geo.size.height / 20)
                                    } else if appearance.eventType == .line && appearance.events.contains(where: {
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
                                    appearance.selectionColor
                                        .modifier(
                                            ShapeModifier(shape: appearance.selectionShape)
                                        )
                                        .frame(maxWidth: appearance.osxMaxWidth, maxHeight: appearance.osxMaxHeight)
                                }  else {
                                    appearance.defaultColor
                                        .modifier(
                                            ShapeModifier(shape: appearance.selectionShape)
                                        )
                                        .frame(maxWidth: appearance.osxMaxWidth, maxHeight: appearance.osxMaxHeight)
                                }
                            }
                        )
                        
                        .cornerRadius(4)
                        .overlay(
                            Group {
                                if appearance.eventType == .text && appearance.events.contains(where: {
                                    calendar.isDate(date, inSameDayAs: $0)
                                }) {
                                    Text(String(self.calendar.component(.day, from: date)))
                                        .foregroundColor(appearance.eventColor)
                                } else { // Event: None
                                    Text(String(self.calendar.component(.day, from: date)))
                                        .foregroundColor(appearance.dayColor)
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

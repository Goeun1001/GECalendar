//
//  File.swift
//  
//
//  Created by GoEun Jeong on 2021/08/25.
//

#if os(iOS)

import SwiftUI

@available(iOS 14, *)
struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    @EnvironmentObject var appearance: Appearance
    @EnvironmentObject var calendarVM: CalendarViewModel
    
    @State private var month: Date
    let content: (Date) -> DateView
    
    init(
        month: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self._month = State(initialValue: month)
        self.content = content
    }
    
    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: 1)
        )
    }
    
    private var header: some View {
        Group {
            switch appearance.headerType {
            case .leading:
                HStack {
                    Text(appearance.headerDateFormatter.string(from: month))
                        .font(appearance.headerFont)
                        .foregroundColor(appearance.headerTextColor)
                        .padding(.horizontal)
                    Spacer()
                    HStack {
                        Group {
                            Button(action: {
                                self.calendarVM.changeDateBy(0)
                            }) {
                                appearance.headerLeftButtonImage
                            }
                            if appearance.isTodayButton {
                                Button(action: {
                                    self.calendarVM.today()
                                }) {
                                    appearance.headerTodayButtonImage
                                }
                            }
                            Button(action: {
                                self.calendarVM.changeDateBy(1)
                                
                            }) {
                                appearance.headerRightButtonImage
                            }
                        }
                    }
                    .padding(.trailing, 20)
                }
            case .center:
                HStack {
                    Button(action: {
                        self.calendarVM.changeDateBy(0)
                    }) {
                        appearance.headerLeftButtonImage
                    }.padding(.leading, 40)
                    Spacer()
                    Text(appearance.headerDateFormatter.string(from: month))
                        .font(appearance.headerFont)
                        .foregroundColor(appearance.headerTextColor)
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        self.calendarVM.changeDateBy(1)
                    }) {
                        appearance.headerRightButtonImage
                    }
                    .padding(.trailing, 40)
                }
            case .trailing:
                HStack {
                    HStack {
                        Group {
                            Button(action: {
                                self.calendarVM.changeDateBy(0)
                            }) {
                                appearance.headerLeftButtonImage
                            }
                            if appearance.isTodayButton {
                                Button(action: {
                                    self.calendarVM.today()
                                }) {
                                    appearance.headerTodayButtonImage
                                }
                            }
                            Button(action: {
                                self.calendarVM.changeDateBy(1)
                                
                            }) {
                                appearance.headerRightButtonImage
                            }
                        }
                    }.padding(.leading, 20)
                    Spacer()
                    Text(appearance.headerDateFormatter.string(from: month))
                        .font(appearance.headerFont)
                        .foregroundColor(appearance.headerTextColor)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if appearance.isHeader {
                header
            }
            HStack{
                ForEach(0..<7, id: \.self) {index in
                    Text("00")
                        .hidden()
                        .padding(8)
                        .clipShape(Circle())
                        .padding(.horizontal, 4)
                        .overlay(
                            Text(appearance.weekTextDateFormatter.shortWeekdaySymbols[index])
                                .foregroundColor(appearance.weekTextColor)
                                .font(appearance.weekTextFont)
                        )
                }
            }
            
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}

#endif

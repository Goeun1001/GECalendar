//
//  MonthView.swift
//  GECalendarDemo (macOS)
//
//  Created by GoEun Jeong on 2021/08/24.
//

import SwiftUI

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
        return HStack{
            Text(appearance.headerDateFormatter.string(from: month))
                .font(appearance.headerFont)
                .foregroundColor(appearance.headerColor)
                .padding(.horizontal)
            Spacer()
            HStack{
                Group{
                    Button(action: {
                        self.calendarVM.changeDateBy(0)
                    }) {
                        Image(systemName: "chevron.left.square")
                            .resizable()
                    }
                    Button(action: {
                        self.month = Date()
                    }) {
                        Image(systemName: "dot.square")
                            .resizable()
                    }
                    Button(action: {
                        self.calendarVM.changeDateBy(1)
                        
                    }) {
                        Image(systemName: "chevron.right.square")
                            .resizable()
                    }
                }
                .foregroundColor(Color.blue)
                .frame(width: 25, height: 25)
                
            }
            .padding(.trailing, 20)
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if appearance.isHeader {
                    header
                }
                HStack{
                    ForEach(0..<7, id: \.self) {index in
                        Text("00")
                            .hidden()
                            .padding(.bottom, 5)
                            .padding(.horizontal, geo.size.width / 15)
                            .clipShape(Circle())
                            .overlay(
                                Text(appearance.weekDayFormatter.shortWeekdaySymbols[index])
                                    .foregroundColor(appearance.weekDayColor)
                                    .font(appearance.weekDayFont)
                            )
                    }
                }
                
                ForEach(weeks, id: \.self) { week in
                    WeekView(week: week, content: self.content)
                }
            }
        }
    }
}

struct MonthView_Previews: PreviewProvider {
    static let appearance = Appearance()
    @State static var date: Date? = Date()
    
    static var previews: some View {
        Group {
            GECalendar(selectedDate: $date, appearance: appearance)
        }
    }
}

//
//  MonthView.swift
//  GECalendaDemo
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    @State private var month: Date
    let showHeader: Bool
    let content: (Date) -> DateView
    
    @State private var offset: CGSize = .zero
    @State private var leading: Bool = true
    
    init(
        month: Date,
        showHeader: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self._month = State(initialValue: month)
        self.content = content
        self.showHeader = showHeader
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
    
    func changeDateBy(_ months: Int) {
        if let date = Calendar.current.date(byAdding: .month, value: months, to: month) {
            self.month = date
        }
    }
    
    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        return HStack{
            Text(formatter.string(from: month))
                .font(.title)
                .padding(.horizontal)
            Spacer()
            HStack{
                Group{
                    Button(action: {
                        withAnimation {
                            self.changeDateBy(-1)
                            self.leading = true
                        }
                        
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
                        withAnimation {
                            self.changeDateBy(1)
                            self.leading = false
                        }
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
        VStack {
            if showHeader {
                header
            }
            HStack{
                ForEach(0..<7, id: \.self) {index in
                    Text("30")
                        .hidden()
                        .padding(8)
                        .clipShape(Circle())
                        .padding(.horizontal, 4)
                        .overlay(
                            Text(getWeekDaysSorted()[index].uppercased()))
                }
            }
            
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
    
    func getWeekDaysSorted() -> [String]{
        let weekDays = Calendar.current.shortWeekdaySymbols
        let sortedWeekDays = Array(weekDays[Calendar.current.firstWeekday - 1 ..< Calendar.current.shortWeekdaySymbols.count] + weekDays[0 ..< Calendar.current.firstWeekday - 1])
        return sortedWeekDays
    }
}

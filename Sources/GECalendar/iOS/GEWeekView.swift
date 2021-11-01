//
//  SwiftUIView.swift
//  
//
//  Created by GoEun Jeong on 2021/08/30.
//

#if os(iOS)

import SwiftUI

@available(iOS 14, *)
class WeekViewModel: ObservableObject {
    @Environment(\.calendar) var calendar
    
    @Published var weeks = [Date(), Date(), Date()]
    
    private let onChanged: (Date) -> ()
    
    init(onChanged: @escaping (Date) -> () = { _ in }) {
        self.weeks[0] = calendar.generateDates(
            inside: calendar.dateInterval(of: .weekdayOrdinal, for: Calendar.current.date(byAdding: .weekdayOrdinal, value: -1, to: Date())!)!,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        ).first!
        self.weeks[1] = calendar.generateDates(
            inside: calendar.dateInterval(of: .weekdayOrdinal, for: Date())!,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        ).first!
        self.weeks[2] = calendar.generateDates(
            inside: calendar.dateInterval(of: .weekdayOrdinal, for: Calendar.current.date(byAdding: .weekdayOrdinal, value: 1, to: Date())!)!,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        ).first!
    }
    
    func changeDateBy(_ newIndex: Int) {
        //        print("from: \(self.months)")
        if newIndex == 0 {
            // left
            if let date = Calendar.current.date(byAdding: .weekdayOrdinal, value: -1, to: weeks[0]) {
                self.weeks[2] = self.weeks[1]
                self.weeks[1] = self.weeks[0]
                self.weeks[0] = date
            }
        } else {
            // right
            if let date = Calendar.current.date(byAdding: .weekdayOrdinal, value: 1, to: weeks[2]) {
                self.weeks[0] = self.weeks[1]
                self.weeks[1] = self.weeks[2]
                self.weeks[2] = date
            }
        }
        self.onChanged(self.weeks[1])
    }
    
    func today() {
        self.weeks[0] = calendar.generateDates(
            inside: calendar.dateInterval(of: .weekdayOrdinal, for: Calendar.current.date(byAdding: .weekdayOrdinal, value: -1, to: Date())!)!,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        ).first!
        self.weeks[1] = calendar.generateDates(
            inside: calendar.dateInterval(of: .weekdayOrdinal, for: Date())!,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        ).first!
        self.weeks[2] = calendar.generateDates(
            inside: calendar.dateInterval(of: .weekdayOrdinal, for: Calendar.current.date(byAdding: .weekdayOrdinal, value: 1, to: Date())!)!,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        ).first!
    }
}

@available(iOS 14, *)
public struct GEWeekView: View {
    @Environment(\.calendar) var calendar
    @Binding private var appearance: Appearance
    @Binding private var selectedDate: Date?
    
    @ObservedObject private var weekVM = WeekViewModel()
    @State private var currentPage = 1
    
    public init(selectedDate: Binding<Date?>,
                appearance: Binding<Appearance>,
                onChanged: @escaping (Date) -> () = { _ in }) {
        self._selectedDate = selectedDate
        self._appearance = appearance
        self.weekVM = WeekViewModel(onChanged: onChanged)
    }
    
    private var header: some View {
        Group {
            switch appearance.headerType {
            case .leading:
                HStack {
                    Text(appearance.headerDateFormatter.string(from: weekVM.weeks[1]))
                        .font(appearance.headerFont)
                        .foregroundColor(appearance.headerColor)
                        .padding(.horizontal)
                    Spacer()
                    HStack {
                        Group {
                            Button(action: {
                                self.weekVM.changeDateBy(0)
                            }) {
                                appearance.headerLeftButtonImage
                            }
                            if appearance.isTodayButton {
                                Button(action: {
                                    self.weekVM.today()
                                }) {
                                    appearance.headerTodayButtonImage
                                }
                            }
                            Button(action: {
                                self.weekVM.changeDateBy(1)
                                
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
                        self.weekVM.changeDateBy(0)
                    }) {
                        appearance.headerLeftButtonImage
                    }.padding(.leading, 40)
                    Spacer()
                    Text(appearance.headerDateFormatter.string(from: weekVM.weeks[1]))
                        .font(appearance.headerFont)
                        .foregroundColor(appearance.headerColor)
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        self.weekVM.changeDateBy(1)
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
                                self.weekVM.changeDateBy(0)
                            }) {
                                appearance.headerLeftButtonImage
                            }
                            if appearance.isTodayButton {
                                Button(action: {
                                    self.weekVM.today()
                                }) {
                                    appearance.headerTodayButtonImage
                                }
                            }
                            Button(action: {
                                self.weekVM.changeDateBy(1)
                                
                            }) {
                                appearance.headerRightButtonImage
                            }
                        }
                    }.padding(.leading, 20)
                    Spacer()
                    Text(appearance.headerDateFormatter.string(from: weekVM.weeks[1]))
                        .font(appearance.headerFont)
                        .foregroundColor(appearance.headerColor)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    func updateMonthsAfterPagerSwipe(newIndex:Int) {
        self.weekVM.changeDateBy(newIndex)
        self.currentPage = 1
    }
    
    public var body: some View {
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
                            Text(appearance.weekDayFormatter.shortWeekdaySymbols[index])
                                .foregroundColor(appearance.weekDayColor)
                                .font(appearance.weekDayFont)
                        )
                }
            }
            
            PagerView(pageCount: self.weekVM.weeks.count, currentIndex: self.$currentPage, pageChanged: self.updateMonthsAfterPagerSwipe) {
                ForEach(weekVM.weeks, id: \.self) {
                    week in
                    WeekView(week: week, content: { date in
                        Text("00")
                            .hidden()
                            .padding(8)
                            .background(
                                ZStack(alignment: .bottom) {
                                    if calendar.isDateInToday(date) {
                                        appearance.todayColor
                                            .modifier(
                                                ShapeModifier(shape: appearance.selectionShape)
                                            )
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
                                            HStack(spacing: 3) {
                                                ForEach(appearance.multipleEvents.filter { calendar.isDate(date, inSameDayAs: $0.date) }, id: \.self) {
                                                    event in
                                                    Circle().frame(width: 7, height: 7)
                                                        .foregroundColor(event.color)
                                                        .padding(.top, 10)
                                                }
                                            }
                                        } else if appearance.eventType == .line && appearance.multipleEvents.contains(where: {
                                            calendar.isDate(date, inSameDayAs: $0.date)
                                        }) {
                                            VStack(spacing: 1) {
                                                ForEach(appearance.multipleEvents.filter { calendar.isDate(date, inSameDayAs: $0.date) }, id: \.self) {
                                                    event in
                                                    RectangleView(color: event.color)
                                                }
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
                                            Circle().frame(width: 7, height: 7)
                                                .foregroundColor(appearance.eventColor)
                                        } else if appearance.eventType == .line && appearance.events.contains(where: {
                                            calendar.isDate(date, inSameDayAs: $0)
                                        }) {
                                            HStack {
                                                Rectangle()
                                                    .frame(height: 5)
                                            }
                                        }
                                    }
                                    
                                    // common dates
                                    if selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!) {
                                        appearance.selectionColor
                                            .modifier(
                                                ShapeModifier(shape: appearance.selectionShape)
                                            )
                                    }  else {
                                        appearance.defaultColor
                                            .modifier(
                                                ShapeModifier(shape: appearance.defaultShape)
                                            )
                                    }
                                }
                            )
                            .cornerRadius(4)
                            .padding(4)
                            .overlay(
                                Group {
                                    if appearance.eventType == .text && appearance.events.contains(where: {
                                        calendar.isDate(date, inSameDayAs: $0)
                                    }) {
                                        Text(String(self.calendar.component(.day, from: date)))
                                            .foregroundColor(appearance.eventColor)
                                            .onTapGesture {
                                                self.selectedDate = date
                                            }
                                    } else { // Event: None
                                        Text(String(self.calendar.component(.day, from: date)))
                                            .foregroundColor(appearance.dayColor)
                                            .onTapGesture {
                                                self.selectedDate = date
                                            }
                                    }
                                }
                            )
                    }).environmentObject(appearance)
                }
            }
            
        }
    }
}

#endif

//
//  SwiftUIView.swift
//  
//
//  Created by GoEun Jeong on 2021/08/30.
//

#if os(OSX)

import SwiftUI

@available(macOS 11, *)
class WeekViewModel: ObservableObject {
    @Environment(\.calendar) var calendar
    
    @Published var weeks = [Date(), Date(), Date()]
    
    public var onChanged: (Date) -> () = { _ in }
    
    init() {
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

/// Week calendar showing events and selected date
@available(macOS 11, *)
public struct GEWeekView: View {
    @Environment(\.calendar) var calendar
    @Binding private var appearance: Appearance
    @Binding private var selectedDate: Date?
    
    @StateObject private var weekVM = WeekViewModel()
    @State private var currentPage = 1
    
    private let onChanged: (Date) -> ()
    
    /// Create an GEWeekView with selectedDate, appearance, onChanged
    ///
    /// - Parameters:
    ///   - selectedDate: Selected date
    ///   - appearance: Appearance class
    ///   - onChanged: Behavior when the week changes
    public init(selectedDate: Binding<Date?>,
                appearance: Binding<Appearance>,
                onChanged: @escaping (Date) -> () = { _ in }) {
        self._selectedDate = selectedDate
        self._appearance = appearance
        self.onChanged = onChanged
    }
    
    private var header: some View {
        Group {
            switch appearance.headerType {
            case .leading:
                HStack {
                    Text(appearance.headerDateFormatter.string(from: weekVM.weeks[1]))
                        .foregroundColor(appearance.headerTextColor)
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
                }.font(appearance.headerFont)
            case .center:
                HStack {
                    Button(action: {
                        self.weekVM.changeDateBy(0)
                    }) {
                        appearance.headerLeftButtonImage
                    }.padding(.leading, 40)
                    Spacer()
                    Text(appearance.headerDateFormatter.string(from: weekVM.weeks[1]))
                        .foregroundColor(appearance.headerTextColor)
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        self.weekVM.changeDateBy(1)
                    }) {
                        appearance.headerRightButtonImage
                    }
                    .padding(.trailing, 40)
                }.font(appearance.headerFont)
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
                        .foregroundColor(appearance.headerTextColor)
                        .padding(.horizontal)
                }.font(appearance.headerFont)
            }
        }
    }
    
    func updateMonthsAfterPagerSwipe(newIndex:Int) {
        self.weekVM.changeDateBy(newIndex)
        self.currentPage = 1
    }
    
    public var body: some View {
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
                            .padding(.horizontal, geo.size.width / 18)
                            .clipShape(Circle())
                            .overlay(
                                Text(appearance.weekTextDateFormatter.shortWeekdaySymbols[index])
                                    .foregroundColor(appearance.weekTextColor)
                                    .font(appearance.weekTextFont)
                            )
                    }
                }
                
                PagerView(pageCount: self.weekVM.weeks.count, currentIndex: self.$currentPage, pageChanged: self.updateMonthsAfterPagerSwipe) {
                    ForEach(weekVM.weeks, id: \.self) {
                        week in
                        WeekView(week: week, content: { date in
                            Text("00")
                                .hidden()
                                .padding(.vertical, geo.size.height / 20)
                                .padding(.horizontal, geo.size.width / 20)
                                .background(
                                    ZStack(alignment: .bottom) {
                                        if calendar.isDateInToday(date) {
                                            appearance.todayColor
                                                .modifier(
                                                    ShapeModifier(shape: appearance.selectedDateShape)
                                                )
                                                .frame(maxWidth: appearance.osxMaxWidth, maxHeight: appearance.osxMaxHeight)
                                        }
                                        
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
                                                    .offset(y: geo.size.height / 25)
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
                                .padding(4)
                                .overlay(
                                    Group {
                                        if appearance.eventType == .text && appearance.singleEvents.contains(where: {
                                            calendar.isDate(date, inSameDayAs: $0)
                                        }) {
                                            Text(String(self.calendar.component(.day, from: date)))
                                                .foregroundColor(appearance.singleEventColor)
                                                .onTapGesture {
                                                    self.selectedDate = date
                                                }
                                        } else { // Event: None
                                            Text(String(self.calendar.component(.day, from: date)))
                                                .foregroundColor(appearance.dayTextColor)
                                                .onTapGesture {
                                                    self.selectedDate = date
                                                }
                                        }
                                    }
                                )
                        }).environmentObject(appearance)
                    }
                }
                .frame(width: geo.size.width)
            }.onAppear {
                self.weekVM.onChanged = self.onChanged
            }
        }
    }
}

#endif

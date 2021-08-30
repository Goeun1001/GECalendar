//
//  ContentView.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/08/21.
//

import SwiftUI

struct ContentView: View {
    @State var date: Date? = nil
    var body: some View {
        #if os(iOS)
        GEWeekView(selectedDate: $date, appearance: Appearance())
//        GECalendar(selectedDate: $date, appearance:  Appearance())
        #endif
        
        #if os(OSX)
        GEWeekView(selectedDate: $date, appearance: Appearance())
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

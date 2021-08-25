//
//  ContentView.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/08/25.
//

import SwiftUI
import GECalendar

struct ContentView: View {
    @State var date: Date? = Date()
    var body: some View {
        GECalendar(selectedDate: $date, appearance: Appearance())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/08/21.
//

import SwiftUI

struct ContentView: View {
    @State var date: Date? = Date()
    var body: some View {
        #if os(iOS)
        GECalendar(appearance: Appearance())
        #endif
        
        #if os(OSX)
        GECalendar(selectedDate: $date, appearance: Appearance())
//            .frame(width: 200, height: 200)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

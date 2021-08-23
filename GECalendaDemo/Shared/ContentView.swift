//
//  ContentView.swift
//  Shared
//
//  Created by GoEun Jeong on 2021/08/21.
//

import SwiftUI

struct ContentView: View {
    var events = [
            CalendarEvent(dateString: "03/21/2020", data: "Event 1"),
            CalendarEvent(dateString: "03/23/2020", data: "Event 2"),
            CalendarEvent(dateString: "03/26/2020", data: "Event 3"),
            CalendarEvent(dateString: "03/26/2020", data: "Event 4"),
        ]
        
        var body: some View {
            CalendarList(events: self.events) { event in
                Text("\(event.data)")
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

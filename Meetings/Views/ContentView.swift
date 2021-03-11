//
//  ContentView.swift
//  Meetings
//
//  Created by Marco Abundo on 2/15/21.
//

import SwiftUI
import EventKit

struct ContentView: View {
    enum ActiveSheet {
        case calendarChooser
        case calendarEdit
    }

    @Binding var events: [EKEvent]
    @State private var isPresented = false
    @State private var newEventData = EKEvent.Data()
    @State private var activeSheet: ActiveSheet = .calendarChooser
    @ObservedObject var eventsRepository = EventsRepository.shared

    private var disableAddButton: Bool {
        newEventData.title.count == 0 ||
        newEventData.notes == ""
    }

    var body: some View {
        VStack {
            List {
                if events.isEmpty {
                    Text("No events available for this calendar selection")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                ForEach(events, id: \.self.eventIdentifier) { event in
                    NavigationLink(destination: MeetingDetailView(event: binding(for: event))) {
                        CardView(event: event)
                    }
                    .listRowBackground(Color(UIColor.systemBackground))
                }
            }

            SelectedCalendarsList(selectedCalendars: Array(eventsRepository.selectedCalendars ?? []))
                .padding(.vertical)
                .padding(.horizontal, 5)

            Button(action: {
                self.activeSheet = .calendarChooser
                self.isPresented = true
            }) {
                Text("Select calendars")
            }
            .buttonStyle(PrimaryButtonStyle())
            .sheet(isPresented: $isPresented) {
                if self.activeSheet == .calendarChooser {
                    CalendarChooser(calendars: self.$eventsRepository.selectedCalendars, eventStore: self.eventsRepository.eventStore)
                } else {
                    NavigationView {
                        MeetingScheduleView(eventData: $newEventData)
                        .navigationBarItems(leading: Button("Dismiss") {
                            isPresented = false
                        }, trailing: Button("Add") {
                            let newEvent = EKEvent(data: newEventData)

                            events.append(newEvent)

                            isPresented = false
                        }.disabled(disableAddButton))
                    }
                }
            }
        }
        .navigationBarTitle("Meetings")
        .navigationBarItems(trailing: Button(action: {
            self.activeSheet = .calendarEdit
            self.isPresented = true
        }, label: {
            Image(systemName: "plus")
        }))
    }

    private func binding(for event: EKEvent) -> Binding<EKEvent> {
        guard let eventIndex = events.firstIndex(where: { $0.eventIdentifier == event.eventIdentifier }) else {
            fatalError("Can't find event in array")
        }
        return $events[eventIndex]
    }
}

struct MeetingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(events: .constant(EKEvent.data))
        }
    }
}

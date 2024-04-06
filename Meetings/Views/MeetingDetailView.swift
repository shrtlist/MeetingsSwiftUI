//
//  MeetingDetailView.swift
//  Meetings
//
//  Created by Marco Abundo on 2/15/21.
//

import SwiftUI
import EventKit

struct MeetingDetailView: View {
    @ObservedObject var eventsRepository = EventsRepository.shared
    @Binding var event: EKEvent
    @State private var data: EKEvent.Data = EKEvent.Data()
    @State private var isPresented = false

    var disableDoneButton: Bool {
        data.notes == ""
    }

    var body: some View {
        List {
            Section(header: Text("Meeting information")) {
                HStack {
                    Label("Participant", systemImage: "person")
                    Spacer()
                    Text("\(event.title)")
                }

                HStack {
                    Label("Notes", systemImage: "note")
                    Spacer()
                    let notesString = event.notes ?? ""
                    Text("\(notesString)")
                }
            }

            if let recurrenceRule = event.recurrenceRules?.first {
                Section(header: Text("Meeting Recurrence")) {
                    let frequency = recurrenceRule.frequency.description
                    HStack {
                        Label("Frequency", systemImage: "repeat")
                        Spacer()
                        Text(frequency)
                    }

                    HStack {
                        Label("Start date", systemImage: "calendar")
                        Spacer()
                        Text("\(event.startDate, formatter: DateFormatter.mediumStyleDateFormatter)")
                    }

                    HStack {
                        Label("Duration", systemImage: "hourglass")
                        Spacer()
                        Text(recurrenceRule.durationType.description)
                    }

                    if let recurrenceEnd = recurrenceRule.recurrenceEnd {
                        if recurrenceEnd.occurrenceCount > 0 {
                            HStack {
                                Label("Count", systemImage: "number.square")
                                Spacer()
                                Text("\(recurrenceEnd.occurrenceCount)")
                            }
                        } else if let endDate = recurrenceEnd.endDate {
                            HStack {
                                Label("End date", systemImage: "calendar")
                                Spacer()
                                Text("\(endDate, formatter: DateFormatter.mediumStyleDateFormatter)")
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            data = event.data
        })
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
                MeetingScheduleView(eventData: $data)
                    .navigationBarItems(leading: Button("Cancel") {
                        isPresented = false
                    }, trailing: Button("Done" ) {
                        isPresented = false
                        event.update(from: data)
                        eventsRepository.save(event)
                    }.disabled(disableDoneButton))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetailView(event: .constant(EKEvent.data[0]))
    }
}

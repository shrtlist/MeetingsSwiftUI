//
//  MeetingScheduleView.swift
//  Meetings
//
//  Created by Marco Abundo on 2/15/21.
//

import SwiftUI
import Contacts
import EventKit

struct MeetingScheduleView: View {
    @Binding var eventData: EKEvent.Data
    @State private var showPicker = false
    @State private var focus = false
    @State private var frequency = EKRecurrenceFrequency.yearly.rawValue

    var body: some View {
        ZStack {
            ContactPicker(
                showPicker: $showPicker,
                onSelectContact: { contact in
                    eventData.title = CNContactFormatter.string(from: contact, style: .fullName)!
                })
            Form {
                Section(header: Text("Meeting information")) {
                    HStack {
                        Label("Participant", systemImage: "person")
                        TextField("Name", text: $eventData.title)
                            .onTapGesture {
                                self.showPicker.toggle()
                            }
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Label("Notes", systemImage: "note")
                        TextField("Value", text: $eventData.notes)
                            .multilineTextAlignment(TextAlignment.trailing)
                    }
                }

                Section(header: Text("Meeting Recurrence")) {
                    HStack {
                        Label("Frequency", systemImage: "repeat")
                        Picker("", selection: $frequency) {
                            ForEach(0 ..< EKRecurrenceFrequency.allCases.count, id: \.self) { frequency in
                                let recurrenceFrequency = EKRecurrenceFrequency.allCases[frequency]
                                let frequencyString = String(describing: recurrenceFrequency)
                                Text(frequencyString)
                            }
                        }
                        .onChange(of: frequency, perform: { value in
                            guard let recurrenceFrequency = EKRecurrenceFrequency(rawValue: frequency) else {
                                return
                            }
                            eventData.frequency = recurrenceFrequency
                        })
                    }

                    HStack {
                        Label("Start date", systemImage: "calendar")
                        DatePicker("", selection: $eventData.startDate, displayedComponents: .date)
                    }

                    HStack {
                        Label("Duration", systemImage: "hourglass")
                        Picker("", selection: $eventData.durationType) {
                            ForEach(0 ..< DurationType.allCases.count, id: \.self) { value in
                                let durationTypeString = DurationType.allCases[value].description
                                Text("\(durationTypeString)")
                            }
                        }
                    }

                    if eventData.durationType == DurationType.untilSetNumber.rawValue {
                        // Set number of transfers
                        HStack {
                            Label("Count:", systemImage: "number.square")
                            Stepper("\(eventData.numberOfMeetings)", onIncrement: {
                                eventData.numberOfMeetings += 1
                            }, onDecrement: {
                                eventData.numberOfMeetings -= 1
                                if eventData.numberOfMeetings < 1 {
                                    eventData.numberOfMeetings = 1
                                }
                            })
                        }
                    } else if eventData.durationType == DurationType.untilSetEndDate.rawValue {
                        HStack {
                            Label("End date", systemImage: "calendar")
                            DatePicker("", selection: $eventData.recurrenceEndDate, displayedComponents: .date)
                        }
                    }
                }
            }
        }
    }
}

struct GiftScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingScheduleView(eventData: .constant(EKEvent.data[0].data))
    }
}

//
//  CardView.swift
//  Meetings
//
//  Created by Marco Abundo on 2/15/21.
//

import SwiftUI
import EventKit

struct CardView: View {
    let event: EKEvent
    var body: some View {
        HStack {
            Image(systemName: "circle.fill").foregroundColor(event.color)

            VStack(alignment: .leading) {
                Text("\(event.title)")
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Participant"))
                    .accessibilityValue(Text("\(event.title)"))
                    .font(.headline)
                Spacer()
                HStack {
                    let notesString = event.notes ?? ""
                    Label(notesString, systemImage: "note")
                    Spacer()

                    let dateString = DateFormatter.mediumStyleDateFormatter.string(from: event.startDate)
                    Text(dateString)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("Start date"))
                        .accessibilityValue(Text(dateString))
                }
                .font(.caption)
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var event = EKEvent.data[0]
    static var previews: some View {
        CardView(event: event)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

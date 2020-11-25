//
//  FKSTestWidget.swift
//  FKSTestWidget
//
//  Created by Студия on 25.11.2020.
//

import WidgetKit
import SwiftUI
import CoreData
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), name: "1", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), name: "2", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate, name: UserDefaults.standard.string(forKey: "name") ?? "", configuration: configuration)
            entries.append(entry)
        }
		
		

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
	let name: String
    let configuration: ConfigurationIntent
}

struct FKSTestWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.name)
    }
}

@main
struct FKSTestWidget: Widget {
    let kind: String = "FKSTestWidget"
	
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FKSTestWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct FKSTestWidget_Previews: PreviewProvider {
    static var previews: some View {
		FKSTestWidgetEntryView(entry: SimpleEntry(date: Date(), name: "MaxChes", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

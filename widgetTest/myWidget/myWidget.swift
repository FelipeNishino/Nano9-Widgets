//
//  myWidget.swift
//  myWidget
//
//  Created by Felipe Nishino on 25/08/21.
//

import WidgetKit
import SwiftUI

struct FOAASEntry: TimelineEntry {
    let date : Date
    let FOAASMessage : FOAASMessage
}

struct Provider: TimelineProvider {
    @AppStorage("FOAAS", store: UserDefaults(suiteName: "group.com.felipenishino.widgetTest"))
    var FOAASData: Data = Data()
    
    func placeholder(in context: Context) -> FOAASEntry {
        FOAASEntry(date: Date(), FOAASMessage: FOAASMessage.placeholder())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FOAASEntry) -> Void) {
        do {
            let entry = FOAASEntry(date: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!, FOAASMessage: try FOAASMessage(from: FOAASData))
            completion(entry)
        } catch {
            let entry = FOAASEntry(date: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!, FOAASMessage: FOAASMessage.placeholder())
            completion(entry)
        }
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<FOAASEntry>) -> Void) {
        do {
            let entry = FOAASEntry(date: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!, FOAASMessage: try FOAASMessage(from: FOAASData))
            let timeline = Timeline(entries: [entry], policy: .after(entry.date))
            completion(timeline)
        } catch {
            let entry = FOAASEntry(date: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!, FOAASMessage: FOAASMessage.placeholder())
            let timeline = Timeline(entries: [entry], policy: .after(entry.date))
            completion(timeline)
        }
    }
}

struct PlaceholderView: View {
    var body: some View {
        MessageView(message: FOAASMessage.placeholder())
    }
}

struct WidgetEntryView: View {
    let entry : Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body : some View {
        switch family {
        case .systemSmall:
            VStack {
                Text(entry.FOAASMessage.message)
                HStack {
                    Spacer()
                    Text(entry.FOAASMessage.subtitle)
                        .italic()
                        .padding(.trailing, 10)
                }
            }
        case .systemMedium:
            VStack {
                Spacer()
                Text(entry.FOAASMessage.message)
                Spacer()
                HStack {
                    Spacer()
                    Text(entry.FOAASMessage.subtitle)
                        .italic()
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
                }
            }
        case .systemLarge:
            VStack {
                Spacer()
                Text(entry.FOAASMessage.message)
                Spacer()
                HStack {
                    Spacer()
                    Text(entry.FOAASMessage.subtitle)
                        .italic()
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
                }
            }
        default:
            MessageView(message: entry.FOAASMessage)
        }
    }
}

@main
struct myWidget: Widget {
    let kind: String = "myWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) {entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Test")
        .description("Widget test with FOAAS integration.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct myWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetEntryView(entry: FOAASEntry(date: Date(), FOAASMessage: FOAASMessage.placeholder()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            WidgetEntryView(entry: FOAASEntry(date: Date(), FOAASMessage: FOAASMessage.placeholder()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            WidgetEntryView(entry: FOAASEntry(date: Date(), FOAASMessage: FOAASMessage.placeholder()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

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
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
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

//MARK: - Views

struct Header: View {
    let image: UIImage = UIImage()
    let icon: UIImage = UIImage()
    
    var body: some View {
        ZStack {
            //Imagem do Jogo
            Rectangle()
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack {
                HStack {
                    Spacer()
                    //Icone Plataforma
                    Rectangle()
                        .foregroundColor(.blue)
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                }//HStack
                Spacer()
            }//VStack
            .padding(6)
        }//ZStack
    }
}

struct FrameView: View {
    let image: UIImage = UIImage()
    let icon: UIImage = UIImage()
    let title: String
    let height: CGFloat
    
    var body: some View {
        let large = height > 180
        
        VStack {
            Header()
                .frame(height: large ? height * 0.725 : height * 0.6)
            
            Text(title)
                .frame(height: large ? height * 0.125 : height * 0.3)
        }
        .frame(minWidth: 140)
    }
}

struct MoreGames: View {
    let number: Int
    let height: CGFloat
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black)
                    .foregroundColor(.white)
                    .frame(height: height * 0.6)

                Text("+\(number)")
                    .font(.system(size: 30))
            }
            .offset(y: 3)
            Spacer()
        }
    }
}

//MARK: Small
struct SmallWidgetView: View {
    let entry : Provider.Entry
    
    var body: some View {
        GeometryReader { reader in
            
            FrameView(title: entry.FOAASMessage.message, height: reader.size.height)
               
                
        }//GeometryReader
        .padding(8)
    }
}

//MARK: Medium
struct MediumWidgetView: View {
    let entry : Provider.Entry
 
    var body: some View {
        GeometryReader { reader in
            
            HStack {
                FrameView(title: entry.FOAASMessage.message, height: reader.size.height)
                
                FrameView(title: entry.FOAASMessage.message, height: reader.size.height)
                
                MoreGames(number: 8, height: reader.size.height)
                    .frame(minWidth: 50)
                
            }//VStack
        }//GeometryReader
        .padding(8)
    }
}

//MARK: Large
struct LargeWidgetView: View {
    let entry : Provider.Entry
    let number: Int = 4
    var body: some View {
        GeometryReader { reader in
            let divider: CGFloat = number >= 2 ? 2 : 1
            let height = reader.size.height / divider
            
            VStack {
                
                HStack {
                    FrameView(title: entry.FOAASMessage.message, height: height)
                    
                    if number >= 4 {
                        FrameView(title: entry.FOAASMessage.message, height: height)
                    }
                }
                
                HStack {
                    if number >= 2 {
                        FrameView(title: entry.FOAASMessage.message, height: height)
                    }
                    if number >= 3 && number < 5 {
                        FrameView(title: entry.FOAASMessage.message, height: height)
                    }
                    if number > 4 {
                        MoreGames(number: number-3, height: height)
                    }
                }
                
            }//VStack
        }//GeometryReader
        .padding(8)
    }
}

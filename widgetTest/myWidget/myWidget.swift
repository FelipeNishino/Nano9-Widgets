//
//  myWidget.swift
//  myWidget
//
//  Created by Felipe Nishino on 25/08/21.
//

import WidgetKit
import SwiftUI

struct GamesEntry: TimelineEntry {
    let date : Date
    let games : [GameResponse]
    
    static let previewData = [GameResponse(id: 1323, name: "Game 1"), GameResponse(id: 3323, name: "Game 2"), GameResponse(id: 2323, name: "Game 3")]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> GamesEntry {
        GamesEntry(date: Date(), games: [GameResponse(id: 1232, name: "asdasdas adsasdad asd")])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (GamesEntry) -> Void) {
        NetworkManager.shared.getGameData { data in
            let entry = GamesEntry(date: Date(), games: data ?? [GameResponse(id: 0, name: "error")])
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<GamesEntry>) -> Void) {
        NetworkManager.shared.getGameData { data in
            let targetDate = Calendar.current.date(byAdding: .second, value: 30, to: Date())!
            let timeline = Timeline(entries: [GamesEntry(date: Date(), games: data ?? [GameResponse(id: 0, name: "error")])], policy: .after(targetDate))
            completion(timeline)
        }
    }
}

//struct PlaceholderView: View {
//    var body: some View {
//        MessageView(message: FOAASMessage.placeholder())
//        VStack {
//            Spacer()
//            Text(FOAASMessage.placeholder().message)
//            Spacer()
//            HStack {
//                Spacer()
//                Text(FOAASMessage.placeholder().subtitle)
//                    .italic()
//                    .padding(.trailing, 10)
//                    .padding(.bottom, 10)
//            }
//        }
//    }
//}

struct WidgetEntryView: View {
    let entry : Provider.Entry
    
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme
    
    @ViewBuilder
    var body : some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry, number: entry.games.count)
        default:
            SmallWidgetView(entry: entry)
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
        .description("Widget test for showing currently free games.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct myWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetEntryView(entry: GamesEntry(date: Date(), games: GamesEntry.previewData))
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            WidgetEntryView(entry: GamesEntry(date: Date(), games: GamesEntry.previewData))
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            WidgetEntryView(entry: GamesEntry(date: Date(), games: GamesEntry.previewData))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .environment(\.colorScheme, .light)
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

struct FrameView: View, Identifiable {
    var id = UUID()
    let image: UIImage = UIImage()
    let icon: UIImage = UIImage()
    let title: String
    let date: Date
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
            
            FrameView(title: entry.games.randomElement()!.name, date: entry.date, height: reader.size.height)
               
                
        }//GeometryReader
        .padding(8)
    }
}

//MARK: Medium
struct MediumWidgetView: View {
    let entry : Provider.Entry
 
    @ViewBuilder
    var body: some View {
        GeometryReader { reader in
            HStack {
                ForEach(entry.games.choose(min(2, entry.games.count)), id: \.self) { game in
                    FrameView(title: game.name, date: entry.date, height: reader.size.height)
                }
                if (entry.games.count > 2) {
                    MoreGames(number: entry.games.count-2, height: reader.size.height)
                        .frame(minWidth: 50)
                }
            }//VStack
        }//GeometryReader
        .padding(8)
    }
}

//MARK: Large
struct LargeWidgetView: View {
    let entry : Provider.Entry
    let number: Int
    
    var body: some View {
        
        GeometryReader { reader in
            let divider: CGFloat = number >= 2 ? 2 : 1
            let height = reader.size.height / divider
            
            var games = Set<GameResponse>(entry.games)
            let number = games.count
            VStack {
                
                HStack {
                    FrameView(title: games.removeFirst().name, date: entry.date, height: height)
                    
                    if number >= 4 {
                        FrameView(title: games.removeFirst().name, date: entry.date, height: height)
                    }
                }
                
                HStack {
                    if number >= 2 {
                        FrameView(title: games.removeFirst().name, date: entry.date, height: height)
                    }
                    if number >= 3 && number < 5 {
                        FrameView(title: games.removeFirst().name, date: entry.date, height: height)
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

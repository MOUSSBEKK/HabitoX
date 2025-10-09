//
//  ActiveGoalHeatMapWidget.swift
//  ActiveGoalHeatMapWidget
//
//  Created by Thierry Saint-Amand on 01/10/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "HabitoX", heatmapImagePath: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let prefs = UserDefaults(suiteName: "group.com.example.habitox.ActiveGoalHeatMapWidget")
        let title = prefs?.string(forKey: "widget_title") ?? "HabitoX"
        let heatmapImagePath = prefs?.string(forKey: "heatmap_image")
        
        let entry = SimpleEntry(date: Date(), title: title, heatmapImagePath: heatmapImagePath)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }   
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let heatmapImagePath: String?
}

struct ActiveGoalHeatMapWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 4)
                .padding(.top, 4)
            
            if let imagePath = entry.heatmapImagePath,
               let image = UIImage(contentsOfFile: imagePath) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: family == .systemSmall ? 220 : 360 ,maxHeight: 220)
                    //.padding(.horizontal, 4)
            } else {
                // Placeholder si pas d'image
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 120)
                    .overlay(
                        Text("Aucun objectif actif")
                            .foregroundColor(.gray)
                    )
                    .padding(.horizontal, 4)
            }
            
            //Spacer()
        }
        //.background(Color(red: 0.122, green: 0.133, blue: 0.165))
        //.cornerRadius(12)
        .frame(width: .infinity, height: .infinity)
    }
}

struct ActiveGoalHeatMapWidget: Widget {
    let kind: String = "ActiveGoalHeatMapWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ActiveGoalHeatMapWidgetEntryView(entry: entry)
                    .containerBackground(Color(red: 0.122, green: 0.133, blue: 0.165), for: .widget)
            } else {
                ActiveGoalHeatMapWidgetEntryView(entry: entry)
                    .background()
            }
        }
        .configurationDisplayName("HabitoX Heatmap Calendar")
        .description("Affiche le calendrier de votre objectif actif")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    ActiveGoalHeatMapWidget()
} timeline: {
    SimpleEntry(date: .now, title: "Mon Objectif", heatmapImagePath: nil)
    SimpleEntry(date: .now, title: "HabitoX", heatmapImagePath: nil)
}

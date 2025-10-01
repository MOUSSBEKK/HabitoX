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
        let prefs = UserDefaults(suiteName: "group.com.example.habitox")
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

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Titre de l'objectif
            Text(entry.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.top, 8)
            
            // Image de la heatmap
            if let imagePath = entry.heatmapImagePath,
               let image = UIImage(contentsOfFile: imagePath) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 120)
                    .padding(.horizontal, 8)
            } else {
                // Placeholder si pas d'image
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 120)
                    .overlay(
                        Text("Aucun objectif actif")
                            .foregroundColor(.gray)
                    )
                    .padding(.horizontal, 8)
            }
            
            Spacer()
        }
        .background(Color(red: 0.12, green: 0.13, blue: 0.16)) // #1F222A
        .cornerRadius(12)
    }
}

struct ActiveGoalHeatMapWidget: Widget {
    let kind: String = "ActiveGoalHeatMapWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ActiveGoalHeatMapWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ActiveGoalHeatMapWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("HabitoX Heatmap")
        .description("Affiche la heatmap de votre objectif actif")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    ActiveGoalHeatMapWidget()
} timeline: {
    SimpleEntry(date: .now, title: "Mon Objectif", heatmapImagePath: nil)
    SimpleEntry(date: .now, title: "HabitoX", heatmapImagePath: nil)
}

package com.example.habitox

import androidx.glance.appwidget.GlanceAppWidgetReceiver

class ActiveGoalHeatmapWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = ActiveGoalHeatmapWidgetProvider()
}

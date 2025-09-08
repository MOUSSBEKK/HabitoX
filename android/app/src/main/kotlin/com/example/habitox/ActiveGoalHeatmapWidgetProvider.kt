package com.example.habitox

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ActiveGoalHeatmapWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_active_goal_heatmap)

            // Récupérer les données/bitmap sauvegardés par le plugin côté Flutter
            val prefs = HomeWidgetPlugin.getData(context)
            val title = prefs.getString("widget_title", "HabitoX")
            val subtitle = prefs.getString("widget_subtitle", "Objectif actif")
            views.setTextViewText(R.id.widget_title, title)
            views.setTextViewText(R.id.widget_subtitle, subtitle)

            val imagePath = prefs.getString("heatmap_image", null)
            if (!imagePath.isNullOrEmpty()) {
                val bitmap = BitmapFactory.decodeFile(imagePath)
                if (bitmap != null) {
                    views.setImageViewBitmap(R.id.heatmap_image, bitmap)
                }
            }

            // Configurer un PendingIntent pour lancer l'app lorsque l'image est cliquée
            val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.heatmap_image, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        // Aucune gestion spécifique nécessaire pour le moment.
    }
}



package com.example.habitox

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.currentState
import androidx.glance.background
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.BitmapImageProvider
import android.graphics.BitmapFactory
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.layout.Alignment
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.width
import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition

class ActiveGoalHeatmapWidgetProvider : GlanceAppWidget() {

    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    companion object {
        suspend fun updateAll(context: Context) {
            val manager = GlanceAppWidgetManager(context)
            val widget = ActiveGoalHeatmapWidgetProvider()
            val glanceIds = manager.getGlanceIds(widget.javaClass)
            
            glanceIds.forEach { glanceId ->
                widget.update(context, glanceId)
            }
        }
        
        fun updateAllSync(context: Context) {
            // Version synchrone pour être appelée depuis Flutter
            kotlinx.coroutines.runBlocking {
                updateAll(context)
            }
        }
    }

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceContent(context, currentState<HomeWidgetGlanceState>())
        }
    }

    @Composable
    private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
        val prefs = currentState.preferences
        val title = prefs.getString("widget_title", "HabitoX") ?: "HabitoX"
        val heatmapImagePath = prefs.getString("heatmap_image", null)

        Box(
            modifier = GlanceModifier
                .height(180.dp)
                .background(Color(0xFF1F222A))
                .padding(8.dp)
        ) {
            Column(
                modifier = GlanceModifier.fillMaxSize(),
                verticalAlignment = Alignment.Top
            ) {
                Text(
                    text = title,
                    style = TextStyle(
                        color = ColorProvider(Color.White),
                        fontSize = 16.sp
                    ),
                    modifier = GlanceModifier.padding(start = 8.dp, top = 8.dp, bottom = 4.dp)
                )
                if (heatmapImagePath != null) {
                    val imageFile = java.io.File(heatmapImagePath)
                    if (imageFile.exists()) {
                        val bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
                        if (bitmap != null) {
                            Image(
                                provider = BitmapImageProvider(bitmap),
                                contentDescription = "Heatmap de l'objectif",
                                // modifier = GlanceModifier
                                //     .fillMaxWidth()
                                //     .height(60.dp)
                            )
                        } else {
                            Text(
                                text = "Erreur de décodage de l'image",
                                style = TextStyle(
                                    color = ColorProvider(Color.Red),
                                    fontSize = 10.sp
                                )
                            )
                        }
                    } else {
                        // Image non trouvée, afficher un message
                        Text(
                            text = "Heatmap en cours de génération...",
                            style = TextStyle(
                                color = ColorProvider(Color.Gray),
                                fontSize = 10.sp
                            )
                        )
                    }
                } else {
                    // Aucune image disponible
                    Text(
                        text = "Aucun objectif actif",
                        style = TextStyle(
                            color = ColorProvider(Color.Gray),
                            fontSize = 10.sp
                        )
                    )
                }
            }
        }
    }
}



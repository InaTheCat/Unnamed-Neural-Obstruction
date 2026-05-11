package backend.chart;

/*
class ParserExample {
    
    public static function main() {
        // Ruta del chart
        var chartPath = "assets/songs/Premeditated/chart/hard.json";
        
        // Parsear el chart
        var chartData = PsychParser.parseChart(chartPath, "hard");
        
        if (chartData != null) {
            // Obtener estadísticas
            var stats = PsychParser.getChartStats(chartData);
            trace("=== ESTADÍSTICAS DEL CHART ===");
            trace("Canción: " + stats.song);
            trace("Stage: " + stats.stage);
            trace("Jugadores: " + stats.player1 + " vs " + stats.player2);
            trace("Velocidad: " + stats.speed);
            trace("BPM Base: " + stats.baseBPM);
            trace("Secciones totales: " + stats.totalSections);
            trace("Notas totales: " + stats.totalNotes);
            trace("Eventos totales: " + stats.totalEvents);
            trace("Direcciones usadas: " + stats.directionsUsed);
            
            // Obtener todas las notas
            trace("\n=== TODAS LAS NOTAS ===");
            var allNotes = PsychParser.getAllNotes(chartData);
            trace("Total de notas: " + allNotes.length);
            for (i in 0...Math.min(5, allNotes.length)) {
                var note = allNotes[i];
                trace("Nota " + i + ": Tiempo=" + note.time + ", Dirección=" + note.direction + ", Duración=" + note.duration);
            }
            
            // Notas por dirección
            trace("\n=== NOTAS POR DIRECCIÓN ===");
            for (dir in 0...8) {
                var notesByDir = PsychParser.getNotesByDirection(chartData, dir);
                if (notesByDir.length > 0) {
                    trace("Dirección " + dir + ": " + notesByDir.length + " notas");
                }
            }
            
            // Eventos
            trace("\n=== EVENTOS ===");
            var allEvents = PsychParser.getAllEvents(chartData);
            trace("Total de eventos: " + allEvents.length);
            for (i in 0...Math.min(3, allEvents.length)) {
                var event = allEvents[i];
                trace("Evento " + i + ": Tiempo=" + event.time + ", Tipos=" + event.events.length);
            }
            
            // Secciones
            trace("\n=== SECCIONES ===");
            var allSections = PsychParser.getAllSections(chartData);
            trace("Total de secciones: " + allSections.length);
            for (i in 0...Math.min(3, allSections.length)) {
                var section = allSections[i];
                trace("Sección " + i + ": BPM=" + section.bpm + ", Notas=" + section.notes.length + ", ChangeBPM=" + section.changeBPM);
            }
            
            // Exportar datos a diferentes lugares
            trace("\n=== EXPORTANDO DATOS ===");
            
            var baseExportPath = "export/chart_data/";
            
            if (PsychParser.exportToJSON(chartData, baseExportPath + "chart_complete.json")) {
                trace("✓ Exportado: chart_complete.json");
            }
            
            if (PsychParser.exportNotesOnly(chartData, baseExportPath + "notas.json")) {
                trace("✓ Exportado: notas.json");
            }
            
            if (PsychParser.exportEventsOnly(chartData, baseExportPath + "eventos.json")) {
                trace("✓ Exportado: eventos.json");
            }
            
            if (PsychParser.exportSectionsOnly(chartData, baseExportPath + "secciones.json")) {
                trace("✓ Exportado: secciones.json");
            }
            
            if (PsychParser.exportNotesByDirection(chartData, baseExportPath + "notas_por_direccion.json")) {
                trace("✓ Exportado: notas_por_direccion.json");
            }
            
            if (PsychParser.exportNotesByTime(chartData, baseExportPath + "notas_por_tiempo.json")) {
                trace("✓ Exportado: notas_por_tiempo.json");
            }
            
        } else {
            trace("Error al parsear el chart");
        }
    }
}
*/
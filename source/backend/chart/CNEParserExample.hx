package backend.chart;

class CNEParserExample {
    
    public static function main() {
        // Ruta del chart CNE
        var chartPath = "assets/songs/Premeditated/chart/cne.json";
        
        // Parsear el chart CNE
        var chartData = CNEParser.parseChartFile(chartPath);
        
        if (chartData != null) {
            // Obtener estadísticas
            var stats = CNEParser.getChartStats(chartData);
            trace("=== ESTADÍSTICAS DEL CHART CNE ===");
            trace("Versión: " + stats.version);
            trace("Stage: " + stats.stage);
            trace("Scroll Speed: " + stats.scrollSpeed);
            trace("Es Codename Chart: " + stats.isCodenameChart);
            trace("StumLines totales: " + stats.strumLines);
            trace("Notas totales: " + stats.totalNotes);
            trace("Eventos totales: " + stats.totalEvents);
            trace("Event names: " + stats.eventNames);
            
            // Detalle de StumLines
            trace("\n=== DETALLES DE STRUM LINES ===");
            for (i in 0...stats.strumLinePositions.length) {
                var lineInfo = stats.strumLinePositions[i];
                trace("StrumLine " + i + ":");
                trace("  Posición: " + lineInfo.position);
                trace("  KeyCount: " + lineInfo.keyCount);
                trace("  Notas: " + lineInfo.noteCount);
                trace("  Visible: " + lineInfo.visible);
            }
            
            // Todas las strum lines
            trace("\n=== TODAS LAS STRUM LINES ===");
            var allLines = CNEParser.getAllStrumLines(chartData);
            for (i in 0...allLines.length) {
                var line = allLines[i];
                trace("Line " + i + ": " + line.position + " (" + line.noteCount + " notas, " + line.keyCount + " keys)");
                
                // Mostrar primeras notas
                for (j in 0...Math.min(3, line.notes.length)) {
                    var note = line.notes[j];
                    trace("  Nota " + j + ": time=" + note.time + ", id=" + note.id + ", sLen=" + note.sLen);
                }
            }
            
            // Eventos con parámetros agrupados
            trace("\n=== EVENTOS CON PARÁMETROS AGRUPADOS ===");
            var allEvents = CNEParser.getAllEvents(chartData);
            trace("Total eventos: " + allEvents.length);
            
            // Mostrar primeros eventos
            for (i in 0...Math.min(5, allEvents.length)) {
                var event = allEvents[i];
                trace("Evento " + i + ":");
                trace("  Nombre: " + event.name);
                trace("  Tiempo: " + event.time);
                trace("  Parámetros (String): " + event.paramsString);
                trace("  Event Key: " + event.eventKey);
            }
            
            // Eventos por nombre
            trace("\n=== EVENTOS POR NOMBRE ===");
            var bpmEvents = CNEParser.getEventsByName(chartData, "BPM Change");
            trace("BPM Change eventos: " + bpmEvents.length);
            for (event in bpmEvents) {
                trace("  Time: " + event.time + ", Params: " + event.paramsString);
            }
            
            var cameraEvents = CNEParser.getEventsByName(chartData, "Camera Modulo Change");
            trace("Camera Modulo Change eventos: " + cameraEvents.length);
            
            // Notas por StumLine
            trace("\n=== NOTAS POR STRUM LINE ===");
            for (i in 0...Math.min(2, chartData.strumLineCount)) {
                var notes = CNEParser.getNotesByStrumLine(chartData, i);
                trace("StumLine " + i + " (" + allLines[i].position + "): " + notes.length + " notas");
            }
            
            // Notas por ID
            trace("\n=== NOTAS POR ID ===");
            for (id in 0...4) {
                var notesById = CNEParser.getNotesByID(chartData, id);
                if (notesById.length > 0) {
                    trace("Note ID " + id + ": " + notesById.length + " notas");
                }
            }
            
            // Exportar datos
            trace("\n=== EXPORTANDO DATOS CNE ===");
            
            var baseExportPath = "export/chart_data/";
            
            if (CNEParser.exportToJSON(chartData, baseExportPath + "cne_complete.json")) {
                trace("✓ Exportado: cne_complete.json");
            }
            
            if (CNEParser.exportNotesOnly(chartData, baseExportPath + "cne_notas.json")) {
                trace("✓ Exportado: cne_notas.json");
            }
            
            if (CNEParser.exportEventsOnly(chartData, baseExportPath + "cne_eventos.json")) {
                trace("✓ Exportado: cne_eventos.json");
            }
            
            if (CNEParser.exportStrumLinesOnly(chartData, baseExportPath + "cne_strumlines.json")) {
                trace("✓ Exportado: cne_strumlines.json");
            }
            
            if (CNEParser.exportNotesByStrumLine(chartData, baseExportPath + "cne_notas_por_strumline.json")) {
                trace("✓ Exportado: cne_notas_por_strumline.json");
            }
            
            if (CNEParser.exportEventsByName(chartData, baseExportPath + "cne_eventos_por_nombre.json")) {
                trace("✓ Exportado: cne_eventos_por_nombre.json");
            }
            
            if (CNEParser.exportDetailedSummary(chartData, baseExportPath + "cne_resumen_detallado.json")) {
                trace("✓ Exportado: cne_resumen_detallado.json");
            }
            
        } else {
            trace("Error al parsear el chart CNE");
        }
    }
}
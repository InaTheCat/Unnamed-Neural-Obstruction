package backend.chart;

/*
    when vas caminando bien trankis viendo el source de UNO,
    but vez que el parser de cne está completamente comentado porque la IA hizo mal todo y ahora no entiendo una mrd:
    then despues de daras a la tarea de reescribir y documentar todo:
*/

/*
import haxe.Json;
import sys.io.File;

// Estructura para una nota de CNE
typedef CNENote = {
    id: Int, // ID de la nota (0-3 para 4 keys)
    time: Float,
    sLen: Float, // Sustain length (duración)
    type: Int // Tipo de nota
}

// Estructura para un carácter
typedef Character = {
    name: String,
    position: String,
    visible: Bool,
    scale: Float
}

// Estructura para una línea de strums
typedef StrumLine = {
    keyCount: Int,
    position: String, // "dad", "boyfriend", "girlfriend"
    type: Int, // 0 = dad, 1 = boyfriend, 2 = girlfriend
    notes: Array<CNENote>,
    visible: Bool,
    strumSpacing: Float,
    strumPos: Array<Float>,
    strumScale: Float,
    vocalsSuffix: String,
    strumLinePos: Float,
    characters: Array<Dynamic>,
    noteCount: Int
}

// Estructura para un evento CNE (con parámetros agrupados en string)
typedef CNEEvent = {
    time: Float,
    name: String,
    paramsString: String, // Parámetros agrupados en un string: "4,0.8"
    paramsArray: Array<Dynamic>, // Array original para referencia
    eventKey: String // Combinación name + params para identificar eventos únicos
}

// Estructura general del chart CNE
typedef CNEChartData = {
    version: String,
    stage: String,
    scrollSpeed: Float,
    isCodenameChart: Bool,
    allEvents: Array<CNEEvent>,
    allStrumLines: Array<StrumLine>,
    allNotes: Array<CNENote>,
    notesByStrumLine: Map<Int, Array<CNENote>>, // Notas organizadas por índice de strum line
    notesByNoteID: Map<Int, Array<CNENote>>, // Notas organizadas por ID
    eventsByName: Map<String, Array<CNEEvent>>, // Eventos organizados por nombre
    eventsByParamsString: Map<String, Array<CNEEvent>>, // Eventos organizados por parámetros
    strumLineCount: Int,
    totalNotes: Int,
    totalEvents: Int,
    noteTypes: Array<String>
}

class CNEParser {
    
    // Parsear el chart CNE desde un archivo JSON
    public static function parseChartFile(filePath: String): CNEChartData {
        try {
            var jsonContent = File.getContent(filePath);
            var rawData = Json.parse(jsonContent);
            return parseChartData(rawData);
        } catch (e) {
            trace("Error al leer el archivo CNE: " + e);
            return null;
        }
    }
    
    // Parsear los datos del chart CNE desde un objeto JSON
    public static function parseChartData(data: Dynamic): CNEChartData {
        if (data == null) {
            trace("Datos inválidos");
            return null;
        }
        
        var chartData: CNEChartData = {
            version: data.chartVersion != null ? data.chartVersion : "unknown",
            stage: data.stage != null ? data.stage : "stage",
            scrollSpeed: data.scrollSpeed != null ? data.scrollSpeed : 1.0,
            isCodenameChart: data.codenameChart != null ? data.codenameChart : false,
            allEvents: [],
            allStrumLines: [],
            allNotes: [],
            notesByStrumLine: new Map(),
            notesByNoteID: new Map(),
            eventsByName: new Map(),
            eventsByParamsString: new Map(),
            strumLineCount: 0,
            totalNotes: 0,
            totalEvents: 0,
            noteTypes: data.noteTypes != null ? data.noteTypes : []
        };
        
        // Procesar eventos
        if (data.events != null) {
            for (eventData in data.events) {
                var paramsString = _buildParamsString(eventData.params);
                var eventKey = eventData.name + "|" + paramsString;
                
                var cneEvent: CNEEvent = {
                    time: eventData.time,
                    name: eventData.name,
                    paramsString: paramsString,
                    paramsArray: eventData.params,
                    eventKey: eventKey
                };
                
                chartData.allEvents.push(cneEvent);
                
                // Agrupar por nombre
                if (!chartData.eventsByName.exists(eventData.name)) {
                    chartData.eventsByName.set(eventData.name, []);
                }
                chartData.eventsByName.get(eventData.name).push(cneEvent);
                
                // Agrupar por params string
                if (!chartData.eventsByParamsString.exists(paramsString)) {
                    chartData.eventsByParamsString.set(paramsString, []);
                }
                chartData.eventsByParamsString.get(paramsString).push(cneEvent);
            }
        }
        
        // Procesar strumLines
        if (data.strumLines != null) {
            for (lineIndex in 0...data.strumLines.length) {
                var lineData = data.strumLines[lineIndex];
                
                var strumLine: StrumLine = {
                    keyCount: lineData.keyCount != null ? lineData.keyCount : 4,
                    position: lineData.position != null ? lineData.position : "unknown",
                    type: lineData.type != null ? lineData.type : 0,
                    notes: [],
                    visible: lineData.visible != null ? lineData.visible : true,
                    strumSpacing: lineData.strumSpacing != null ? lineData.strumSpacing : 1.0,
                    strumPos: lineData.strumPos != null ? lineData.strumPos : [0],
                    strumScale: lineData.strumScale != null ? lineData.strumScale : 1.0,
                    vocalsSuffix: lineData.vocalsSuffix != null ? lineData.vocalsSuffix : "",
                    strumLinePos: lineData.strumLinePos != null ? lineData.strumLinePos : 0.0,
                    characters: lineData.characters != null ? lineData.characters : [],
                    noteCount: 0
                };
                
                // Procesar notas de la strum line
                if (lineData.notes != null) {
                    for (noteData in lineData.notes) {
                        var note: CNENote = {
                            id: noteData.id,
                            time: noteData.time,
                            sLen: noteData.sLen,
                            type: noteData.type != null ? noteData.type : 0
                        };
                        
                        strumLine.notes.push(note);
                        chartData.allNotes.push(note);
                        
                        // Agrupar por strum line index
                        if (!chartData.notesByStrumLine.exists(lineIndex)) {
                            chartData.notesByStrumLine.set(lineIndex, []);
                        }
                        chartData.notesByStrumLine.get(lineIndex).push(note);
                        
                        // Agrupar por note ID
                        if (!chartData.notesByNoteID.exists(note.id)) {
                            chartData.notesByNoteID.set(note.id, []);
                        }
                        chartData.notesByNoteID.get(note.id).push(note);
                    }
                }
                
                strumLine.noteCount = strumLine.notes.length;
                chartData.allStrumLines.push(strumLine);
            }
        }
        
        chartData.strumLineCount = chartData.allStrumLines.length;
        chartData.totalNotes = chartData.allNotes.length;
        chartData.totalEvents = chartData.allEvents.length;
        
        return chartData;
    }
    
    // Función auxiliar para agrupar parámetros en un string
    private static function _buildParamsString(params: Array<Dynamic>): String {
        if (params == null || params.length == 0) {
            return "";
        }
        
        var parts = [];
        for (param in params) {
            if (param == null) {
                parts.push("null");
            } else if (Std.is(param, String)) {
                parts.push('"' + param + '"');
            } else if (Std.is(param, Float)) {
                parts.push(Std.string(param));
            } else if (Std.is(param, Int)) {
                parts.push(Std.string(param));
            } else {
                parts.push(Std.string(param));
            }
        }
        
        return parts.join(",");
    }
    
    // Obtener todas las notas
    public static function getAllNotes(chartData: CNEChartData): Array<CNENote> {
        return chartData.allNotes;
    }
    
    // Obtener todas las strumLines
    public static function getAllStrumLines(chartData: CNEChartData): Array<StrumLine> {
        return chartData.allStrumLines;
    }
    
    // Obtener todos los eventos
    public static function getAllEvents(chartData: CNEChartData): Array<CNEEvent> {
        return chartData.allEvents;
    }
    
    // Obtener una strum line específica
    public static function getStrumLine(chartData: CNEChartData, index: Int): StrumLine {
        return index >= 0 && index < chartData.allStrumLines.length ? chartData.allStrumLines[index] : null;
    }
    
    // Obtener notas de una strum line específica
    public static function getNotesByStrumLine(chartData: CNEChartData, strumLineIndex: Int): Array<CNENote> {
        return chartData.notesByStrumLine.exists(strumLineIndex) ? chartData.notesByStrumLine.get(strumLineIndex) : [];
    }
    
    // Obtener notas por ID
    public static function getNotesByID(chartData: CNEChartData, noteID: Int): Array<CNENote> {
        return chartData.notesByNoteID.exists(noteID) ? chartData.notesByNoteID.get(noteID) : [];
    }
    
    // Obtener eventos por nombre
    public static function getEventsByName(chartData: CNEChartData, eventName: String): Array<CNEEvent> {
        return chartData.eventsByName.exists(eventName) ? chartData.eventsByName.get(eventName) : [];
    }
    
    // Obtener eventos por params string
    public static function getEventsByParams(chartData: CNEChartData, paramsString: String): Array<CNEEvent> {
        return chartData.eventsByParamsString.exists(paramsString) ? chartData.eventsByParamsString.get(paramsString) : [];
    }
    
    // Obtener estadísticas del chart
    public static function getChartStats(chartData: CNEChartData): Dynamic {
        var stats: Dynamic = {
            version: chartData.version,
            stage: chartData.stage,
            scrollSpeed: chartData.scrollSpeed,
            isCodenameChart: chartData.isCodenameChart,
            strumLines: chartData.strumLineCount,
            totalNotes: chartData.totalNotes,
            totalEvents: chartData.totalEvents,
            noteTypes: chartData.noteTypes,
            eventNames: chartData.eventsByName.keys().array(),
            strumLinePositions: []
        };
        
        for (line in chartData.allStrumLines) {
            stats.strumLinePositions.push({
                position: line.position,
                keyCount: line.keyCount,
                noteCount: line.noteCount,
                visible: line.visible
            });
        }
        
        return stats;
    }
    
    // Exportar todos los datos a JSON
    public static function exportToJSON(chartData: CNEChartData, filePath: String): Bool {
        try {
            var exportData = {
                metadata: {
                    version: chartData.version,
                    stage: chartData.stage,
                    scrollSpeed: chartData.scrollSpeed,
                    isCodenameChart: chartData.isCodenameChart
                },
                stats: {
                    strumLines: chartData.strumLineCount,
                    totalNotes: chartData.totalNotes,
                    totalEvents: chartData.totalEvents
                },
                strumLines: chartData.allStrumLines,
                notes: chartData.allNotes,
                events: chartData.allEvents
            };
            
            var jsonStr = Json.stringify(exportData, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e) {
            trace("Error al exportar JSON CNE: " + e);
            return false;
        }
    }
    
    // Exportar solo notas
    public static function exportNotesOnly(chartData: CNEChartData, filePath: String): Bool {
        try {
            var jsonStr = Json.stringify(chartData.allNotes, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e) {
            trace("Error al exportar notas CNE: " + e);
            return false;
        }
    }
    
    // Exportar solo eventos con parámetros agrupados
    public static function exportEventsOnly(chartData: CNEChartData, filePath: String): Bool {
        try {
            var eventExport = [];
            for (event in chartData.allEvents) {
                eventExport.push({
                    time: event.time,
                    name: event.name,
                    params: event.paramsString,
                    eventKey: event.eventKey
                });
            }
            var jsonStr = Json.stringify(eventExport, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e) {
            trace("Error al exportar eventos CNE: " + e);
            return false;
        }
    }
    
    // Exportar solo strumLines
    public static function exportStrumLinesOnly(chartData: CNEChartData, filePath: String): Bool {
        try {
            var jsonStr = Json.stringify(chartData.allStrumLines, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e) {
            trace("Error al exportar strumLines: " + e);
            return false;
        }
    }
    
    // Exportar notas por strum line
    public static function exportNotesByStrumLine(chartData: CNEChartData, filePath: String): Bool {
        try {
            var strumData: Dynamic = {};
            for (i in 0...chartData.allStrumLines.length) {
                var line = chartData.allStrumLines[i];
                var key = 'strumline_' + i + '_' + line.position;
                Reflect.setField(strumData, key, chartData.notesByStrumLine.get(i));
            }
            var jsonStr = Json.stringify(strumData, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e) {
            trace("Error al exportar notas por strum line: " + e);
            return false;
        }
    }
    
    // Exportar eventos organizados por nombre
    public static function exportEventsByName(chartData: CNEChartData, filePath: String): Bool {
        try {
            var eventData: Dynamic = {};
            for (eventName in chartData.eventsByName.keys()) {
                var events = chartData.eventsByName.get(eventName);
                var exportEvents = [];
                for (event in events) {
                    exportEvents.push({
                        time: event.time,
                        params: event.paramsString,
                        eventKey: event.eventKey
                    });
                }
                Reflect.setField(eventData, eventName, exportEvents);
            }
            var jsonStr = Json.stringify(eventData, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e) {
            trace("Error al exportar eventos por nombre: " + e);
            return false;
        }
    }
    
    // Exportar un resumen detallado
    public static function exportDetailedSummary(chartData: CNEChartData, filePath: String): Bool {
        try {
            var summary: Dynamic = {
                chart: getChartStats(chartData),
                strumLinesDetail: [],
                eventsDetail: [],
                notesPerNoteID: {}
            };
            
            // Detalle de strumLines
            for (line in chartData.allStrumLines) {
                summary.strumLinesDetail.push({
                    position: line.position,
                    keyCount: line.keyCount,
                    noteCount: line.noteCount,
                    visible: line.visible,
                    vocalsSuffix: line.vocalsSuffix,
                    characterCount: line.characters.length
                });
            }
            
            // Detalle de eventos
            for (event in chartData.allEvents) {
                summary.eventsDetail.push({
                    time: event.time,
                    name: event.name,
                    params: event.paramsString,
                    paramsCount: event.paramsArray.length
                });
            }
            
            // Notas por ID
            for (noteID in chartData.notesByNoteID.keys()) {
                var noteList = chartData.notesByNoteID.get(noteID);
                Reflect.setField(summary.notesPerNoteID, 'noteID_' + noteID, {
                    count: noteList.length,
                    times: [for (n in noteList) n.time]
                });
            }
            
            var jsonStr = Json.stringify(summary, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e) {
            trace("Error al exportar resumen: " + e);
            return false;
        }
    }
}
*/
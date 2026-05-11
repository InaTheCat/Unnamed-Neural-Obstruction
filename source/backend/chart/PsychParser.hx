package backend.chart;

import backend.TroubleShooter;
import haxe.Json;
import sys.io.File;
import utils.Paths;

// Single note struct
typedef Note = {
    time:Float,
    direction:Int,
    duration:Float,
    customData:Dynamic
}

// Note section struct
typedef Section = {
    lengthInSteps:Int,
    altAnim:Bool,
    notes:Array<Note>,
    bpm:Int,
    sectionBeats:Int,
    changeBPM:Bool,
    mustHitSection:Bool
}

// Events struct
typedef ChartEvent = {
    time:Float,
    events:Array<Array<Dynamic>>
}

// General structure
typedef ChartData = {
    stage:String,
    speed:Float,
    player1:String,
    player2:String,
    bpm:Int,
    validScore:Bool,
    needsVoices:Bool,
    songName:String,
    events:Array<ChartEvent>,
    sections:Array<Section>,
    notes:Array<Note>,
    nTime:Map<String, Array<Note>>,
    direction:Map<Int, Array<Note>>,
    cSection:Int,
    nTotal:Int
}

class PsychParser {
    public static function parseChart(filePath:String, difficulty:String):ChartData {
        try {
            var jsonContent = File.getContent(Paths.songJson(filePath, difficulty));
            var rawData = Json.parse(jsonContent);
            return parseChartData(rawData);
        } catch (e) {
            trouble('Error while reading file. (ERR: ${e})');
            return null;
        }
    }
    
    // Parsing time heh
    public static function parseChartData(data:Dynamic):ChartData {
        if (data == null || data.song == null) {
            var troubleShoot:String;

            if (data == null)
                troubleShoot = 'Data is null. Check theres existing chart or if the file exists';
            else if (data.song == null)
                troubleShoot = 'Missing "song" field.';
            else
                troubleShoot = 'Unexpected error. Check the JSON structure and replace it.';
        
            trouble(troubleShoot, 'warning');
            return null;
        }
        
        var song = data.song;
        var chartData:ChartData = {
            stage: song.stage,
            speed: song.speed,
            player1: song.player1,
            player2: song.player2,
            bpm: song.bpm,
            validScore: song.validScore,
            needsVoices: song.needsVoices,
            songName: song.song,
            events: [],
            sections: [],
            notes: [],
            nTime: new Map(),
            direction: new Map(),
            cSection: 0,
            nTotal: 0
        };
        
        // Init events
        if (song.events != null) {
            for (eventArray in (song.events : Array<Dynamic>)) {
                if (eventArray.length >= 2) {
                    var time:Float = eventArray[0];
                    var events:Array<Array<Dynamic>> = eventArray[1];
                    chartData.events.push({
                        time: time,
                        events: events
                    });
                }
            }
        }
        
        // Init sections and notes
        if (song.notes != null) {
            for (sectionData in (song.notes : Array<Dynamic>)) {
                var section:Section = {
                    lengthInSteps: sectionData.lengthInSteps,
                    altAnim: sectionData.altAnim,
                    notes: [],
                    bpm: sectionData.bpm,
                    sectionBeats: sectionData.sectionBeats,
                    changeBPM: sectionData.changeBPM,
                    mustHitSection: sectionData.mustHitSection
                };
                
                // Init notes
                if (sectionData.sectionNotes != null) {
                    for (noteData in (sectionData.sectionNotes : Array<Dynamic>)) {
                        if (noteData.length >= 3) {
                            var note:Note = {
                                time: noteData[0],
                                direction: noteData[1],
                                duration: noteData[2],
                                customData: noteData.length > 3 ? noteData[3] : null
                            };
                            
                            section.notes.push(note);
                            chartData.notes.push(note);
                            
                            // Add nTime's
                            var timeKey = Std.string(note.time);
                            if (!chartData.nTime.exists(timeKey)) {
                                chartData.nTime.set(timeKey, []);
                            }
                            chartData.nTime.get(timeKey).push(note);
                            
                            // Add directions
                            if (!chartData.direction.exists(note.direction)) {
                                chartData.direction.set(note.direction, []);
                            }
                            chartData.direction.get(note.direction).push(note);
                        }
                    }
                }
                
                chartData.sections.push(section);
            }
        }
        
        chartData.cSection = chartData.sections.length;
        chartData.nTotal = chartData.notes.length;
        
        return chartData;
    }
    
    public static function getNotes(chartData:ChartData):Array<Note>
        return chartData.notes;
    
    public static function getSections(chartData:ChartData):Array<Section>
        return chartData.sections;
    
    public static function getEvents(chartData:ChartData):Array<ChartEvent>
        return chartData.events;
    
    public static function getNotesTime(chartData:ChartData, time: Float):Array<Note>
        return chartData.nTime.exists(Std.string(time)) ? chartData.nTime.get(Std.string(time)) : [];

    public static function getNotesDirection(chartData:ChartData, direction: Int):Array<Note>
        return chartData.direction.exists(direction) ? chartData.direction.get(direction) : [];

    public static function getSection(chartData:ChartData, index: Int):Section
        return index >= 0 && index < chartData.sections.length ? chartData.sections[index] : null;
    
    // Get stats
    public static function getChartStats(chartData:ChartData): Dynamic {
        var stats: Dynamic = {
            totalSections: chartData.cSection,
            nTotal: chartData.nTotal,
            song: chartData.songName,
            stage: chartData.stage,
            speed: chartData.speed,
            player1: chartData.player1,
            player2: chartData.player2,
            baseBPM: chartData.bpm,
            totalEvents: chartData.events.length,
            uniqueDirections: [for (k in chartData.direction.keys()) k].length,
            directionsUsed: [for (k in chartData.direction.keys()) k]
        };
        
        return stats;
    }
    
    // Export json
    public static function exportToJSON(chartData:ChartData, filePath:String):Bool {
        try {
            var exportData = {
                metadata: {
                    song: chartData.songName,
                    stage: chartData.stage,
                    speed: chartData.speed,
                    player1: chartData.player1,
                    player2: chartData.player2,
                    bpm: chartData.bpm,
                    validScore: chartData.validScore,
                    needsVoices: chartData.needsVoices
                },
                stats: {
                    totalSections: chartData.cSection,
                    nTotal: chartData.nTotal,
                    totalEvents: chartData.events.length
                },
                sections: chartData.sections,
                notes: chartData.notes,
                events: chartData.events
            };
            
            var jsonStr = Json.stringify(exportData, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e:Dynamic) {
            trouble('Json could not be exported. (ERR: ${e})');
            return false;
        }
    }
    
    // Exports only notes
    public static function exportNotesOnly(chartData:ChartData, filePath:String):Bool {
        try {
            var jsonStr = Json.stringify(chartData.notes, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e:Dynamic) {
            trouble('Notes could not be exported. (ERR: ${e})');
            return false;
        }
    }
    
    // Exports only events
    public static function exportEventsOnly(chartData:ChartData, filePath:String):Bool {
        try {
            var jsonStr = Json.stringify(chartData.events, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e:Dynamic) {
            trouble('Events could not be exported. (ERR: ${e})');
            return false;
        }
    }
    
    // Exports only sections
    public static function exportSectionsOnly(chartData:ChartData, filePath:String):Bool {
        try {
            var jsonStr = Json.stringify(chartData.sections, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e:Dynamic) {
            trouble('Sections could not be exported. (ERR: ${e})');
            return false;
        }
    }
    
    // Export only directions
    public static function exportNotesByDirection(chartData:ChartData, filePath:String):Bool {
        try {
            var directionData: Dynamic = {};
            for (direction in chartData.direction.keys()) {
                var dirStr = 'dir_' + direction;
                Reflect.setField(directionData, dirStr, chartData.direction.get(direction));
            }
            var jsonStr = Json.stringify(directionData, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e:Dynamic) {
            trouble('Notes by direction could not be exported. (ERR: ${e})');
            return false;
        }
    }
    
    // Export only times
    public static function exportNotesByTime(chartData:ChartData, filePath:String):Bool {
        try {
            var timeData: Dynamic = {};
            for (timeStr in chartData.nTime.keys()) {
                Reflect.setField(timeData, 'time_' + timeStr, chartData.nTime.get(timeStr));
            }
            var jsonStr = Json.stringify(timeData, null, "  ");
            File.saveContent(filePath, jsonStr);
            return true;
        } catch (e:Dynamic) {
            trouble('Notes by time could not be exported. (ERR: ${e})');
            return false;
        }
    }

    private static function trouble(msg:String, ?type:String = 'error') {
        if (TroubleShooter.instance == null) return;
        TroubleShooter.instance.send(msg, type);
    }
}

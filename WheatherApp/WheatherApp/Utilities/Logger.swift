import Foundation

enum LogLevel: String {
    case info = "ℹ️"
    case debug = "🔍"
    case warning = "⚠️"
    case error = "❌"
    case success = "✅"
    case network = "🌐"
    case weather = "🌡️"
    case location = "📍"
}

class Logger {
    static func log(_ level: LogLevel, _ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        let timestamp = dateFormatter.string(from: Date())
        
        print("\(timestamp) \(level.rawValue) [\(fileName):\(line)] \(function) ➡️ \(message)")
    }
    
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.info, message, file: file, function: function, line: line)
    }
    
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.debug, message, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.warning, message, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message, file: file, function: function, line: line)
    }
    
    static func success(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.success, message, file: file, function: function, line: line)
    }
    
    static func network(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.network, message, file: file, function: function, line: line)
    }
    
    static func weather(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.weather, message, file: file, function: function, line: line)
    }
    
    static func location(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.location, message, file: file, function: function, line: line)
    }
} 
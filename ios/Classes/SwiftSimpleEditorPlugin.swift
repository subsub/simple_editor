import Flutter
import UIKit

public class SwiftSimpleEditorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "id.subkhansarif.lib/simple_editor", binaryMessenger: registrar.messenger())
    let instance = SwiftSimpleEditorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method ==  "formatHtml" {
        let formattedString = formatHTML(call.arguments as? String)
        return result(formattedString)
    }

    if call.method == "sanitizeHTML" {
      let sanitizedString = sanitizeHTML(call.arguments as? String)
      return result(sanitizedString)
    }

    result("iOS " + UIDevice.current.systemVersion)
  }
    
  public func sanitizeHTML(_ v: String?) -> String {
    guard let value = v else {
      return ""
    }

    var result = value

    result = result.sanitizeBullets()

    result = result.sanitizeNewLine()

    result = result.sanitizeP()

    return result
  }

  public func formatHTML(_ v: String?) -> String {
    guard let value = v else {
      return ""
    }
    
    var result = value

    
    // sanitize bullets
    result = result.formatBullets()
    
    // sanitize new line
    result = result.formatNewLine()
    
    return "<p>\(result)</p>"
  }
}

extension String {
  func formatNewLine() -> String {
    let result = self.replacingOccurrences(of: "\n", with: "<br />")
    return result
  }
  
  func formatBullets() -> String {
    let regex = try! NSRegularExpression(pattern: "(\n-\\s)(.{1,})(\n)", options: NSRegularExpression.Options.caseInsensitive)
    let range = NSRange(location: 0, length: self.count)
    return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "<br/><li>$2</li><br/>")
  }

  func sanitizeNewLine() -> String {
    let regex = try! NSRegularExpression(pattern: "(<br\\s*/>)", options: NSRegularExpression.Options.caseInsensitive)
    let range = NSRange(location: 0, length: self.count)
    return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "\n")
  }
    
  func sanitizeP() -> String {
    let regex = try! NSRegularExpression(pattern: "(<p>)|(</p>)", options: NSRegularExpression.Options.caseInsensitive)
    let range = NSRange(location: 0, length: self.count)
    return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
  }

  func sanitizeBullets() -> String {
    let regex = try! NSRegularExpression(pattern: "(<li>)(([^<>/]){1,})(</li>)", options: NSRegularExpression.Options.caseInsensitive)
    let range = NSRange(location: 0, length: self.count)
    return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "\n- $2")
  }
}

package id.subkhansarif.lib.simple_editor

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

fun String.formatNewLine() -> String {
  val result = this.replace(of: "\n", with: "<br />")
  return result
}

fun String.formatBullets() -> String {
  val regex = try! NSRegularExpression(pattern: "(\n-\\s)(.{1,})(\n)", options: NSRegularExpression.Options.caseInsensitive)
  val range = NSRange(location: 0, length: self.count)
  return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "<br/><li>$2</li><br/>")
}

fun String.sanitizeNewLine() -> String {
  val regex = try! NSRegularExpression(pattern: "(<br\\s*/>)", options: NSRegularExpression.Options.caseInsensitive)
  val range = NSRange(location: 0, length: self.count)
  return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "\n")
}
  
fun String.sanitizeP() -> String {
  val regex = try! NSRegularExpression(pattern: "(<p>)|(</p>)", options: NSRegularExpression.Options.caseInsensitive)
  val range = NSRange(location: 0, length: self.count)
  return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
}

fun String.sanitizeBullets() -> String {
  val regex = try! NSRegularExpression(pattern: "(<li>)(([^<>/]){1,})(</li>)", options: NSRegularExpression.Options.caseInsensitive)
  val range = NSRange(location: 0, length: self.count)
  return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "\n- $2")
}

/** SimpleEditorPlugin */
class SimpleEditorPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "id.subkhansarif.lib/simple_editor")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if call.method ==  "formatHtml" {
        val formattedString = formatHTML(call.arguments as? String)
        return result(formattedString)
    }

    if call.method == "sanitizeHTML" {
      val sanitizedString = sanitizeHTML(call.arguments as? String)
      return result(sanitizedString)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }


  public fun sanitizeHTML(v: String?) -> String {
    if v == nil {
      return ""
    }

    var result = v!

    result = result.sanitizeBullets()

    result = result.sanitizeNewLine()

    result = result.sanitizeP()

    return result
  }

  public func formatHTML(v: String?) -> String {
    if v == nil {
      return ""
    }
    
    var result = v

    
    // sanitize bullets
    result = result.formatBullets()
    
    // sanitize new line
    result = result.formatNewLine()
    
    return "<p>\(result)</p>"
  }
}

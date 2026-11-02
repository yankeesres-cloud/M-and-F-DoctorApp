import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // Open as a phone-sized window (about 412 x 880 points), centred on screen.
    let phoneSize = NSSize(width: 412, height: 880)
    self.setContentSize(phoneSize)
    self.contentMinSize = NSSize(width: 360, height: 640)
    self.title = "M&F"
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}

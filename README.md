# Yieldprobe for iOS

This folder contains:

* `ObjectiveCSample`: a sample integration using Objective-C,
* `SwiftSample`: a sample integration using Swift,
* `Frameworks/Yieldprobe.xcframework`: The Yieldprobe SDK.
* `Frameworks/AditionAdsLib.framework`: The Adition SDK.

The sample apps show a way to integrate the Yieldprobe SDK into the class `ViewController`.

## Integration Instructions

1. Select your Xcode project in the sidebar
2. Select your app target
3. Select “General”
4. Select “Frameworks, Libraries, and Embedded Content”
5. Drag and drop `Yieldprobe.xcframework` into the list.
6. Make sure `Yieldprobe.xcframework` is configured as **Embed & Sign**.  

## API Usage

1. Import the Yieldprobe SDK by adding `import Yieldprobe` (Swift) or `@import Yieldprobe;` (Objective-C) to the beginning of your source file.
2. Use the shared instance to probe for a bid:

```swift
Yieldprobe.shared.probe(slot: <#yourAdSlotID#>) { result in
    do {
        let bid = try result.get()
        let customTargeting = try bid.customTargeting()
        <#forward custom targeting information to your ad server#>
    } catch {
        <#implement error handling code here.#>
    }
}
```

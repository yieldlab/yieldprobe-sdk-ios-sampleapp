# Yieldprobe for iOS

* [API Reference](https://yieldlab.github.io/yieldprobe-sdk-ios/)

This folder contains:

* `ObjectiveCSample`: a sample integration using Objective-C,
* `SwiftSample`: a sample integration using Swift,
* `Frameworks/Yieldprobe.xcframework`: The Yieldprobe SDK.
* `Frameworks/AditionAdsLib.framework`: The Adition SDK.

The sample apps show a way to integrate the Yieldprobe SDK into the class `ViewController`.

## Integration Instructions

1. Select your Xcode project in the sidebar
2. Select the project above the list of targets
3. Select the tab *“Swift Packages”*
4. Enter this value in the search bar `https://github.com/yieldlab/yieldprobe-sdk-ios.git`
5. Click *“Next”*
6. Select *“Branch”* → *“master”*
7. Click *“Next”*
8. In the list *“Choose package product and targets:”* make sure you add *“Yieldprobe, Library”* to your app target.
9. Import Yieldprobe into your code: `import Yieldprobe`
10. Start using the Yieldprobe API.

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

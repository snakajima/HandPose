# Demonstration of Memory Leak with VNDetectHumanHandPoseRequest
## How to reproduce with Xcode (12.2 beta 2 or later).
1. Select "MacPose" as the target
2. Build and Run
3. Notice the memory usage (typically ~27MB)
4. Select Format->Gesture from the menu to turn it on
5. Move the hand(s) in front of the camera and see the debug output (results.count will be displayed)
6. Notice the memory usage (typcally ~110MB)
7. Select Format->Gesture from the menu to turn it off
8. Notice the memory usage (still ~110MB)

## Overview
- Note: This sample code is based on the sample providead with WWDC20 session [10653: Detect Body and Hand Pose with Vision](https://developer.apple.com/videos/play/wwdc2020/10653/).


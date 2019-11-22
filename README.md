# MCIV
[![Twitter: @Nick_Ignatenko](https://img.shields.io/badge/contact-@Nick_Ignatenko-blue.svg?style=flat)](https://twitter.com/Nick_Ignatenko)
[![License](https://img.shields.io/badge/MCIV-blue.svg?style=flat)](https://github.com/NI92/MCIV-Example/blob/master/README.md)
[![Platform](https://img.shields.io/badge/iOS-blue.svg?style=flat)]()
----------------
## Overview
A new architecture MCIV (Module-Controller-Interface-View) for iOS that's meant to help with scaling a massive project & keeping your code clean.

General idea is to break the app into logical modules, such as the 'Authorization' module that every app opens up on or the 'Main' module which is usually 
what devs name where the user is taken to by default after successful authorization. Or perhaps the 'Settings' module for tweaking app parameters.
Either way, each module always has its own storyboard with its own UI elements, screens, etc., it has at least one controller, some custom views with xibs perhaps
& some kind of networking layer. 
The 'Interface' folder is what should contain your data sources, networking presentation models & even something similar to a VIPER `Router` for navigating between modules.

Look around the code to see how things work. Observe how network calls are made, models parse network response JSON data & how it's presented 
through a `DataSource` (data sources take care of UITableView & UICollectionView logic - in the project example I'm using the collection view variant).
The 'Classes' folder essentially contains all your boilerplate code.

This architecture has been successfully battle tested on several big projects, such as:
Express Menu - Azbuka Vkusa
https://apps.apple.com/ru/app/экспресс-меню-азбука-вкуса/id1057134277
LookMeUp
https://apps.apple.com/ua/app/lookmeup-new-dating-near/id971083253

P.S. I'm using Harvard Art Museum API to get data.

## Example

Download the project, cd it into your terminal & run `pod install` to pull up all the required libraries. Then open the project, code sign with your credentials & run the app.
The actual app itself is nothing special at all. What's important to understand is the scalability this architecture offers.

## Requirements

- Xcode 9.0+
- iOS 9.0+
- Swift 5.0+

## Author

Nick Ignatenko

## License

MCIV is available under the MIT license. See the LICENSE file for more info.

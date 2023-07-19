# E-Commerce Application (Swift + MVVM)

![iOS workflow badge](https://github.com/oguzhankaymak/E-CommerceApp/actions/workflows/ios.yml/badge.svg)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)

A simple e-commerce application built using Swift with the Model-View-ViewModel (MVVM) architecture. The app allows users to browse and search for products, add items to the cart, and proceed to checkout. This project does not use storyboards and adopts a full programmatic UI approach.

## Features

- Browse and search for products
- Add products to the shopping cart
- View the shopping cart contents
- Proceed to checkout and complete the order (Mock service, no real payments)

## Installation

1. Clone this repository to your local machine.
2. Open the Xcode project.
3. Build and run the application on your simulator or iOS device.

## Dependencies

The project uses the following third-party libraries:

- [SDWebImage](https://github.com/SDWebImage/SDWebImage): For asynchronous image loading and caching.
- [swift-collections](https://github.com/apple/swift-collections): For additional data structures and algorithms. 

## Testing :hammer_and_wrench:

The project includes both UI tests and unit tests to ensure code reliability and maintainability.

### Unit Tests

The unit tests validate individual units of code (e.g., ViewModel methods) in isolation to ensure their correctness. These tests are located in the ECommerceAppTests target. To run the unit tests, follow these steps:

1. Open the Xcode project.
2. Select the ECommerceAppTests target from the target list.
3. Press Cmd + U or click the Play button next to the test class to run the unit tests.

### UI Tests

The UI tests cover essential user flows and interactions within the app. These tests are located in the ECommerceAppUITests target. To run the UI tests, follow these steps:

1. Open the Xcode project.
2. Select the ECommerceAppUITests target from the target list.
3. Choose a simulator or a connected iOS device.
4. Click the Play button or press Cmd + U to run the UI tests.

## API

https://dummyjson.com/

## Screen Recording

https://github.com/oguzhankaymak/E-CommerceApp/assets/36153454/fabeae0f-0cd7-44fd-812c-e7b1fd4d78ba

## Acknowledgments

Special thanks to the following resources that helped in building this project:

[Coordinator Pattern](https://betterprogramming.pub/leverage-the-coordinator-design-pattern-in-swift-5-cd5bb9e78e12)

[Perfect UserDefaults](https://swiftsenpai.com/swift/create-the-perfect-userdefaults-wrapper-using-property-wrapper/)

[Skeleton Loader Shimmer Effect](https://www.youtube.com/watch?v=gO3HeYcQCqw)

Thanks to OpenAI for providing the GPT-3.5 language model that assisted in creating this README.

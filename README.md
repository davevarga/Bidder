Presentation Video URL: [Alkalmazásfejlesztés - 20cmprocastinationstation - YouTube](https://youtu.be/_E4OrEoyThM)

# Bidder Desktop Application

Welcome to the Bidder desktop application! This client-server based application allows users to explore and bid on items seamlessly. With the Browse tab, users can view item recommendations, subscribe to items for notifications about new bids and availability, and manage their subscriptions through the Watchlist tab. 

<img title="" src="file:///C:/Users/david/AppData/Roaming/marktext/images/2024-07-22-15-17-33-image.png" alt="" width="468" data-align="center">

Users can also place bids on items, track the status of their bids, and publish their own items for bidding, which will be visible to other users. All the published bids are easily tracked in the user's profile.

## Client Side Overview

The Bidder application employs a thick client approach, ensuring smooth and responsive user experience by downloading items from the server in advance. Integrity checks are performed on both the server and client sides to ensure data consistency. The user interface is crafted using QML within the Qt framework, leveraging Qt's native signals and slots mechanism for efficient data referencing across multiple views. Resource files are included using qrc, providing a cohesive and well-integrated UI.

## Server Side Insight

On the server side, the application is powered by Kotlin and Spring Boot, utilizing Spring Data for variable definition and Java Persistence API for data storage. To enhance server efficiency, scheduled tasks are implemented. The server also handles the email notification system, ensuring that users stay informed about their subscriptions and bids.

## Testing and Diagnostics

The application underwent rigorous testing, including both unit tests and manual tests, necessitating a comprehensive logging system. Additionally, the server includes a diagnostic system that runs at startup to ensure everything is functioning correctly and efficiently.

## Development and Contributors

The Bidder desktop application was developed as an assignment for the Budapest University of Engineering and Economics by a dedicated team of three: Csiszár Alex (backend), Smuk Ferenc (testing), and Varga David (frontend). You can watch the presentation video for more insights: [Bidder Presentation](https://youtu.be/_E4OrEoyThM).

We hope you find the Bidder application useful and enjoy using it as much as we enjoyed developing it!



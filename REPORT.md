# MP Report

## Team

- Name(s): Aditya Shivkant Niture
- AID(s): A20521495

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all that apply):
  - [ ] iOS simulator / MacOS
  - [X] Android emulator
- [X] There are at least 3 separate screens/pages in the app
- [X] There is at least one stateful widget in the app, backed by a custom model class using a form of state management
- [X] Some user-updateable data is persisted across application launches
- [X] Some application data is accessed from an external source and displayed in the app
- [X] There are at least 5 distinct unit tests, 5 widget tests, and 1 integration test group included in the project

## Questionnaire

Answer the following questions, briefly, so that we can better evaluate your work on this machine problem.

1. What does your app do?

   The app fetches news articles from various sources based on user preferences like country, category, and keywords. You can browse through the latest headlines, bookmark articles you like, and read them in detail within the app.


2. What external data source(s) did you use? What form do they take (e.g., RESTful API, cloud-based database, etc.)?


   The app uses the News API (specifically https://newsapi.org) to fetch news data. It's a RESTful API that provides JSON-formatted news articles from different publishers worldwide.

3. What additional third-party packages or libraries did you use, if any? Why?


   The app uses the News API (specifically https://newsapi.org) to fetch news data. It's a RESTful API that provides JSON-formatted news articles from different publishers worldwide.

4. What form of local data persistence did you use?

   
   We opted for shared_preferences for local data persistence. It's lightweight and perfect for storing simple data like bookmarked article URLs. This ensures that users can access their bookmarks even when offline or across different sessions.

5. What workflow is tested by your integration test?


   The integration test focuses on verifying the functionality of fetching news articles based on different criteria such as country, category, and keyword search. It ensures that the app correctly loads and displays news data from the News API, handles different user interactions like selecting filters, and checks that the bookmarking feature works as expected.

## Summary and Reflection

Integration of the News API to fetch and display news based on user preferences like country, category, and keyword searches. It uses cached_network_image for smooth image loading and caching, which makes scrolling through news articles feel seamless. The google_fonts package gives the app a clean, modern look by making it easy to use stylish fonts. For storing bookmarks, shared_preferences is used, allowing users to save articles they like and access them later, even if they close and reopen the app. One of the cool features is the in-app WebView for reading full articles without leaving the app. Overall, it's a user-friendly news app with a good mix of features and smooth performance. 
But I ran into some issues connecting the external data sources and handling local data persistence. Getting the News API to fetch the articles was a bit tricky, especially making sure the right data showed up for different filters like country and category. There were also hiccups with the shared_preferences package when saving and loading bookmarks—it didn't always store the data correctly. Plus, I had a hard time getting the in-app WebView to load some articles smoothly. Overall, these bugs made it a challenge to create a seamless experience for users.


Working on this app was a mixed bag of fun and challenges. I really enjoyed playing around with the google_fonts and cached_network_image packages—they made the app look great and run smoothly. But, some parts were pretty frustrating, like getting the News API to play nice with all the filters and making sure bookmarks were saved correctly with shared_preferences. I also struggled with setting up the WebView to display articles without any glitches. If I had known how tricky these parts would be, I might have planned differently or chosen other tools. Still, it was a great learning experience and definitely a good challenge!

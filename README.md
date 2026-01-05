
# CS 310 Group Project - SUboxd

---

## Description
Choosing the right courses at Sabancı University often involves uncertainty. While flexibility in course selection is valuable, official course descriptions rarely reflect the real student experience such as instructor style, workload, and overall satisfaction.

Inspired by Letterboxd, a popular platform for reviewing movies, our project brings a similar concept to the academic world.  
We are developing a mobile application that allows students to rate, review, and share feedback on courses and instructors in one centralized, community driven space.  

The goal is to make course selection transparent, informed, and social turning academic feedback into a shared, engaging experience.

Students can:

•⁠  ⁠Log and review their completed or ongoing courses  
•⁠  ⁠Follow friends to explore their experiences  
•⁠  ⁠Discover trending and highly-rated classes  
•⁠  ⁠Build a personal “course diary” documenting their academic journey  

By promoting knowledge sharing and community interaction, the platform transforms course selection into a more enjoyable and collaborative process.

---
## Team Members

| Student ID | Name                | Role                | 
|-------------|--------------------|--------------------|
| 32411       | Safiye Narman      | Project Coordinator |
| 32160       | Pırıl Deniz Zorlutuna | Documentation & Submission Lead |
| 32190       | Rabia Örsün        | Testing & Quality Assurance Lead |
| 33770       | Rana Keleş         | Integration & Repository Lead |
| 32523       | Sena Toker         | Presentation & Communication Lead |
| 30601       | Ceren Lale         | Learning & Research Lead |

Note: All of our final working codes are in a folder called "finalcodes"!

Testing
The project includes both Unit Tests and Widget Tests to ensure data integrity and UI consistency. You can run these tests by executing flutter test in your terminal.

Unit Tests
The unit tests, located in course_model_test.dart, verify the core logic of the CourseModel and CourseSession classes. Specifically, these tests ensure that raw data is correctly normalized, such as converting lowercase days to capitalized formats (e.g., "monday" to "Monday") and fixing time separators (e.g., "14.30" to "14:30"). Additionally, the tests validate the fromDoc factory method to ensure that full course documents, including instructor details and session lists, are correctly parsed into usable Dart objects.

Widget Tests
The widget tests, found in widget_test.dart, focus on the visual reliability of the user interface. The primary test validates the TestCourseCard component by injecting it into a test environment and checking for the presence of an Image widget. It further confirms that the widget is loading the correct asset by verifying that the internal AssetImage path matches the expected testImagePath provided during initialization.

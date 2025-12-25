Smart Workout and Diet Recommendation System
Overview

This project is a comprehensive fitness and nutrition application developed as a Major Project requirement for the Bachelor of Software Engineering at Pokhara University. The system provides personalized exercise routines and dietary guidance tailored specifically to the Nepali context.

By integrating recommendation algorithms and structured user data (age, weight, BMI, and activity levels), the application aims to bridge the gap between generic fitness apps and the specific nutritional habits of Nepali users.

Key Features

    Personalized Workout Plans: Generates muscle-group-specific exercise routines inspired by the MuscleWiki approach, including demonstration guidance to ensure proper form.

Culturally Relevant Diet Planning: Provides nutritional guidance and portion sizes specifically for commonly consumed Nepali foods and affordable local protein sources like eggs, chicken, curd, and lentils.

Progress Tracking: Allows users to monitor their fitness journey over time, evaluating improvements and adjusting recommendations accordingly.

BMI-Based Assessment: Calculates and utilizes Body Mass Index as a foundational metric for tailoring fitness goals.

Tech Stack
Frontend

    Framework: Flutter (Dart) 

State Management: Provider

    Architecture: Clean Architecture (Domain-Driven Design)

Backend & Database

    Logic & API: Django REST Framework 

Data Storage: Firebase (User data, workout details, and progress history)

Tools: TensorFlow/Keras for recommendation logic

Project Architecture

The Flutter application follows a Clean Architecture pattern to ensure scalability, maintainability, and testability.


lib/
├── core/           # Shared utilities and theme configurations
├── data/           # Models, repositories implementation, and data sources
├── domain/         # Business logic (Entities and Repository interfaces)
├── presentation/   # UI layer (Screens, Widgets, and State Providers)
└── main.dart       # Application entry pointGetting Started
Prerequisites

    Flutter SDK (Stable channel)

    Android Studio / VS Code

    Android Emulator or a physical device

Installation

    Clone the repository:
    Bash


Navigate to the project directory:
Bash

cd smart-workout-diet-system

Install dependencies:
Bash

flutter pub get

Run the application:
Bash

    flutter run

Android Studio Setup

    Open the project folder in Android Studio.

    Ensure the Dart and Flutter plugins are installed.

    The project uses IndexedStack in MainScreen to manage bottom navigation state efficiently without rebuilding screens unnecessarily.


Note: This project is developed at the Nepal College of Information Technology (NCIT), Department of Software Engineering.
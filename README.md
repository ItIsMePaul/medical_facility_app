# Medical Facility Management System

A console-based application for managing medical facilities built with Dart and Firebase Realtime Database.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technologies](#technologies)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## 🏥 Overview

The Medical Facility Management System is a console application designed to help manage medical facilities efficiently. It provides functionality to add, update, delete, and view medical facilities, as well as generate various reports based on bed availability and occupancy rates.

## ✨ Features

### Core Functionality
- **Add Medical Facilities**: Create new facility records with validation
- **View Facilities**: Display all facilities in a formatted table
- **Update Facilities**: Modify existing facility information
- **Delete Facilities**: Remove facilities with confirmation
- **Generate Reports**: Create filtered and sorted reports

### Advanced Features
- **Data Validation**: Comprehensive input validation for all fields
- **Uniqueness Checks**: Prevent duplicate facility name+address combinations
- **Occupancy Calculation**: Automatic calculation of bed occupancy percentages
- **Flexible Reporting**: Filter by available beds, occupancy range, or sort by various criteria
- **Error Handling**: Robust error handling for network and data issues

### User Experience
- **Interactive Console Interface**: Clean, user-friendly menu system
- **Input Validation**: Real-time validation with helpful error messages
- **Cancellation Support**: Cancel operations at any time with "cancel" command
- **Cross-platform**: Works on Windows, macOS, and Linux

## 🛠 Technologies

- **Language**: Dart 3.0+
- **Database**: Firebase Realtime Database
- **State Management**: Riverpod 2.0
- **Code Generation**: Freezed, JSON Serializable
- **Testing**: Dart Test, Mockito
- **Architecture**: Clean Architecture with Repository Pattern

## 📋 Prerequisites

Before running this application, make sure you have:

- [Dart SDK](https://dart.dev/get-dart) (3.0 or higher)
- [Firebase Account](https://firebase.google.com/)
- Internet connection for Firebase operations

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/medical_facility_app.git
   cd medical_facility_app
   ```

2. **Install dependencies**
   ```bash
   dart pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build
   ```

## ⚙️ Configuration

### Firebase Setup

1. **Create a Firebase project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Realtime Database

2. **Configure Database Rules**
   ```json
   {
     "rules": {
       ".read": true,
       ".write": true
     }
   }
   ```
   > ⚠️ **Note**: These rules are for development only. Use more restrictive rules in production.

3. **Create environment file**
   Create a `.env` file in the project root:
   ```env
   FIREBASE_API_KEY=your_api_key_here
   FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
   FIREBASE_DATABASE_URL=https://your_project-default-rtdb.firebaseio.com/
   FIREBASE_PROJECT_ID=your_project_id
   FIREBASE_STORAGE_BUCKET=your_project.appspot.com
   FIREBASE_APP_ID=1:123456789:web:abcdef123456
   MESSAGING_SENDER_ID=123456789
   ```

4. **Add .env to .gitignore**
   ```gitignore
   .env
   *.env
   ```

## 🎮 Usage

### Running the Application

```bash
dart run bin/main.dart
```

### Main Menu Options

1. **Add new facility** - Create a new medical facility
2. **Update facility** - Modify existing facility data
3. **Delete facility** - Remove a facility from the database
4. **List all facilities** - View all facilities in a table
5. **Generate report** - Create custom reports
6. **Exit** - Close the application

### Example Usage

```
========================================
      Medical Facility Management
========================================
MAIN MENU:
1. Add new facility
2. Update facility
3. Delete facility
4. List all facilities
5. Generate report
6. Exit
========================================

Please enter your choice (1-6): 1

Please enter the name of the facility, (type "cancel" to abort):
City Hospital

Please enter the address of the facility, (type "cancel" to abort):
123 Main Street

Please enter the total number of beds (must be a positive integer):, (type "cancel" to abort):
100

Please enter the total number of available beds (out of 100, must be a positive integer or zero):, (type "cancel" to abort):
25

Facility City Hospital was saved!
```

### Report Generation

The application supports three types of reports:

1. **Available Beds Report**: Filter facilities by minimum available beds
2. **Occupancy Report**: Filter facilities by occupancy percentage range
3. **Sorted Report**: Sort facilities by name, address, total beds, available beds, or occupancy

## 📁 Project Structure

```
medical_facility_app/
├── bin/
│   └── main.dart                 # Application entry point
├── lib/
│   └── src/
│       ├── cli/                  # Console interface modules
│       │   ├── main_menu.dart
│       │   ├── add_facility_module.dart
│       │   ├── update_facility_module.dart
│       │   ├── delete_facility_module.dart
│       │   ├── list_facilities_module.dart
│       │   └── generate_report_module.dart
│       ├── config/               # Configuration files
│       │   └── firebase_config.dart
│       ├── entities/             # Data models
│       │   └── facility.dart
│       ├── providers/            # Riverpod providers
│       │   ├── firebase_provider.dart
│       │   ├── repository_provider.dart
│       │   ├── validation_provider.dart
│       │   └── report_provider.dart
│       ├── repository/           # Data access layer
│       │   ├── facilities_repository.dart
│       │   └── firebase_facilities_repository.dart
│       ├── services/             # Business logic
│       │   ├── validation_service.dart
│       │   ├── validation_service_interface.dart
│       │   ├── report_service.dart
│       │   └── report_service_interface.dart
│       └── utils/                # Utility classes
│           ├── table_formatter.dart
│           └── uuid_generator.dart
├── test/                         # Test files
│   └── medical_facility_test.dart
├── .env                          # Environment variables
├── .gitignore
├── pubspec.yaml
└── README.md
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
dart test

# Run specific test file
dart test test/medical_facility_test.dart

# Run tests with coverage
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
```

### Test Coverage

The application includes 25 comprehensive test cases covering:

- ✅ CRUD operations (32% of tests)
- ✅ Data validation (28% of tests)
- ✅ Report generation (12% of tests)
- ✅ Error handling (16% of tests)
- ✅ User interface (12% of tests)

**Overall functional coverage: 100%**

### Test Categories

- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test component interactions
- **Functional Tests**: Test complete user scenarios

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Dart style guidelines
- Write tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Troubleshooting

### Common Issues

**Permission Denied Error**
```
Error: [database/permission_denied] null
```
**Solution**: Check Firebase Database Rules and ensure they allow read/write access.

**Environment Variables Not Found**
```
[dotenv] Load failed: file not found: File: '.env'
```
**Solution**: Create `.env` file in project root with Firebase configuration.

### Getting Help

- Check the [Issues](https://github.com/yourusername/medical_facility_app/issues) page
- Create a new issue with detailed description
- Include error messages and steps to reproduce

## 🙏 Acknowledgments

- Firebase team for excellent documentation
- Dart community for helpful packages
- Riverpod team for state management solution

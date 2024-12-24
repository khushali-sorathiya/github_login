
## Overview
This project is an iOS application built with **SwiftUI** to list and view the details of GitHub repositories for an authenticated user. It demonstrates key features like authentication, API integration, offline support, and pagination using a clean MVVM architecture.

---

## Features

### 1. GitHub OAuth Authentication
- Secure login using GitHub's OAuth 2.0.

### 2. Fetch and Display Repositories
- Lists user repositories with details:
  - **Name**
  - **Description**
  - **Stars**
  - **Forks**
  - **Last Updated Date**
- Handles infinite scrolling with API pagination.

### 3. Search and Filter
- Search repositories by name.

### 4. Offline Support
- Stores repository data using Core Data for offline access.

### 5. Architecture
- Implements **MVVM (Model-View-ViewModel)** for a scalable and maintainable codebase.

---

## Requirements
- **iOS**: 15.0+
- **Xcode**: 14.0+
- **Swift**: 5.6+

---

## Usage

1. Launch the app and log in with your GitHub account.
2. View the list of your open repositories.
3. Use the search bar to find repositories by name or filter by starred status.
4. Access previously fetched repositories offline when the network is unavailable.

---

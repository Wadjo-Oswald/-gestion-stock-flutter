# 📦 WandaStock

### Mobile Inventory Management Application

> **Manage your stock. Sell better.**

WandaStock is a mobile inventory management application designed to simplify the daily management of products, sales, and stock replenishment.

The application was developed with **Flutter** and **Firebase** to provide a modern, simple, and accessible solution for small businesses and retailers.

---

## 📱 About the Project

Inventory management is an important part of any retail business. However, many small business owners still use notebooks, paper records, or manual calculations to track their products and sales.

These methods can lead to:

* ❌ Calculation errors
* ❌ Forgotten transactions
* ❌ Product losses
* ❌ Stock shortages
* ❌ Poor visibility into sales
* ❌ Time-consuming operations
* ❌ Difficulties analyzing business performance

**WandaStock** provides a digital alternative that centralizes these operations in a single mobile application.

---

# 🎯 Project Objectives

The main objective of WandaStock is to allow business owners to manage their inventory in a **simple, fast, and reliable way**.

The application aims to:

* Manage products
* Track available stock
* Record sales
* Manage stock replenishment
* View sales history
* Analyze business statistics
* Work when the Internet connection is unavailable
* Synchronize data with Firebase
* Provide French and English interfaces
* Secure user access and data

---

# ✨ Features

## 🔐 Authentication

WandaStock uses **Firebase Authentication** to manage access to the application.

Users can:

* Create an account
* Sign in
* Access their workspace
* Sign out

---

## 📦 Product Management

Users can manage their product inventory directly from the application.

### Add a Product

Users can enter the information required for a product, such as:

* Product name
* Quantity
* Price
* Description
* Image, when applicable

### Edit a Product

Product information can be modified after creation.

The editing functionality also allows the user to manage operations related to **stock replenishment**.

### Delete a Product

Products that are no longer needed can be deleted from the inventory.

---

## 💰 Sales Management

WandaStock allows users to record completed sales.

When a product is sold, the available quantity is updated accordingly.

Sales can then be viewed in the sales history.

---

## 🔄 Stock Replenishment

When new products arrive, users can increase the available quantity of an existing product.

This allows the inventory information to remain up to date after receiving new stock.

---

## 📜 Sales History

The application provides a history of recorded sales.

This makes it easier for users to:

* Review previous transactions
* Track business activity
* Check sold products
* Monitor sales over time

---

## 📊 Dashboard

The dashboard provides an overview of the business activity.

It can display information related to:

* Products
* Inventory
* Sales
* Business performance
* Statistics

---

## 🌍 Multilingual Support

WandaStock supports multiple languages.

### Available Languages

* 🇫🇷 French
* 🇬🇧 English

Users can change the application language directly from the interface.

---

## 📴 Offline Support

One of WandaStock's important features is the ability to continue working when the Internet connection is temporarily unavailable.

The project uses **Cloud Firestore's offline capabilities** to support local data access and synchronization.

General workflow:

```text
              APPLICATION
                   │
                   ▼
             Local Data
                   │
          ┌────────┴────────┐
          │                 │
      Offline           Online
          │                 │
          │                 ▼
          │              Firebase
          │                 │
          └──────► Synchronization
```

This approach is particularly useful in areas where Internet connectivity may be unstable.

---

## 🖨️ PDF and Printing

The project includes support for generating documents and printing them through Flutter packages dedicated to **PDF generation and printing**.

This functionality can be used to generate documents related to inventory and business operations.

---

# 🛠️ Technologies Used

| Technology                  | Purpose                           |
| --------------------------- | --------------------------------- |
| **Flutter**                 | Mobile application development    |
| **Dart**                    | Programming language              |
| **Firebase**                | Backend infrastructure            |
| **Cloud Firestore**         | NoSQL database                    |
| **Firebase Authentication** | User authentication               |
| **Firebase Storage**        | File and image storage            |
| **Provider**                | State management                  |
| **Shared Preferences**      | Local preferences                 |
| **Connectivity Plus**       | Network connectivity detection    |
| **Flutter Localizations**   | Internationalization              |
| **URL Launcher**            | Opening links and contact methods |
| **PDF**                     | PDF document generation           |
| **Printing**                | Document printing                 |

---

# 🏗️ Application Architecture

WandaStock mainly uses Flutter for the mobile application and Firebase for backend services.

```text
┌──────────────────────────────┐
│           USER               │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       FLUTTER APPLICATION    │
│                              │
│  • Authentication            │
│  • Products                  │
│  • Sales                     │
│  • Stock Replenishment       │
│  • Dashboard                 │
│  • Sales History             │
│  • Settings                  │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│           FIREBASE           │
│                              │
│  Firebase Authentication     │
│  Cloud Firestore             │
│  Firebase Storage             │
└──────────────────────────────┘
```

---

# 🗄️ Database

WandaStock uses **Cloud Firestore**, a NoSQL database provided by Firebase.

The application's data is organized into collections and documents.

## 👤 Users

The users collection contains information required for account and user management.

Example:

```text
users
 └── userId
      ├── enterpriseName
      ├── role
      └── isBlocked
```

---

## 📦 Products

Products are one of the main types of data handled by the application.

Conceptual example:

```text
products
 └── productId
      ├── name
      ├── price
      ├── quantity
      ├── description
      └── image
```

---

## 💰 Sales

Sales records contain information about transactions performed by the user.

Conceptual example:

```text
sales
 └── saleId
      ├── productId
      ├── productName
      ├── quantity
      ├── price
      └── date
```

---

## 🔄 Stock Replenishments

Stock replenishment records make it possible to track increases in available product quantities.

Conceptual example:

```text
restocks
 └── restockId
      ├── productId
      ├── oldQuantity
      ├── newQuantity
      └── date
```

> Collection and field names should be verified against the current source code before being considered definitive.

---

# 📐 System Modeling

The WandaStock system can be represented using several software modeling techniques.

### Data Models

* **CDM** — Conceptual Data Model
* **LDM** — Logical Data Model
* Data dictionary

### UML Diagrams

* Use Case Diagram
* Class Diagram
* Sequence Diagram
* Activity Diagram
* Component Diagram
* Deployment Diagram

These models help describe the system's requirements, data structure, behavior, and architecture.

---

# 📂 Project Structure

The general Flutter project structure is organized around the `lib` directory.

```text
wandastock/
│
├── android/
├── ios/
├── lib/
│   │
│   ├── main.dart
│   │
│   ├── home_page.dart
│   ├── product_page.dart
│   ├── sales_history.dart
│   ├── dashboard_page.dart
│   ├── reapprovisionnements_page.dart
│   ├── about_page.dart
│   │
│   ├── generated/
│   │   └── app_localizations.dart
│   │
│   └── ...
│
├── assets/
├── test/
│
├── pubspec.yaml
├── firebase.json
├── .gitignore
└── README.md
```

---

# 🚀 Installation

## Prerequisites

Before running WandaStock, make sure you have installed:

* [Flutter SDK](https://flutter.dev/)
* Dart SDK
* Android Studio
* Android SDK
* Git

Check your Flutter installation:

```bash
flutter doctor
```

---

## 📥 Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/wandastock.git
```

Then:

```bash
cd wandastock
```

---

## 📦 Install Dependencies

```bash
flutter pub get
```

---

# 🔥 Firebase Configuration

WandaStock uses Firebase for several backend services.

Main services include:

* Firebase Authentication
* Cloud Firestore
* Firebase Storage

To configure the project with your own Firebase project, use FlutterFire CLI:

```bash
flutterfire configure
```

The application must then be connected to the appropriate Firebase project.

---

# ▶️ Run the Application

Check the available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

---

# 🧪 Testing

Flutter tests can be executed with:

```bash
flutter test
```

It is also recommended to test the application on a physical Android device.

Important features to test include:

* Authentication
* Product creation
* Product editing
* Product deletion
* Sales
* Stock replenishment
* Sales history
* Dashboard
* Language switching
* Offline mode
* Data synchronization

---

# 📦 Build the Android Application

## Debug APK

To generate a development APK:

```bash
flutter build apk --debug
```

## Release APK

To generate a release APK:

```bash
flutter build apk --release
```

## Google Play

To generate an Android App Bundle:

```bash
flutter build appbundle --release
```

---

# 🔐 Security

Sensitive project information must never be committed to GitHub.

In particular, avoid publishing:

```text
*.jks
*.keystore
key.properties
```

You should also never publish:

* Passwords
* Private keys
* API secrets
* Firebase credentials that should remain private
* Other confidential configuration files

Make sure your `.gitignore` is properly configured before pushing the project.

---

# ⚙️ Project Configuration

Before publishing the repository, verify:

* Firebase configuration
* Firestore security rules
* Android permissions
* Android package configuration
* Application signing configuration
* Sensitive configuration files
* Production Firebase settings

---

# 🗺️ Roadmap

### Core Features

* [x] User authentication
* [x] Product management
* [x] Product editing
* [x] Product deletion
* [x] Sales management
* [x] Stock replenishment
* [x] Sales history
* [x] Dashboard

### User Experience

* [x] Mobile interface
* [x] French language
* [x] English language
* [x] Network status detection
* [x] Offline support
* [x] About page

### Future Features

* [ ] Low-stock notifications
* [ ] Barcode scanning
* [ ] Supplier management
* [ ] Customer management
* [ ] Excel export
* [ ] Advanced PDF reports
* [ ] Advanced user roles
* [ ] Multi-store management
* [ ] Web version
* [ ] iOS version
* [ ] Advanced analytics
* [ ] Stock demand forecasting

---

# 📸 Screenshots

Application screenshots can be added here to showcase the user interface.

Recommended structure:

```text
docs/
├── login.png
├── home.png
├── products.png
├── sales.png
├── dashboard.png
└── about.png
```

Then display them in the README:

```markdown
![Login Screen](docs/login.png)
```

---

# 🎓 Academic Project

WandaStock is also an academic project developed as part of a **Software Engineering** program.

The project applies several concepts acquired during the training, including:

* Requirements analysis
* Software design
* UML modeling
* Database design
* Dart programming
* Flutter development
* Mobile application development
* Backend integration
* Authentication
* Data management
* Testing
* Application deployment

---

# 🔮 Future Perspectives

WandaStock can evolve into a more complete business management solution.

### Supplier Management

Allow business owners to register suppliers and track their purchases and replenishments.

### Low-Stock Alerts

Automatically notify users when a product reaches a critical stock level.

### Barcode Scanning

Allow products to be identified quickly using the smartphone camera.

### Multi-User Management

Allow business owners to create accounts for employees with different access levels.

### Multi-Store Management

Allow users managing multiple stores to monitor their different points of sale from a single account.

### Advanced Analytics

Provide more detailed charts and indicators to help business owners make better decisions.

---

# 🤝 Contributing

Contributions and suggestions are welcome.

Create a new feature branch:

```bash
git checkout -b feature/new-feature
```

After making your changes:

```bash
git add .
git commit -m "Add new feature"
git push origin feature/new-feature
```

A Pull Request can then be created.

---

# 📄 License

WandaStock is currently a personal and academic project.

The conditions for reuse, modification, and distribution may be defined in the future.

---

# 👨‍💻 Author

### Wadjo Junior

**Software Engineering Student**

Project: **WandaStock**

> **Manage your stock. Sell better.**

---

## ⭐ Acknowledgements

Thank you to everyone who contributed directly or indirectly to the design and development of WandaStock.

If you find this project interesting, feel free to ⭐ **star the repository**.

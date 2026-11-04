# Online Quiz Application

A Java web application for creating, publishing, and attempting timed multiple-choice quizzes. It uses Jakarta Servlets, JSP, Maven, and XML files for lightweight persistence.

## Features

- Admin dashboard for quiz, question, user, and submission management
- Draft/publish workflow for quizzes
- Configurable quiz and per-question time limits
- Automatic submission when a timer expires
- Student score summaries, attempt history, and question-by-question explanations
- Role-based access control for admin and student routes
- No database setup required for local development

## Technology Stack

- Java 11+
- Jakarta Servlet 5 and JSP
- Apache Tomcat 10.1+
- Maven
- XML DOM/Transformer APIs
- HTML, CSS, and JavaScript

## Project Layout

```text
JavaQuizApp/
├── pom.xml
├── build.bat
├── build.ps1
└── src/main/
    ├── java/com/quiz/       # Models, servlets, filters, and utilities
    ├── resources/data/      # Seed XML data
    └── webapp/              # JSP views, CSS, JavaScript, and web.xml
```

## Prerequisites

1. JDK 11 or newer
2. Apache Tomcat 10.1 or newer
3. Apache Maven (only required when rebuilding from source)

Confirm Java is available:

```cmd
java -version
```

## Quick Start

The repository includes a ready-to-deploy `JavaQuizApp.war` file, so Maven is not required for normal use.

1. Install Apache Tomcat 10.1 or newer.
2. Copy `JavaQuizApp.war` into Tomcat's `webapps` folder.
3. Start Tomcat with `bin\startup.bat`.
4. Open `http://localhost:8080/JavaQuizApp/`.

On Windows, you can also place Tomcat under the repository's `tomcat` folder and run `start.bat`.

## Build

From the project directory:

```cmd
cd JavaQuizApp
mvn clean package
```

The deployable file is created at `JavaQuizApp\target\JavaQuizApp.war`. Copy it to the repository root if you want to use `start.bat`.

Windows convenience scripts are also available:

```cmd
cd JavaQuizApp
build.bat
```

## Run Locally

Copy `JavaQuizApp.war` to Tomcat's `webapps` directory, start Tomcat, and open:

```text
http://localhost:8080/JavaQuizApp/
```

From the repository root, `start.bat` can deploy the WAR and start the bundled local Tomcat installation when one is present. Use `stop.bat` to send the shutdown signal.

## Demo Accounts

The seed data includes these local demonstration accounts:

| Role | Username | Password |
| --- | --- | --- |
| Admin | `admin` | `admin123` |
| Student | `student1` | `student123` |

Change or remove these accounts before using the application outside local development. User data is stored in XML and is intended for demonstration and learning purposes.

## Data Storage

Seed data is stored under `JavaQuizApp/src/main/resources/data/`. At runtime, the application uses XML files for users, quizzes, and attempts. This keeps setup simple, but a production deployment should use a database and secure password hashing.

## Project Report

The accompanying project report is available here: [Online Quiz Application Project Report](Online_Quiz_Application_Project_Report.pdf).

## License

No license has been selected for this project yet. Add a license before accepting external contributions or redistributing the code.

# 🎓 Online Quiz Application (Java, Servlets, JSP & XML)

A web-based quiz and examination management system built with **Java Servlets**, **JSP (JavaServer Pages)**, and **XML** for lightweight data persistence (no SQL database configuration required).

---

## 🌟 Key Features

### 🛡️ Admin Portal (`/admin/dashboard`)
- **Quiz Management (Full CRUD)**:
  - Create, view, edit, and delete quizzes.
  - Set **Total Quiz Time Limit** (e.g. 5 minutes, 10 minutes, or unlimited).
  - Set **Per-Question Time Limit** and passing score threshold.
  - One-click **Publish / Draft Toggle** (only published quizzes show on student dashboards).
- **Question Management (Full CRUD)**:
  - Add, edit, or delete questions inside each quiz.
  - Configure question statement, mark weightage (e.g. 10 marks), per-question timer.
  - 4 multiple choice options (A, B, C, D) with interactive radio button to select the correct answer.
  - Detailed **Answer Explanation** field so students can review the theory and solution.
- **Student Submissions & Score Tracking**:
  - View all quiz attempts from all registered students.
  - Filter submissions by quiz title.
  - Deep-dive into any attempt: view exact student answers, right vs wrong breakdown, time spent, and percentage.
- **User Management**:
  - View all registered student and admin accounts with deletion controls.

---

### 🎓 Student Portal (`/student/dashboard`)
- **Interactive Dashboard**:
  - View **every quiz published by the instructor** in real-time.
  - Summary stats: Completed Quizzes, Passed Quizzes, Average Score, Highest Score.
  - Quiz cards showing question counts, total marks, time limit, and current status (*New*, *Passed*, *Failed*).
- **Taking the Quiz**:
  - Clean, distraction-free examination view.
  - **Live Countdown Timer** with automatic warning when under 60 seconds.
  - **Automatic submission** when the timer expires.
  - Click anywhere on an option card to select it.
- **Detailed Result & Performance Analysis**:
  - Overall status banner (**Passed** / **Failed**), percentage, and marks earned.
  - Breakdown counters: **Correct**, **Wrong**, **Skipped**, and **Time Spent**.
  - **Question-by-Question Review**:
    - Marks earned on each question.
    - Student's selected answer with green checkmark (if correct) or red cross (if wrong).
    - Highlights the actual correct option.
    - Displays the instructor's **Solution Explanation** for continuous learning.
- **Attempt History**:
  - Accessible via `/student/history` to review past performance anytime.

---

## 📂 XML Data Storage (`WEB-INF/data/`)

All data is managed and persisted using standard Java DOM (`DocumentBuilder`) and Transformer APIs:

1. **`users.xml`**: User accounts (username, password, email, role `ADMIN`/`STUDENT`, fullName, createdAt).
2. **`quizzes.xml`**: Quizzes with embedded questions, options (a, b, c, d), correct option markers, time limits, and explanations.
3. **`attempts.xml`**: Student quiz submission records containing individual question attempts, chosen answers, correct answers, time taken, marks, percentage, and pass/fail status.

---

## 🔑 Default Login Credentials

| Role | Username | Password | Purpose |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` | Create & manage quizzes, questions, timing, and review all submissions |
| **Student** | `student1` | `student123` | View available quizzes, take exams, and review scores & solutions |

*(New student accounts can also be created via the **Register** link on the login page)*

---

## 🚀 How to Run and Deploy

### Option 1: Deploy with Apache Tomcat (Recommended)
1. Download [Apache Tomcat 10 or 10.1](https://tomcat.apache.org/download-10.cgi) (supporting Jakarta EE / Servlet 5.0+).
2. Copy the generated `target\JavaQuizApp.war` into Tomcat's `webapps\` directory:
   ```cmd
   copy "JavaQuizApp\target\JavaQuizApp.war" "C:\path\to\apache-tomcat-10.1.x\webapps\"
   ```
3. Start Tomcat by executing `bin\startup.bat`.
4. Open your browser and navigate to:
   ```
   http://localhost:8080/JavaQuizApp/
   ```

### Option 2: Rebuilding the WAR File
To recompile and repackage the project anytime, run either:
- **Windows Command Prompt**:
  ```cmd
  cd JavaQuizApp
  build.bat
  ```
- **PowerShell**:
  ```powershell
  cd JavaQuizApp
  .\build.ps1
  ```
- **Maven**:
  ```cmd
  mvn clean package
  ```

---

## 🏗️ Architecture & Project Structure

```
JavaQuizApp/
├── pom.xml                               # Maven project definition
├── build.bat                             # 1-click batch build script
├── build.ps1                             # 1-click PowerShell build script
├── src/
│   ├── main/
│   │   ├── java/com/quiz/
│   │   │   ├── filter/
│   │   │   │   └── AuthFilter.java       # Role-based route guard (/admin/* & /student/*)
│   │   │   ├── model/
│   │   │   │   ├── User.java             # Admin and Student model
│   │   │   │   ├── Quiz.java             # Quiz configuration with timer settings
│   │   │   │   ├── Question.java         # MCQ question model with timeLimit & marks
│   │   │   │   ├── Option.java           # Option model with text and correct flag
│   │   │   │   └── QuizAttempt.java      # Attempt model with score and question analysis
│   │   │   ├── servlet/
│   │   │   │   ├── AuthServlet.java          # Login, Register, Logout
│   │   │   │   ├── AdminDashboardServlet.java# Admin statistics & recent submissions
│   │   │   │   ├── AdminQuizServlet.java     # Quiz CRUD & publish toggle
│   │   │   │   ├── AdminQuestionServlet.java # Question CRUD & options/timing setup
│   │   │   │   ├── AdminAttemptServlet.java  # Student submission analysis
│   │   │   │   ├── AdminUserServlet.java     # User account management
│   │   │   │   ├── StudentDashboardServlet.java # Student home & available quizzes
│   │   │   │   ├── StudentQuizServlet.java   # Quiz attempt, live timer, and auto-submit
│   │   │   │   └── StudentHistoryServlet.java# Student attempt history
│   │   │   └── util/
│   │   │       ├── AppContextListener.java   # Auto-seeds default XML files on boot
│   │   │       ├── XMLHelper.java            # DOM/Transformer XML CRUD operations
│   │   │       └── SessionUtil.java          # Session management & user roles
│   │   └── webapp/
│   │       ├── index.jsp                 # Smart redirect based on login role
│   │       ├── css/
│   │       │   └── style.css             # Modern styling, responsive cards & badges
│   │       ├── js/
│   │       │   └── quiz-timer.js         # Countdown timer & auto-submission handler
│   │       └── WEB-INF/
│   │           ├── web.xml               # Web application deployment descriptor
│   │           ├── data/                 # XML data files (users, quizzes, attempts)
│   │           │   ├── users.xml
│   │           │   ├── quizzes.xml
│   │           │   └── attempts.xml
│   │           └── jsp/
│   │               ├── login.jsp
│   │               ├── register.jsp
│   │               ├── admin/            # Admin JSP views
│   │               │   ├── dashboard.jsp
│   │               │   ├── quizzes.jsp
│   │               │   ├── quiz-edit.jsp
│   │               │   ├── questions.jsp
│   │               │   ├── question-edit.jsp
│   │               │   ├── attempts.jsp
│   │               │   ├── attempt-detail.jsp
│   │               │   ├── users.jsp
│   │               │   ├── header.jsp
│   │               │   └── footer.jsp
│   │               └── student/          # Student JSP views
│   │                   ├── dashboard.jsp
│   │                   ├── quiz-attempt.jsp
│   │                   ├── quiz-result.jsp
│   │                   ├── history.jsp
│   │                   ├── header.jsp
│   │                   └── footer.jsp
└── target/
    └── JavaQuizApp.war                   # Ready-to-deploy WAR package
```


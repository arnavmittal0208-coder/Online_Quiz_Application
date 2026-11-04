package com.quiz.util;

import com.quiz.model.*;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.util.*;

/**
 * Utility class for reading and writing XML data files.
 * All data is stored in XML files in the WEB-INF/data directory.
 */
public class XMLHelper {

    // ==================== USER OPERATIONS ====================

    public static List<User> getAllUsers(String dataPath) throws Exception {
        List<User> users = new ArrayList<>();
        File f = new File(dataPath + "/users.xml");
        if (!f.exists()) return users;

        Document doc = parseXML(f);
        NodeList nodeList = doc.getElementsByTagName("user");
        for (int i = 0; i < nodeList.getLength(); i++) {
            users.add(parseUser((Element) nodeList.item(i)));
        }
        return users;
    }

    public static User getUserByUsername(String dataPath, String username) throws Exception {
        List<User> users = getAllUsers(dataPath);
        return users.stream()
                .filter(u -> u.getUsername().equals(username))
                .findFirst().orElse(null);
    }

    public static User authenticateUser(String dataPath, String username, String password) throws Exception {
        User u = getUserByUsername(dataPath, username);
        if (u != null && u.getPassword().equals(password)) return u;
        return null;
    }

    public static void saveUser(String dataPath, User user) throws Exception {
        File f = new File(dataPath + "/users.xml");
        Document doc = f.exists() ? parseXML(f) : createNewDoc("users");
        Element root = doc.getDocumentElement();

        // Check if update
        NodeList existing = root.getElementsByTagName("user");
        for (int i = 0; i < existing.getLength(); i++) {
            Element el = (Element) existing.item(i);
            if (getText(el, "id").equals(String.valueOf(user.getId()))) {
                root.removeChild(el);
                break;
            }
        }

        root.appendChild(buildUserElement(doc, user));
        writeXML(doc, f);
    }

    public static int getNextUserId(String dataPath) throws Exception {
        List<User> users = getAllUsers(dataPath);
        return users.stream().mapToInt(User::getId).max().orElse(0) + 1;
    }

    public static void deleteUser(String dataPath, int userId) throws Exception {
        File f = new File(dataPath + "/users.xml");
        if (!f.exists()) return;
        Document doc = parseXML(f);
        Element root = doc.getDocumentElement();
        NodeList nodes = root.getElementsByTagName("user");
        for (int i = 0; i < nodes.getLength(); i++) {
            Element el = (Element) nodes.item(i);
            if (getText(el, "id").equals(String.valueOf(userId))) {
                root.removeChild(el);
                break;
            }
        }
        writeXML(doc, f);
    }

    // ==================== QUIZ OPERATIONS ====================

    public static List<Quiz> getAllQuizzes(String dataPath) throws Exception {
        List<Quiz> quizzes = new ArrayList<>();
        File f = new File(dataPath + "/quizzes.xml");
        if (!f.exists()) return quizzes;

        Document doc = parseXML(f);
        NodeList nodeList = doc.getElementsByTagName("quiz");
        for (int i = 0; i < nodeList.getLength(); i++) {
            quizzes.add(parseQuiz((Element) nodeList.item(i)));
        }
        return quizzes;
    }

    public static List<Quiz> getPublishedQuizzes(String dataPath) throws Exception {
        List<Quiz> all = getAllQuizzes(dataPath);
        List<Quiz> published = new ArrayList<>();
        for (Quiz q : all) {
            if (q.isPublished()) published.add(q);
        }
        return published;
    }

    public static Quiz getQuizById(String dataPath, int id) throws Exception {
        return getAllQuizzes(dataPath).stream()
                .filter(q -> q.getId() == id)
                .findFirst().orElse(null);
    }

    public static void saveQuiz(String dataPath, Quiz quiz) throws Exception {
        File f = new File(dataPath + "/quizzes.xml");
        Document doc = f.exists() ? parseXML(f) : createNewDoc("quizzes");
        Element root = doc.getDocumentElement();

        NodeList existing = root.getElementsByTagName("quiz");
        for (int i = 0; i < existing.getLength(); i++) {
            Element el = (Element) existing.item(i);
            if (getText(el, "id").equals(String.valueOf(quiz.getId()))) {
                root.removeChild(el);
                break;
            }
        }

        root.appendChild(buildQuizElement(doc, quiz));
        writeXML(doc, f);
    }

    public static int getNextQuizId(String dataPath) throws Exception {
        List<Quiz> quizzes = getAllQuizzes(dataPath);
        return quizzes.stream().mapToInt(Quiz::getId).max().orElse(0) + 1;
    }

    public static void deleteQuiz(String dataPath, int quizId) throws Exception {
        File f = new File(dataPath + "/quizzes.xml");
        if (!f.exists()) return;
        Document doc = parseXML(f);
        Element root = doc.getDocumentElement();
        NodeList nodes = root.getElementsByTagName("quiz");
        for (int i = 0; i < nodes.getLength(); i++) {
            Element el = (Element) nodes.item(i);
            if (getText(el, "id").equals(String.valueOf(quizId))) {
                root.removeChild(el);
                break;
            }
        }
        writeXML(doc, f);
    }

    // ==================== ATTEMPT OPERATIONS ====================

    public static List<QuizAttempt> getAllAttempts(String dataPath) throws Exception {
        List<QuizAttempt> attempts = new ArrayList<>();
        File f = new File(dataPath + "/attempts.xml");
        if (!f.exists()) return attempts;
        String content = readFileContent(f);
        if (content.trim().equals("<?xml version=\"1.0\" encoding=\"UTF-8\"?><attempts></attempts>") ||
            content.trim().equals("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<attempts>\n</attempts>") ||
            content.contains("<attempts/>") || content.contains("<attempts>\n</attempts>") ||
            content.contains("<attempts></attempts>")) {
            return attempts;
        }
        Document doc = parseXML(f);
        NodeList nodeList = doc.getElementsByTagName("attempt");
        for (int i = 0; i < nodeList.getLength(); i++) {
            attempts.add(parseAttempt((Element) nodeList.item(i)));
        }
        return attempts;
    }

    public static List<QuizAttempt> getAttemptsByUser(String dataPath, String username) throws Exception {
        List<QuizAttempt> all = getAllAttempts(dataPath);
        List<QuizAttempt> result = new ArrayList<>();
        for (QuizAttempt a : all) {
            if (a.getUsername().equals(username)) result.add(a);
        }
        return result;
    }

    public static List<QuizAttempt> getAttemptsByQuiz(String dataPath, int quizId) throws Exception {
        List<QuizAttempt> all = getAllAttempts(dataPath);
        List<QuizAttempt> result = new ArrayList<>();
        for (QuizAttempt a : all) {
            if (a.getQuizId() == quizId) result.add(a);
        }
        return result;
    }

    public static QuizAttempt getAttemptById(String dataPath, String attemptId) throws Exception {
        return getAllAttempts(dataPath).stream()
                .filter(a -> a.getId().equals(attemptId))
                .findFirst().orElse(null);
    }

    public static void saveAttempt(String dataPath, QuizAttempt attempt) throws Exception {
        File f = new File(dataPath + "/attempts.xml");
        Document doc;
        if (!f.exists() || f.length() == 0) {
            doc = createNewDoc("attempts");
        } else {
            try {
                doc = parseXML(f);
            } catch (Exception e) {
                doc = createNewDoc("attempts");
            }
        }
        Element root = doc.getDocumentElement();

        // Remove existing if update
        NodeList existing = root.getElementsByTagName("attempt");
        for (int i = 0; i < existing.getLength(); i++) {
            Element el = (Element) existing.item(i);
            if (getText(el, "id").equals(attempt.getId())) {
                root.removeChild(el);
                break;
            }
        }

        root.appendChild(buildAttemptElement(doc, attempt));
        writeXML(doc, f);
    }

    public static boolean hasAttempted(String dataPath, String username, int quizId) throws Exception {
        return getAttemptsByUser(dataPath, username).stream()
                .anyMatch(a -> a.getQuizId() == quizId);
    }

    // ==================== XML PARSING HELPERS ====================

    private static User parseUser(Element el) {
        User u = new User();
        u.setId(Integer.parseInt(getText(el, "id")));
        u.setUsername(getText(el, "username"));
        u.setPassword(getText(el, "password"));
        u.setEmail(getText(el, "email"));
        u.setRole(getText(el, "role"));
        u.setFullName(getText(el, "fullName"));
        u.setCreatedAt(getText(el, "createdAt"));
        return u;
    }

    private static Quiz parseQuiz(Element el) {
        Quiz q = new Quiz();
        q.setId(Integer.parseInt(getText(el, "id")));
        q.setTitle(getText(el, "title"));
        q.setDescription(getText(el, "description"));
        q.setCategory(getText(el, "category"));
        q.setTotalTimeLimit(parseInt(getText(el, "totalTimeLimit"), 0));
        q.setTimePerQuestion(parseInt(getText(el, "timePerQuestion"), 0));
        q.setPublished(Boolean.parseBoolean(getText(el, "published")));
        q.setCreatedBy(getText(el, "createdBy"));
        q.setCreatedAt(getText(el, "createdAt"));
        q.setPassingScore(parseInt(getText(el, "passingScore"), 60));

        List<Question> questions = new ArrayList<>();
        Element questionsEl = (Element) el.getElementsByTagName("questions").item(0);
        if (questionsEl != null) {
            NodeList qNodes = questionsEl.getElementsByTagName("question");
            for (int i = 0; i < qNodes.getLength(); i++) {
                questions.add(parseQuestion((Element) qNodes.item(i)));
            }
        }
        q.setQuestions(questions);
        return q;
    }

    private static Question parseQuestion(Element el) {
        Question q = new Question();
        q.setId(parseInt(getText(el, "id"), 0));
        q.setText(getText(el, "text"));
        q.setType(getText(el, "type"));
        q.setMarks(parseInt(getText(el, "marks"), 10));
        q.setTimeLimit(parseInt(getText(el, "timeLimit"), 0));
        q.setExplanation(getText(el, "explanation"));

        List<Option> options = new ArrayList<>();
        Element optionsEl = (Element) el.getElementsByTagName("options").item(0);
        if (optionsEl != null) {
            NodeList oNodes = optionsEl.getElementsByTagName("option");
            for (int i = 0; i < oNodes.getLength(); i++) {
                Element oEl = (Element) oNodes.item(i);
                Option opt = new Option();
                opt.setId(oEl.getAttribute("id"));
                opt.setCorrect(Boolean.parseBoolean(oEl.getAttribute("correct")));
                opt.setText(oEl.getTextContent().trim());
                options.add(opt);
            }
        }
        q.setOptions(options);
        return q;
    }

    private static QuizAttempt parseAttempt(Element el) {
        QuizAttempt a = new QuizAttempt();
        a.setId(getText(el, "id"));
        a.setQuizId(parseInt(getText(el, "quizId"), 0));
        a.setQuizTitle(getText(el, "quizTitle"));
        a.setUsername(getText(el, "username"));
        a.setStudentName(getText(el, "studentName"));
        a.setStartedAt(getText(el, "startedAt"));
        a.setCompletedAt(getText(el, "completedAt"));
        a.setTimeTaken(parseInt(getText(el, "timeTaken"), 0));
        a.setTotalMarks(parseInt(getText(el, "totalMarks"), 0));
        a.setObtainedMarks(parseInt(getText(el, "obtainedMarks"), 0));
        a.setPercentage(parseDouble(getText(el, "percentage"), 0.0));
        a.setPassed(Boolean.parseBoolean(getText(el, "passed")));

        List<QuizAttempt.QuestionAttempt> qAttempts = new ArrayList<>();
        Element qas = (Element) el.getElementsByTagName("questionAttempts").item(0);
        if (qas != null) {
            NodeList qaNodes = qas.getElementsByTagName("questionAttempt");
            for (int i = 0; i < qaNodes.getLength(); i++) {
                Element qaEl = (Element) qaNodes.item(i);
                QuizAttempt.QuestionAttempt qa = new QuizAttempt.QuestionAttempt();
                qa.setQuestionId(parseInt(getText(qaEl, "questionId"), 0));
                qa.setQuestionText(getText(qaEl, "questionText"));
                qa.setSelectedOption(getText(qaEl, "selectedOption"));
                qa.setCorrectOption(getText(qaEl, "correctOption"));
                qa.setCorrect(Boolean.parseBoolean(getText(qaEl, "correct")));
                qa.setMarksObtained(parseInt(getText(qaEl, "marksObtained"), 0));
                qa.setMaxMarks(parseInt(getText(qaEl, "maxMarks"), 0));
                qAttempts.add(qa);
            }
        }
        a.setQuestionAttempts(qAttempts);
        return a;
    }

    // ==================== XML BUILDING HELPERS ====================

    private static Element buildUserElement(Document doc, User u) {
        Element el = doc.createElement("user");
        addChild(doc, el, "id", String.valueOf(u.getId()));
        addChild(doc, el, "username", u.getUsername());
        addChild(doc, el, "password", u.getPassword());
        addChild(doc, el, "email", u.getEmail());
        addChild(doc, el, "role", u.getRole());
        addChild(doc, el, "fullName", u.getFullName());
        addChild(doc, el, "createdAt", u.getCreatedAt());
        return el;
    }

    private static Element buildQuizElement(Document doc, Quiz quiz) {
        Element el = doc.createElement("quiz");
        addChild(doc, el, "id", String.valueOf(quiz.getId()));
        addChild(doc, el, "title", quiz.getTitle());
        addChild(doc, el, "description", quiz.getDescription());
        addChild(doc, el, "category", quiz.getCategory());
        addChild(doc, el, "totalTimeLimit", String.valueOf(quiz.getTotalTimeLimit()));
        addChild(doc, el, "timePerQuestion", String.valueOf(quiz.getTimePerQuestion()));
        addChild(doc, el, "published", String.valueOf(quiz.isPublished()));
        addChild(doc, el, "createdBy", quiz.getCreatedBy());
        addChild(doc, el, "createdAt", quiz.getCreatedAt());
        addChild(doc, el, "passingScore", String.valueOf(quiz.getPassingScore()));

        Element questionsEl = doc.createElement("questions");
        if (quiz.getQuestions() != null) {
            for (Question q : quiz.getQuestions()) {
                questionsEl.appendChild(buildQuestionElement(doc, q));
            }
        }
        el.appendChild(questionsEl);
        return el;
    }

    private static Element buildQuestionElement(Document doc, Question q) {
        Element el = doc.createElement("question");
        addChild(doc, el, "id", String.valueOf(q.getId()));
        addChild(doc, el, "text", q.getText());
        addChild(doc, el, "type", q.getType());
        addChild(doc, el, "marks", String.valueOf(q.getMarks()));
        addChild(doc, el, "timeLimit", String.valueOf(q.getTimeLimit()));
        addChild(doc, el, "explanation", q.getExplanation() != null ? q.getExplanation() : "");

        Element optionsEl = doc.createElement("options");
        if (q.getOptions() != null) {
            for (Option opt : q.getOptions()) {
                Element oEl = doc.createElement("option");
                oEl.setAttribute("id", opt.getId());
                oEl.setAttribute("correct", String.valueOf(opt.isCorrect()));
                oEl.setTextContent(opt.getText());
                optionsEl.appendChild(oEl);
            }
        }
        el.appendChild(optionsEl);
        return el;
    }

    private static Element buildAttemptElement(Document doc, QuizAttempt a) {
        Element el = doc.createElement("attempt");
        addChild(doc, el, "id", a.getId());
        addChild(doc, el, "quizId", String.valueOf(a.getQuizId()));
        addChild(doc, el, "quizTitle", a.getQuizTitle());
        addChild(doc, el, "username", a.getUsername());
        addChild(doc, el, "studentName", a.getStudentName() != null ? a.getStudentName() : "");
        addChild(doc, el, "startedAt", a.getStartedAt() != null ? a.getStartedAt() : "");
        addChild(doc, el, "completedAt", a.getCompletedAt() != null ? a.getCompletedAt() : "");
        addChild(doc, el, "timeTaken", String.valueOf(a.getTimeTaken()));
        addChild(doc, el, "totalMarks", String.valueOf(a.getTotalMarks()));
        addChild(doc, el, "obtainedMarks", String.valueOf(a.getObtainedMarks()));
        addChild(doc, el, "percentage", String.valueOf(a.getPercentage()));
        addChild(doc, el, "passed", String.valueOf(a.isPassed()));

        Element qas = doc.createElement("questionAttempts");
        if (a.getQuestionAttempts() != null) {
            for (QuizAttempt.QuestionAttempt qa : a.getQuestionAttempts()) {
                Element qaEl = doc.createElement("questionAttempt");
                addChild(doc, qaEl, "questionId", String.valueOf(qa.getQuestionId()));
                addChild(doc, qaEl, "questionText", qa.getQuestionText() != null ? qa.getQuestionText() : "");
                addChild(doc, qaEl, "selectedOption", qa.getSelectedOption() != null ? qa.getSelectedOption() : "");
                addChild(doc, qaEl, "correctOption", qa.getCorrectOption() != null ? qa.getCorrectOption() : "");
                addChild(doc, qaEl, "correct", String.valueOf(qa.isCorrect()));
                addChild(doc, qaEl, "marksObtained", String.valueOf(qa.getMarksObtained()));
                addChild(doc, qaEl, "maxMarks", String.valueOf(qa.getMaxMarks()));
                qas.appendChild(qaEl);
            }
        }
        el.appendChild(qas);
        return el;
    }

    // ==================== LOW-LEVEL XML HELPERS ====================

    private static Document parseXML(File f) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false);
        DocumentBuilder builder = factory.newDocumentBuilder();
        return builder.parse(f);
    }

    private static Document createNewDoc(String rootTag) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.newDocument();
        doc.appendChild(doc.createElement(rootTag));
        return doc;
    }

    private static void writeXML(Document doc, File f) throws Exception {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer t = tf.newTransformer();
        t.setOutputProperty(OutputKeys.INDENT, "yes");
        t.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        t.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
        t.transform(new DOMSource(doc), new StreamResult(new FileOutputStream(f)));
    }

    private static void addChild(Document doc, Element parent, String tag, String text) {
        Element child = doc.createElement(tag);
        child.setTextContent(text);
        parent.appendChild(child);
    }

    private static String getText(Element parent, String tag) {
        NodeList nl = parent.getElementsByTagName(tag);
        if (nl.getLength() == 0) return "";
        return nl.item(0).getTextContent().trim();
    }

    private static int parseInt(String val, int def) {
        try { return Integer.parseInt(val); } catch (Exception e) { return def; }
    }

    private static double parseDouble(String val, double def) {
        try { return Double.parseDouble(val); } catch (Exception e) { return def; }
    }

    private static String readFileContent(File f) throws Exception {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(f))) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line).append("\n");
        }
        return sb.toString();
    }
}


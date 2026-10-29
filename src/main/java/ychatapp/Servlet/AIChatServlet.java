package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import ychatapp.model.bo.GeminiService;

@WebServlet({"/aiChat", "/AIChatServlet"})
public class AIChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        processRequest(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        processRequest(req, res);
    }

    private void processRequest(HttpServletRequest req, HttpServletResponse res) throws IOException {
        req.setCharacterEncoding("UTF-8");
        res.setContentType("application/json;charset=UTF-8");

        String action = req.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = req.getParameter("type");
        }

        JsonObject responseObj = new JsonObject();

        try {
            if ("smart_replies".equalsIgnoreCase(action)) {
                String text = req.getParameter("text");
                if (text == null || text.trim().isEmpty()) {
                    text = req.getParameter("message");
                }

                if (text == null || text.trim().isEmpty()) {
                    responseObj.addProperty("success", false);
                    responseObj.addProperty("error", "Message text is required");
                } else {
                    String prompt = "You are an intelligent auto-reply assistant for a chat messaging app. Given the following message received by the user: \"" 
                            + text.trim() 
                            + "\", generate exactly 3 short, natural, and helpful reply suggestions (chips).\n"
                            + "Rules:\n"
                            + "- Each reply MUST be very concise (1 to 4 words maximum).\n"
                            + "- Match the language of the message (if Bengali or Banglish, reply in fluent Bengali such as 'ঠিক আছে', 'পরে জানাচ্ছি', 'ধন্যবাদ!'; if English, reply in natural English).\n"
                            + "- Return STRICTLY a raw JSON array of 3 string items, e.g.: [\"Option 1\", \"Option 2\", \"Option 3\"].\n"
                            + "- Do not include markdown blocks, code blocks, extra text, or explanations.";

                    String aiResult = GeminiService.generateResponse(prompt);
                    JsonArray repliesArray = parseRepliesJson(aiResult, text);

                    responseObj.addProperty("success", true);
                    responseObj.add("replies", repliesArray);
                }
            } else if ("summarize".equalsIgnoreCase(action)) {
                String conversation = req.getParameter("conversation");
                if (conversation == null || conversation.trim().isEmpty()) {
                    conversation = req.getParameter("text");
                }

                if (conversation == null || conversation.trim().isEmpty()) {
                    responseObj.addProperty("success", false);
                    responseObj.addProperty("error", "Conversation text is required");
                } else {
                    String prompt = "You are an AI meeting and conversation assistant for Y-ChatApp.\n"
                            + "Summarize the key points, decisions, agreements, and open topics from the following chat conversation.\n"
                            + "Structure the summary cleanly with markdown bullet points (•) and concise headings if necessary.\n"
                            + "Match the primary language used in the chat (Bengali or English).\n\n"
                            + "Conversation transcript:\n" + conversation.trim();

                    String summary = GeminiService.generateResponse(prompt);
                    responseObj.addProperty("success", true);
                    responseObj.addProperty("summary", summary);
                }
            } else if ("translate".equalsIgnoreCase(action)) {
                String text = req.getParameter("text");
                String targetLang = req.getParameter("targetLang");
                if (targetLang == null || targetLang.trim().isEmpty()) {
                    targetLang = "auto";
                }

                if (text == null || text.trim().isEmpty()) {
                    responseObj.addProperty("success", false);
                    responseObj.addProperty("error", "Text to translate is required");
                } else {
                    String langInstruction;
                    if ("bn".equalsIgnoreCase(targetLang)) {
                        langInstruction = "Translate the following text into natural, fluent Bengali.";
                    } else if ("en".equalsIgnoreCase(targetLang)) {
                        langInstruction = "Translate the following text into natural, fluent English.";
                    } else {
                        langInstruction = "Detect the language of the following text. If it is English, translate it to natural Bengali. If it is in Bengali or another language, translate it to English.";
                    }

                    String prompt = langInstruction + "\nOutput ONLY the translated text without quotes, markdown backticks, explanations, or notes:\n\n" + text.trim();
                    String translated = GeminiService.generateResponse(prompt);

                    responseObj.addProperty("success", true);
                    responseObj.addProperty("translated", cleanTranslation(translated));
                    responseObj.addProperty("original", text);
                }
            } else if ("ask".equalsIgnoreCase(action) || "chat".equalsIgnoreCase(action)) {
                String prompt = req.getParameter("prompt");
                if (prompt == null || prompt.trim().isEmpty()) {
                    prompt = req.getParameter("text");
                }

                if (prompt == null || prompt.trim().isEmpty()) {
                    responseObj.addProperty("success", false);
                    responseObj.addProperty("error", "Prompt is required");
                } else {
                    String answer = GeminiService.generateResponse(prompt);
                    responseObj.addProperty("success", true);
                    responseObj.addProperty("answer", answer);
                }
            } else {
                responseObj.addProperty("success", false);
                responseObj.addProperty("error", "Unknown action: " + action);
            }
        } catch (Exception ex) {
            responseObj.addProperty("success", false);
            responseObj.addProperty("error", "Exception: " + ex.getMessage());
        }

        PrintWriter out = res.getWriter();
        out.print(gson.toJson(responseObj));
    }

    private JsonArray parseRepliesJson(String aiResult, String originalText) {
        JsonArray array = new JsonArray();
        if (aiResult != null && !aiResult.trim().isEmpty()) {
            try {
                int start = aiResult.indexOf('[');
                int end = aiResult.lastIndexOf(']');
                if (start != -1 && end != -1 && end > start) {
                    String jsonSub = aiResult.substring(start, end + 1);
                    JsonArray parsed = JsonParser.parseString(jsonSub).getAsJsonArray();
                    for (int i = 0; i < Math.min(parsed.size(), 3); i++) {
                        String item = parsed.get(i).getAsString().trim();
                        item = item.replaceAll("^[\"']+|[\"']+$", "");
                        if (!item.isEmpty()) {
                            array.add(item);
                        }
                    }
                }
            } catch (Exception ignored) {}

            if (array.isEmpty()) {
                String[] lines = aiResult.split("[\\r\\n|•]+");
                for (String line : lines) {
                    line = line.trim().replaceAll("^[0-9]+[.\\-\\)]\\s*", "").replaceAll("^[\"']+|[\"']+$", "");
                    if (!line.isEmpty() && array.size() < 3) {
                        array.add(line);
                    }
                }
            }
        }

        if (array.isEmpty()) {
            boolean isBengali = originalText != null && originalText.matches(".*[\\u0980-\\u09FF].*");
            if (isBengali) {
                array.add("ঠিক আছে");
                array.add("পরে কথা বলছি");
                array.add("ধন্যবাদ!");
            } else {
                array.add("Sounds good!");
                array.add("I'll check and let you know");
                array.add("Thanks!");
            }
        }

        return array;
    }

    private String cleanTranslation(String text) {
        if (text == null) return "";
        text = text.trim();
        if (text.startsWith("\"") && text.endsWith("\"") && text.length() > 1) {
            text = text.substring(1, text.length() - 1);
        }
        return text.trim();
    }
}

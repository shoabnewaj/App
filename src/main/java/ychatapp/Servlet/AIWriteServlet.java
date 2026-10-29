package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.google.gson.JsonObject;
import ychatapp.model.bo.GeminiService;

@WebServlet({"/aiWrite", "/AIWriteServlet"})
public class AIWriteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json;charset=UTF-8");
        String prompt = req.getParameter("prompt");
        String tone = req.getParameter("tone");
        String lang = req.getParameter("lang");
        String emojis = req.getParameter("emojis");
        String length = req.getParameter("length");
        String type = req.getParameter("type");
        
        JsonObject jsonRes = new JsonObject();
        if (prompt == null || prompt.trim().isEmpty()) {
            jsonRes.addProperty("error", "Prompt is empty");
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } else {
            String finalPrompt;
            if ("translate".equalsIgnoreCase(type)) {
                finalPrompt = "Translate the following text. Detect its language. If it is in English, translate it to Bengali. If it is in Bengali, translate it to English. If it is in any other language, translate it to Bengali. Output ONLY the translation. Do not add quotes, preambles, notes, or markdown wrappers:\n" + prompt;
            } else if ("suggestComments".equalsIgnoreCase(type)) {
                finalPrompt = "Given the following social media post text, generate exactly 3 short, natural, and engaging comment suggestions (1-2 sentences max each). One should be friendly/supportive, one should be curious/a question, and one should be humorous/witty. Return them as a simple list separated by pipe characters (|) without any numbering, quotes, or introductory text. Match the language of the post (e.g., if the post is in Bengali, suggestions must be in Bengali):\n" + prompt;
            } else if ("generateBio".equalsIgnoreCase(type)) {
                StringBuilder sb = new StringBuilder();
                sb.append("Write an engaging and concise social media profile biography/introductory bio based on the following keywords or interests: \"").append(prompt).append("\".\n");
                if (tone != null && !tone.trim().isEmpty()) {
                    sb.append("Tone/Style: ").append(tone).append(".\n");
                }
                if (lang != null && !lang.trim().isEmpty()) {
                    sb.append("Language: ").append(lang).append(".\n");
                }
                sb.append("Constraints:\n");
                sb.append("- Keep it extremely concise and catchy (strictly under 150 characters, max 1-2 sentences).\n");
                sb.append("- Output only the bio text. Do not include quote marks, notes, preambles, or explanations.\n");
                finalPrompt = sb.toString();
            } else {
                StringBuilder sb = new StringBuilder();
                sb.append("Write a social media post/caption about: ").append(prompt).append("\n");
                
                if (tone != null && !tone.trim().isEmpty()) {
                    sb.append("Tone/Style of the post: ").append(tone).append("\n");
                }
                if (lang != null && !lang.trim().isEmpty()) {
                    sb.append("Language of the post: ").append(lang).append("\n");
                }
                if (emojis != null && !emojis.trim().isEmpty()) {
                    if ("true".equalsIgnoreCase(emojis) || "yes".equalsIgnoreCase(emojis)) {
                        sb.append("Include relevant and expressive emojis in the text.\n");
                    } else if ("false".equalsIgnoreCase(emojis) || "no".equalsIgnoreCase(emojis)) {
                        sb.append("Do not include any emojis in the text.\n");
                    }
                }
                if (length != null && !length.trim().isEmpty()) {
                    sb.append("Length: ").append(length).append(".\n");
                }
                sb.append("\nPlease output only the post content itself. Do not include introductory text like 'Here is your post:', explanations, quotation marks around the whole text, or markdown blocks. Just return the raw text to be posted.");
                finalPrompt = sb.toString();
            }
            
            String aiResult = GeminiService.generateResponse(finalPrompt);
            jsonRes.addProperty("content", aiResult);
        }
        
        PrintWriter out = res.getWriter();
        out.print(jsonRes.toString());
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        doGet(req, res);
    }
}

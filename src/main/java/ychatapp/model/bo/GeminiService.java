package ychatapp.model.bo;

import java.io.File;
import java.io.FileInputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

public class GeminiService {
    private static String apiKey = null;
    private static final ExecutorService executor = Executors.newCachedThreadPool();

    static {
        loadConfig();
    }

    public static synchronized void loadConfig() {
        // 1. Try env variable
        apiKey = System.getenv("GEMINI_API_KEY");
        if (apiKey != null && !apiKey.trim().isEmpty()) {
            return;
        }
        
        // 2. Try properties file in classpath
        try (var is = GeminiService.class.getClassLoader().getResourceAsStream("gemini.properties")) {
            if (is != null) {
                Properties props = new Properties();
                props.load(is);
                apiKey = props.getProperty("gemini.api.key");
                if (apiKey != null && !apiKey.trim().isEmpty()) {
                    return;
                }
            }
        } catch (Exception e) {
            System.err.println("Error reading gemini.properties from classpath: " + e.getMessage());
        }
        
        // 3. Try properties file in working directory
        try {
            File propFile = new File("gemini.properties");
            if (propFile.exists()) {
                Properties props = new Properties();
                try (FileInputStream fis = new FileInputStream(propFile)) {
                    props.load(fis);
                    apiKey = props.getProperty("gemini.api.key");
                    if (apiKey != null && !apiKey.trim().isEmpty()) {
                        return;
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error reading gemini.properties from working directory: " + e.getMessage());
        }

        // 4. Try absolute workspace root file (highly reliable in local development)
        String[] absolutePaths = {
            "c:\\pleiades-2025-12-ultimate-win-64bit-jre_20251214\\workspace\\ychatApp\\gemini.properties",
            "c:\\pleiades-2025-12-ultimate-win-64bit-jre_20251214\\workspace\\ychatApp\\src\\main\\resources\\gemini.properties"
        };
        for (String path : absolutePaths) {
            try {
                File propFile = new File(path);
                if (propFile.exists()) {
                    Properties props = new Properties();
                    try (FileInputStream fis = new FileInputStream(propFile)) {
                        props.load(fis);
                        apiKey = props.getProperty("gemini.api.key");
                        if (apiKey != null && !apiKey.trim().isEmpty()) {
                            return;
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("Error reading gemini.properties from absolute path: " + e.getMessage());
            }
        }
    }

    public static String getApiKey() {
        if (apiKey == null || apiKey.trim().isEmpty()) {
            loadConfig();
        }
        return apiKey;
    }

    public static void setApiKey(String key) {
        apiKey = key;
    }

    public static synchronized boolean saveApiKey(String key) {
        if (key == null) return false;
        apiKey = key.trim();
        Properties props = new Properties();
        props.setProperty("gemini.api.key", apiKey);
        
        try {
            // Write to project root working directory
            File propFile = new File("gemini.properties");
            try (java.io.FileOutputStream fos = new java.io.FileOutputStream(propFile)) {
                props.store(fos, "Saved dynamically from Y-Chat AI Dashboard");
            }
            
            // Also write to absolute workspace paths to keep synced
            String[] absolutePaths = {
                "c:\\pleiades-2025-12-ultimate-win-64bit-jre_20251214\\workspace\\ychatApp\\gemini.properties",
                "c:\\pleiades-2025-12-ultimate-win-64bit-jre_20251214\\workspace\\ychatApp\\src\\main\\resources\\gemini.properties"
            };
            for (String path : absolutePaths) {
                try {
                    File absFile = new File(path);
                    try (java.io.FileOutputStream fos = new java.io.FileOutputStream(absFile)) {
                        props.store(fos, "Saved dynamically from Y-Chat AI Dashboard");
                    }
                } catch (Exception ex) {
                    // Ignore, non-critical
                }
            }
            
            System.out.println("Gemini API Key successfully saved and synced.");
            return true;
        } catch (Exception e) {
            System.err.println("Error saving Gemini API Key to properties file: " + e.getMessage());
            return false;
        }
    }

    public static void runAsync(Runnable task) {
        executor.submit(task);
    }

    private static String encodeFileToBase64(File file) throws Exception {
        try (FileInputStream fis = new FileInputStream(file)) {
            byte[] bytes = fis.readAllBytes();
            return java.util.Base64.getEncoder().encodeToString(bytes);
        }
    }

    private static String getMimeType(String fileName) {
        String lower = fileName.toLowerCase();
        if (lower.endsWith(".png")) return "image/png";
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
        if (lower.endsWith(".gif")) return "image/gif";
        if (lower.endsWith(".webp")) return "image/webp";
        return "image/jpeg"; // default
    }

    public static String generateResponse(String prompt) {
        if (apiKey == null || apiKey.trim().isEmpty()) {
            loadConfig();
        }
        if (apiKey == null || apiKey.trim().isEmpty() || apiKey.trim().length() < 10) {
            return "Error: A valid Gemini API Key is not configured. Please get a real API key from Google AI Studio (https://aistudio.google.com/) and configure it in the AI Dashboard or gemini.properties file.";
        }

        // Try to locate image locally if prompt is an uploaded file path
        File imgFile = null;
        if (prompt != null && prompt.startsWith("img/")) {
            String[] pathsToTry = {
                "src/main/webapp/" + prompt,
                "target/classes/../ychatApp/" + prompt,
                "target/ychatApp/" + prompt,
                "build/classes/../ychatApp/" + prompt,
                prompt
            };
            for (String p : pathsToTry) {
                File f = new File(p);
                if (f.exists() && f.isFile()) {
                    imgFile = f;
                    break;
                }
            }
        }

        try {
            HttpClient client = HttpClient.newHttpClient();

            // Build request JSON structure with Gson
            JsonObject requestJson = new JsonObject();
            JsonArray contentsArray = new JsonArray();
            JsonObject contentObject = new JsonObject();
            JsonArray partsArray = new JsonArray();
            
            // Add System Instruction to guide the response language (Support all world languages)
            JsonObject systemInstruction = new JsonObject();
            JsonArray systemParts = new JsonArray();
            JsonObject systemPart = new JsonObject();
            systemPart.addProperty("text", "You are ychat AI, a helpful AI assistant built for Y-ChatApp. You must reply naturally, accurately, and fluently in the exact same language the user is speaking (e.g., English, Bengali, Japanese, Spanish, German, French, Arabic, etc.). Be friendly, polite, and match the language and tone used by the user.");
            systemParts.add(systemPart);
            systemInstruction.add("parts", systemParts);
            requestJson.add("systemInstruction", systemInstruction);
            
            // Text instructions/prompt part
            JsonObject partObject = new JsonObject();
            partObject.addProperty("text", prompt);
            partsArray.add(partObject);

            // If an image is detected, read it and add as inline_data part
            if (imgFile != null) {
                try {
                    String base64Data = encodeFileToBase64(imgFile);
                    String mimeType = getMimeType(imgFile.getName());
                    
                    JsonObject imagePart = new JsonObject();
                    JsonObject inlineData = new JsonObject();
                    inlineData.addProperty("mime_type", mimeType);
                    inlineData.addProperty("data", base64Data);
                    imagePart.add("inline_data", inlineData);
                    
                    partsArray.add(imagePart);
                    
                    // Overwrite prompt to ask Gemini to explain the image
                    partObject.addProperty("text", "Please analyze this image and describe what is in it.");
                } catch (Exception ex) {
                    System.err.println("Error reading or encoding image for Gemini: " + ex.getMessage());
                }
            }

            contentObject.add("parts", partsArray);
            contentsArray.add(contentObject);
            requestJson.add("contents", contentsArray);

            String requestBody = new Gson().toJson(requestJson);

            // Try verified models in sequence to handle high load (503) or rate limits (429)
            String[] models = {
                "gemini-2.5-flash",
                "gemini-3.5-flash",
                "gemini-3.1-flash-lite",
                "gemini-2.5-flash-lite",
                "gemini-2.0-flash"
            };

            String lastError = null;
            for (String model : models) {
                System.out.println("[GeminiService] Attempting to call model: " + model);
                String response = makeHttpCall(client, model, requestBody);
                if (response != null && !response.startsWith("Error")) {
                    System.out.println("[GeminiService] Successfully generated content using model: " + model);
                    return response;
                }
                System.err.println("[WARN] Gemini model " + model + " failed: " + response);
                lastError = response;
            }

            return lastError; // Return the last error if all models fail
        } catch (Exception e) {
            e.printStackTrace();
            return "Exception occurred while calling Gemini: " + e.getMessage();
        }
    }

    private static String makeHttpCall(HttpClient client, String modelName, String requestBody) {
        try {
            String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/" + modelName + ":generateContent?key=" + apiKey;
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(endpoint))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JsonObject responseJson = new Gson().fromJson(response.body(), JsonObject.class);
                JsonArray candidates = responseJson.getAsJsonArray("candidates");
                if (candidates != null && candidates.size() > 0) {
                    JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
                    JsonObject content = firstCandidate.getAsJsonObject("content");
                    if (content != null) {
                        JsonArray parts = content.getAsJsonArray("parts");
                        if (parts != null && parts.size() > 0) {
                            return parts.get(0).getAsJsonObject().get("text").getAsString();
                        }
                    }
                }
                return "Error: Could not parse response content from Gemini API.";
            } else {
                return "Error calling Gemini API: Status Code " + response.statusCode() + "\nDetails: " + response.body();
            }
        } catch (Exception e) {
            return "Error: Exception occurred during HTTP call to " + modelName + ": " + e.getMessage();
        }
    }
}

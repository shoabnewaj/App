package ychatapp.Servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/GifServlet", "/gifSearch"})
public class GifServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Curated high-performance GIFs for instant loading and offline/firewall reliability
    private static final List<GifItem> CURATED_GIFS = new ArrayList<>();

    static {
        CURATED_GIFS.add(new GifItem("Hello Wave", "https://media.giphy.com/media/mG23883W18057CWtxq/giphy.gif", "hello,hi,wave,greeting"));
        CURATED_GIFS.add(new GifItem("Thumbs Up Great Job", "https://media.giphy.com/media/111ebonMs90YLu/giphy.gif", "thumbs up,yes,like,good,ok,approve"));
        CURATED_GIFS.add(new GifItem("Party Celebrate", "https://media.giphy.com/media/artj92V8o75VPL7AeQ/giphy.gif", "party,celebrate,dance,happy,yay,congrats"));
        CURATED_GIFS.add(new GifItem("Heart Love", "https://media.giphy.com/media/26BRv0ThflsDTqqJA/giphy.gif", "love,heart,kiss,romantic,cute"));
        CURATED_GIFS.add(new GifItem("Laughing Out Loud", "https://media.giphy.com/media/ltIFdjNAasOwVvKhvx/giphy.gif", "haha,laugh,lol,funny,joke"));
        CURATED_GIFS.add(new GifItem("Clapping Applause", "https://media.giphy.com/media/nbvFVPiEiJH6JOGIok/giphy.gif", "applause,clap,bravo,congrats,great"));
        CURATED_GIFS.add(new GifItem("Mind Blown", "https://media.giphy.com/media/26ufdipQqU2lhNA4g/giphy.gif", "mind blown,wow,shock,amazing"));
        CURATED_GIFS.add(new GifItem("Cat Vibe Dance", "https://media.giphy.com/media/jpbnoe3UIa8TU8LM13/giphy.gif", "cat,dance,vibe,music,groove"));
        CURATED_GIFS.add(new GifItem("Sad Crying", "https://media.giphy.com/media/L95W4wvxxB1G8/giphy.gif", "sad,cry,tears,sorry,unhappy"));
        CURATED_GIFS.add(new GifItem("Thank You", "https://media.giphy.com/media/3oEdva9BUHPIs2SkGk/giphy.gif", "thank you,thanks,grateful,welcome"));
        CURATED_GIFS.add(new GifItem("Fire Hot", "https://media.giphy.com/media/Lopx9eUi34rbq/giphy.gif", "fire,lit,hot,epic,cool"));
        CURATED_GIFS.add(new GifItem("Agree Nod", "https://media.giphy.com/media/NEvPzZ8bd1V4Y/giphy.gif", "nod,yes,agree,cool,understood"));
        CURATED_GIFS.add(new GifItem("Confused What", "https://media.giphy.com/media/lkdH8FmImcGoylv3o3/giphy.gif", "confused,what,question,huh"));
        CURATED_GIFS.add(new GifItem("Happy Dance", "https://media.giphy.com/media/blSTtZehjAZ8I/giphy.gif", "happy,dance,fun,excited,joy"));
        CURATED_GIFS.add(new GifItem("Cool Sunglasses", "https://media.giphy.com/media/3o7btPCcdNniyf0ArS/giphy.gif", "cool,swag,boss,chill"));
        CURATED_GIFS.add(new GifItem("Sleepy Tired", "https://media.giphy.com/media/NWg7M1VlQAZa0/giphy.gif", "sleep,tired,night,goodnight"));
    }

    public static class GifItem {
        public String title;
        public String url;
        public String tags;

        public GifItem(String title, String url, String tags) {
            this.title = title;
            this.url = url;
            this.tags = tags;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String q = req.getParameter("q");
        List<GifItem> matches = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            String queryLower = q.trim().toLowerCase();
            for (GifItem g : CURATED_GIFS) {
                if (g.title.toLowerCase().contains(queryLower) || g.tags.contains(queryLower)) {
                    matches.add(g);
                }
            }
            // If local search yielded few results, also try Giphy public API
            if (matches.size() < 4) {
                List<GifItem> online = searchGiphyOnline(queryLower);
                if (online != null && !online.isEmpty()) {
                    matches.addAll(online);
                }
            }
        }

        // Default or fallback to curated list
        if (matches.isEmpty()) {
            matches.addAll(CURATED_GIFS);
        }

        StringBuilder sb = new StringBuilder("{\"results\":[");
        for (int i = 0; i < matches.size(); i++) {
            GifItem g = matches.get(i);
            if (i > 0) sb.append(",");
            sb.append("{\"title\":\"").append(g.title.replace("\"", "\\\"")).append("\",")
              .append("\"url\":\"").append(g.url).append("\"}");
        }
        sb.append("]}");

        out.write(sb.toString());
    }

    private List<GifItem> searchGiphyOnline(String query) {
        List<GifItem> list = new ArrayList<>();
        try {
            // Public beta key for Giphy
            String encoded = URLEncoder.encode(query, StandardCharsets.UTF_8);
            String apiUrl = "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=" + encoded + "&limit=10&rating=g";
            URL url = URI.create(apiUrl).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(3000);
            conn.setReadTimeout(3000);
            if (conn.getResponseCode() == 200) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) response.append(line);
                    
                    // Simple fast regex parse for images.fixed_height.url or images.original.url
                    java.util.regex.Pattern p = java.util.regex.Pattern.compile("\"url\"\\s*:\\s*\"(https:[^\"\\\\]+giphy\\.gif)\"");
                    java.util.regex.Matcher m = p.matcher(response.toString());
                    int count = 0;
                    while (m.find() && count < 8) {
                        String gifUrl = m.group(1).replace("\\/", "/");
                        list.add(new GifItem(query + " GIF", gifUrl, query));
                        count++;
                    }
                }
            }
        } catch (Exception e) {
            // Silently fallback to curated
        }
        return list;
    }
}

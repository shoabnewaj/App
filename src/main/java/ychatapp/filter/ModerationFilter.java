package ychatapp.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;

@WebFilter("/*")
public class ModerationFilter implements Filter {

    private static final List<String> BAD_WORDS = Arrays.asList(
        "abuse", "badword", "bitch", "fuck", "shit", "bastard", "idiot"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        chain.doFilter(request, response);
    }

    public static String sanitizeText(String input) {
        if (input == null || input.isEmpty()) return input;
        String clean = input;
        for (String word : BAD_WORDS) {
            String asterisks = "*".repeat(word.length());
            clean = clean.replaceAll("(?i)\\b" + word + "\\b", asterisks);
        }
        return clean;
    }

    @Override
    public void destroy() {}
}

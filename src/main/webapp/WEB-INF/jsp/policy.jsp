<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy & Terms of Service | Y-ChatApp</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    
    <!-- Tailwind CSS & FontAwesome -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #0f172a 100%);
            color: #f8fafc;
            min-height: 100vh;
        }

        .glass-panel {
            background: rgba(30, 41, 59, 0.45);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
        }

        .active-tab {
            background: linear-gradient(135deg, #3b82f6 0%, #6366f1 100%);
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
            color: #ffffff !imp




















































































































                        <p>We reserve the right to suspend, disable, or permanently delete accounts that violate our community guidelines, spread harassment, or perform illegal operations inside the application.</p>
                    </section>

                    <section class="space-y-2">
                        <h3 class="text-base font-bold text-white">3. Disclaimer of Warranties / দায়মুক্তি</h3>
                        <p>YchatApp is provided "as is" and "as available". While we utilize secure SSL layers and WebRTC protocols, we do not warrant that the service will be entirely uninterrupted, error-free, or free from server latency.</p>
                    </section>
                </div>
            </div>
        </div>

        <!-- Footer Back Link -->
        <div class="text-center mt-8">
            <a href="javascript:window.history.back();" class="inline-flex items-center gap-2 text-sm font-bold text-slate-400 hover:text-white transition-colors">
                <i class="fa fa-arrow-left"></i> Go Back
            </a>
        </div>
    </div>

    <script>
        function switchTab(tabId, btn) {
            // Hide all tab contents
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(el => el.style.display = 'none');

            // Show selected tab content
            document.getElementById(tabId).style.display = 'block';

            // Reset tab button states
            const buttons = document.querySelectorAll('.tab-btn');
            buttons.forEach(el => el.classList.remove('active-tab'));

            // Set current active button
            btn.classList.add('active-tab');
        }
    </script>
</body>
</html>

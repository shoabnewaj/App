<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration | Y-Chat</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    
    <!-- Tailwind CSS & FontAwesome -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            font-family: 'Outfit', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.75) !important;
        
        Part part = req.getPart("profile_pic"); // JSP input name
        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

        String user_img = null; // এখানে আপনি user_img নাম দিয়েছেন

        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("/img");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            user_img = System.currentTimeMillis() + "_" + fileName;

            // ✅ ভুল ১: profile_pic এর বদলে user_img হবে
            part.write(uploadPath + File.separator + user_img);
        }

        // ✅ FIXED constructor usage
        UsersBeans ub = new UsersBeans();
        ub.setEmail(email);
        ub.setPass(pass);
        ub.setName(name);
        
        // ✅ ভুল ২: profile_pic এর বদলে user_img হবে
        // ✅ ভুল ৩: Beans ক্লাসে মেথড চেক করুন: setProfile_pic (P বড় হাতের হতে পারে)
        ub.setProfile_pic(user_img); 
        if (birthday != null && !birthday.isEmpty()) ub.setBirthday(birthday);
        if (gender != null && !gender.isEmpty()) ub.setGender(gender); 

        if (UsersLogic.userRegist(req, ub)) {
            req.getRequestDispatcher("/WEB-INF/jsp/registDone.jsp").forward(req, res);
        } else {
            req.setAttribute("error", "Registration Failed");
            req.getRequestDispatcher("/WEB-INF/jsp/regist.jsp").forward(req, res);
        }
    }
}











































            </div>

            <button type="submit" class="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white font-bold py-3.5 rounded-2xl shadow-md hover:shadow-lg active:scale-95 transition-all duration-150 text-sm">
                Create Account
            </button>
        </form>

        <div class="w-full h-[1px] bg-gray-200/60 my-6 relative z-10"></div>

        <a href="UsersLoginServlet" class="block text-center text-sm font-bold text-blue-600 hover:text-blue-700 hover:underline transition-colors relative z-10">
            ← Back to Login
        </a>
    </div>
</div>

<script>
    function previewProfilePic(input) {
        const iconContainer = document.getElementById('upload-icon-container');
        const previewContainer = document.getElementById('preview-container');
        const previewImage = document.getElementById('profile-pic-preview');
        const fileNameText = document.getElementById('file-name-text');
        
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                previewImage.src = e.target.result;
                fileNameText.textContent = input.files[0].name;
                iconContainer.classList.add('hidden');
                previewContainer.classList.remove('hidden');
                previewContainer.classList.add('flex');
            }
            
            reader.readAsDataURL(input.files[0]);
        } else {
            iconContainer.classList.remove('hidden');
            previewContainer.classList.add('hidden');
            previewContainer.classList.remove('flex');
        }
    }
</script>

</body>
</html>
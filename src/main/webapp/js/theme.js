// Theme Toggle Logic
const APP_THEMES = ['light', 'white', 'dark', 'ocean', 'rose', 'forest', 'lavender'];
const APP_THEME_META = {
    light:    { icon: 'fa-sun', color: 'text-amber-500', label: 'Default' },
    white:    { icon: 'fa-circle-half-stroke', color: 'text-slate-700', label: 'White' },
    dark:     { icon: 'fa-moon', color: 'text-yellow-300', label: 'Dark' },
    ocean:    { icon: 'fa-water', color: 'text-cyan-500', label: 'Ocean' },
    rose:     { icon: 'fa-heart', color: 'text-pink-500', label: 'Rose' },
    forest:   { icon: 'fa-leaf', color: 'text-green-600', label: 'Forest' },
    lavender: { icon: 'fa-cloud-moon', color: 'text-violet-500', label: 'Lavender' }
};

function getAppTheme() {
    const saved = localStorage.getItem('theme');
    return APP_THEMES.includes(saved) ? saved : 'light';
}

function applyAppTheme(theme) {
    if (!APP_THEMES.includes(theme)) theme = 'light';
    localStorage.setItem('theme', theme);
    [document.documentElement, document.body].filter(Boolean).forEach(el => {
        el.dataset.theme = theme;
        el.classList.remove(...APP_THEMES.map(name => `theme-${name}`));
        el.classList.add(`theme-${theme}`);
        el.classList.toggle('dark', theme === 'dark');
    });
    updateThemeUI(theme);
}

function toggleThemeMode() {
    const current = getAppTheme();
    const next = APP_THEMES[(APP_THEMES.indexOf(current) + 1) % APP_THEMES.length];
    applyAppTheme(next);
    
    // Satisfying micro-rotation animation on theme toggle icon
    const icons = document.querySelectorAll('#themeToggleIcon, #floatingThemeBtn i');
    icons.forEach(icon => {
        icon.style.transition = 'transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1)';
        icon.style.transform = 'rotate(360deg) scale(1.2)';
        setTimeout(() => {
            icon.style.transform = 'none';
        }, 500);
    });
}

function updateThemeUI(theme) {
    const meta = APP_THEME_META[typeof theme === 'string' ? theme : (theme ? 'dark' : 'light')] || APP_THEME_META.light;
    // Update all theme toggle icons (inline and floating)
    const icons = document.querySelectorAll('#themeToggleIcon');
    icons.forEach(icon => {
        icon.style.transition = 'transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1)';
        icon.className = `fa ${meta.icon} ${meta.color}`;
    });
    
    // Update inline button background
    const btns = document.querySelectorAll('#themeToggleBtn');
    btns.forEach(btn => {
        if (getAppTheme() === 'dark') {
            btn.classList.add('bg-slate-700');
            btn.classList.remove('bg-gray-200', 'bg-gray-100');
        } else {
            btn.classList.remove('bg-slate-700');
            btn.classList.add('bg-gray-200');
        }
    });

    // Update floating button icon color
    const floatBtn = document.getElementById('floatingThemeBtn');
    if (floatBtn) {
        const fi = floatBtn.querySelector('i');
        if (fi) {
            fi.className = `fa ${meta.icon} ${meta.color}`;
        }
    }
    document.querySelectorAll('#themeToggleBtn, #floatingThemeBtn').forEach(btn => {
        btn.title = `Theme: ${meta.label} · click to change`;
        btn.setAttribute('aria-label', `Current theme: ${meta.label}. Click to change theme.`);
    });
    const bgSelect = document.getElementById('ychatBgThemeSelect');
    if (bgSelect && typeof theme === 'string') bgSelect.value = theme;
}

// Check and apply theme immediately (runs BEFORE DOMContentLoaded to prevent raw white flash)
(function() {
    const savedTheme = getAppTheme();
    const isDark = savedTheme === 'dark';
    document.documentElement.dataset.theme = savedTheme;
    document.documentElement.classList.add(`theme-${savedTheme}`);
    
    if (isDark) {
        document.documentElement.classList.add('dark');
        const style = document.createElement('style');
        style.id = 'theme-preload-style';
        style.textContent = `
            html.dark, body.dark { 
                background: linear-gradient(-45deg, #0f172a, #1e1b4b, #311042, #020617) !important;
                background-size: 400% 400% !important;
                color: #e2e8f0 !important; 
            }
        `;
        (document.head || document.documentElement).appendChild(style);
    } else {
        document.documentElement.classList.remove('dark');
    }
    
    const applyDarkOnDom = () => {
        if (isDark) {
            document.body.classList.add('dark');
            document.documentElement.classList.add('dark');
        } else {
            document.body.classList.remove('dark');
            document.documentElement.classList.remove('dark');
        }
        applyAppTheme(savedTheme);
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', applyDarkOnDom);
    } else {
        applyDarkOnDom();
    }
})();

document.addEventListener('DOMContentLoaded', () => {
    // 1. Inject Premium Dark Mode Styles & CSS Animations
    const style = document.createElement('style');
    style.textContent = `
        /* --- KEYFRAMES --- */
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* --- SMOOTH TRANSITION SYSTEM --- */
        body {
            transition: background-color 0.4s ease, color 0.4s ease, border-color 0.4s ease !important;
        }
        .glass-card, .glass-nav, .sidebar, .main-chat, #chatBox, .chat-header, .received, .sent, input, textarea, select {
            transition: background-color 0.4s ease, border-color 0.4s ease, color 0.4s ease, box-shadow 0.4s ease !important;
        }

        /* --- DYNAMIC COSMIC GRADIENT FOR DARK MODE --- */
        html.dark, body.dark {
            background: linear-gradient(-45deg, #0f172a, #1e1b4b, #311042, #020617) !important;
            background-size: 400% 400% !important;
            animation: gradient 15s ease infinite !important;
            color: #e2e8f0 !important;
        }
        
        /* --- SLATE GLOW FOR CARDS & NAV --- */
        .dark .glass-card {
            background: rgba(15, 23, 42, 0.82) !important;
            backdrop-filter: blur(16px) !important;
            -webkit-backdrop-filter: blur(16px) !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.4) !important;
            color: #e2e8f0 !important;
        }
        .dark .glass-card:hover {
            box-shadow: 0 12px 36px 0 rgba(168, 85, 247, 0.2) !important;
            border-color: rgba(168, 85, 247, 0.35) !important;
        }

        .dark .glass-nav {
            background: rgba(15, 23, 42, 0.9) !important;
            backdrop-filter: blur(16px) !important;
            -webkit-backdrop-filter: blur(16px) !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1) !important;
            color: #e2e8f0 !important;
        }

        /* --- TEXT COLORS --- */
        .dark .text-gray-900, .dark .text-gray-800, .dark .text-gray-700, 
        .dark .text-slate-900, .dark .text-slate-800, .dark .text-black,
        .dark h1, .dark h2, .dark h3, .dark h4, .dark h5, .dark h6 {
            color: #f8fafc !important;
        }
        .dark .text-gray-600, .dark .text-gray-500, .dark .text-slate-600, .dark .text-slate-500 {
            color: #cbd5e1 !important;
        }
        .dark .text-gray-400, .dark .text-slate-400 {
            color: #94a3b8 !important;
        }

        /* --- BACKGROUND OVERRIDES --- */
        .dark .bg-white {
            background-color: #1e293b !important;
            color: #f1f5f9 !important;
        }
        .dark .bg-gray-50, .dark .bg-gray-100, .dark .bg-gray-200, 
        .dark .bg-slate-50, .dark .bg-slate-100, .dark .bg-slate-200 {
            background-color: #1e293b !important;
            color: #f1f5f9 !important;
        }
        .dark .border-gray-100, .dark .border-gray-200, .dark .border-gray-300,
        .dark .border-slate-100, .dark .border-slate-200, .dark .border-slate-300 {
            border-color: rgba(255, 255, 255, 0.1) !important;
        }
        .dark a {
            color: #e2e8f0;
        }
        .dark a:hover {
            color: #60a5fa !important;
        }

        /* --- FORMS & INPUTS --- */
        .dark label {
            color: #cbd5e1 !important;
        }
        .dark input[type="text"], .dark input[type="email"], 
        .dark input[type="password"], .dark input[type="search"],
        .dark input[type="number"], .dark textarea, .dark select {
            background-color: #1e293b !important;
            color: #f1f5f9 !important;
            border-color: rgba(255, 255, 255, 0.15) !important;
        }
        .dark select option {
            background-color: #1e293b !important;
            color: #f1f5f9 !important;
        }
        .dark input::placeholder, .dark textarea::placeholder {
            color: #64748b !important;
        }

        /* --- REACTION PICKER & MODALS --- */
        .dark .react-box {
            background: #1e293b !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5) !important;
        }
        .dark .modal {
            background: rgba(0, 0, 0, 0.75) !important;
            backdrop-filter: blur(8px) !important;
        }
        .dark .modal > div, .dark [id*="Modal"] > div {
            background: #1e293b !important;
            color: #e2e8f0 !important;
            border: 1px solid rgba(255, 255, 255, 0.12) !important;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.6) !important;
        }
        .dark .dropdown-menu, .dark [id*="dropdown"], .dark [id*="Menu"], .dark [id*="Results"] {
            background: #1e293b !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: #f1f5f9 !important;
            box-shadow: 0 15px 45px rgba(0, 0, 0, 0.5) !important;
        }

        /* --- SIDEBAR, CARDS & MESSENGER --- */
        .dark .sidebar, .dark aside, .dark header {
            background: #0f172a !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
            color: #e2e8f0 !important;
        }
        .dark .sidebar .logo {
            color: #c084fc !important;
        }
        .dark .sidebar .menu a {
            color: #cbd5e1 !important;
        }
        .dark .sidebar .menu a:hover {
            background: rgba(168, 85, 247, 0.15) !important;
            color: #e9d5ff !important;
        }
        .dark .sidebar div[style*="border-top"] {
            border-top-color: rgba(255, 255, 255, 0.08) !important;
            color: #cbd5e1 !important;
        }

        .dark .card, .dark .card-item {
            background: #1e293b !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
            color: #e2e8f0 !important;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3) !important;
        }
        .dark .card h3 {
            color: #c084fc !important;
        }
        .dark .card .user-item, .dark .user-item {
            border-bottom-color: rgba(255, 255, 255, 0.06) !important;
        }

        .dark .main {
            background: transparent !important;
        }
        .dark .container {
            color: #e2e8f0 !important;
        }

        .dark nav[class*="fixed"], .dark nav[class*="bottom"] {
            background: rgba(15, 23, 42, 0.95) !important;
            border-top-color: rgba(255, 255, 255, 0.08) !important;
        }
        .dark nav[class*="fixed"] a, .dark nav[class*="bottom"] a {
            color: #94a3b8 !important;
        }

        .dark .sidebar-header {
            background: #1e1b4b !important;
        }
        .dark .search-box {
            background: #1e293b !important;
            color: white !important;
        }
        .dark .friend-item:hover {
            background-color: rgba(168, 85, 247, 0.15) !important;
        }
        .dark .friend-item.active {
            background-color: #311042 !important;
        }
        .dark .main-chat {
            background: #0f172a !important;
        }
        .dark #chatBox {
            background: #0b1329 !important;
        }
        .dark .chat-header {
            background: #0f172a !important;
            color: #c084fc !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
        }
        .dark .received {
            background: #1e293b !important;
            color: #f1f5f9 !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
        }
        .dark .sent {
            background: linear-gradient(135deg, #7c3aed, #4f46e5) !important;
            color: #ffffff !important;
        }
        .dark .input-area {
            background: #0f172a !important;
            border-top: 1px solid rgba(255, 255, 255, 0.1) !important;
        }
        .dark .input-area input {
            background: #1e293b !important;
            color: white !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
        }

        .dark table, .dark th, .dark td {
            background-color: #1e293b !important;
            color: #e2e8f0 !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
        }
        .dark table tr:nth-child(even) {
            background-color: #162032 !important;
        }
        .dark table tr:hover {
            background-color: rgba(168, 85, 247, 0.1) !important;
        }

        .dark [id*="comment-section"], .dark [id*="comment-list"] {
            color: #e2e8f0 !important;
        }
        .dark .comment-level-2, .dark .comment-level-3 {
            border-left-color: rgba(255, 255, 255, 0.15) !important;
        }

        /* --- FLOATING THEME TOGGLE BUTTON --- */
        #floatingThemeBtn {
            position: fixed;
            bottom: 90px;
            right: 20px;
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: linear-gradient(135deg, #7c3aed, #4f46e5);
            box-shadow: 0 6px 20px rgba(124, 58, 237, 0.45);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            cursor: pointer;
            z-index: 99999;
            border: 1px solid rgba(255, 255, 255, 0.2);
            font-size: 18px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        #floatingThemeBtn:hover {
            transform: scale(1.12) rotate(15deg);
            box-shadow: 0 10px 28px rgba(124, 58, 237, 0.6);
        }
        #floatingThemeBtn:active {
            transform: scale(0.93);
        }

        .friend-item {
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .friend-item:hover {
            transform: translateX(6px);
        }
        
        @keyframes msgPopIn {
            from { opacity: 0; transform: scale(0.92) translateY(12px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        .msg {
            animation: msgPopIn 0.28s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
        }
    `;
    document.head.appendChild(style);

    // Remove pre-load style fallback once DOM styling is ready
    const preloadStyle = document.getElementById('theme-preload-style');
    if (preloadStyle) preloadStyle.remove();

    // 2. Inject toggle button — either into navbar or as a floating button
    _injectThemeToggleButton();
    _injectAccessibilityTools();
    applyAccessibilityPreferences();
    applyFeedPreferences();

    const theme = getAppTheme();
    applyAppTheme(theme);
    _injectPaletteStyles();

    // Initialize Extra Dynamic Features
    try {
        initInstantSearch();
    } catch(e) { console.error(e); }
    try {
        // initMusicPlayer();
    } catch(e) { console.error(e); }
    try {
        initAudioSelectorAndParser();
        parsePostAudioTags();
    } catch(e) { console.error(e); }
});

function _injectPaletteStyles() {
    if (document.getElementById('app-theme-palette-styles')) return;
    const style = document.createElement('style');
    style.id = 'app-theme-palette-styles';
    style.textContent = `
        html[data-theme="white"], body[data-theme="white"] { --theme-bg: #ffffff; --theme-surface:#ffffff; --theme-nav:#ffffff; --theme-ink:#0f172a; --theme-accent:#2563eb; }
        html[data-theme="white"] body, body[data-theme="white"] {
            background: #ffffff !important;
            background-image: none !important;
            animation: none !important;
            color: #0f172a !important;
        }
        html[data-theme="white"] .glass-card, body[data-theme="white"] .glass-card,
        html[data-theme="white"] .sidebar, body[data-theme="white"] .sidebar {
            background: #ffffff !important;
            border: 1px solid #e2e8f0 !important;
            box-shadow: 0 2px 12px rgba(15, 23, 42, 0.06) !important;
            color: #0f172a !important;
        }
        html[data-theme="white"] .glass-nav, body[data-theme="white"] .glass-nav,
        html[data-theme="white"] .chat-header, body[data-theme="white"] .chat-header,
        html[data-theme="white"] .input-area, body[data-theme="white"] .input-area,
        html[data-theme="white"] .main-chat, body[data-theme="white"] .main-chat {
            background: #ffffff !important;
            border-bottom: 1px solid #e2e8f0 !important;
            color: #0f172a !important;
        }
        html[data-theme="white"] #chatBox, body[data-theme="white"] #chatBox { background: #f8fafc !important; }
        html[data-theme="white"] .sidebar-header, body[data-theme="white"] .sidebar-header { background: linear-gradient(135deg,#2563eb,#3b82f6) !important; }
        html[data-theme="white"] .friend-item.active, body[data-theme="white"] .friend-item.active { background: #eff6ff !important; border-left-color: #2563eb !important; }
        html[data-theme="ocean"], body[data-theme="ocean"] { --theme-bg: linear-gradient(135deg,#d9f7ff,#9bdcf0 48%,#73b8e8); --theme-surface:rgba(229,248,255,.88); --theme-nav:rgba(222,247,255,.94); --theme-ink:#12384d; --theme-accent:#087ea4; }
        html[data-theme="rose"], body[data-theme="rose"] { --theme-bg: linear-gradient(135deg,#fff0f5,#fbcfe8 48%,#f9a8d4); --theme-surface:rgba(255,241,247,.9); --theme-nav:rgba(255,239,246,.96); --theme-ink:#53233b; --theme-accent:#db2777; }
        html[data-theme="forest"], body[data-theme="forest"] { --theme-bg: linear-gradient(135deg,#e6f4df,#b8d9ad 48%,#88bd92); --theme-surface:rgba(240,249,235,.91); --theme-nav:rgba(239,249,235,.96); --theme-ink:#233d2a; --theme-accent:#367548; }
        html[data-theme="lavender"], body[data-theme="lavender"] { --theme-bg: linear-gradient(135deg,#f4edff,#d9c8fa 48%,#b7a0ec); --theme-surface:rgba(249,245,255,.91); --theme-nav:rgba(247,242,255,.96); --theme-ink:#382657; --theme-accent:#7951b8; }

        html[data-theme="ocean"] body, body[data-theme="ocean"],
        html[data-theme="rose"] body, body[data-theme="rose"],
        html[data-theme="forest"] body, body[data-theme="forest"],
        html[data-theme="lavender"] body, body[data-theme="lavender"] {
            background:var(--theme-bg) fixed !important; background-size:cover !important; color:var(--theme-ink) !important;
        }
        html[data-theme="ocean"] .glass-card, body[data-theme="ocean"] .glass-card,
        html[data-theme="rose"] .glass-card, body[data-theme="rose"] .glass-card,
        html[data-theme="forest"] .glass-card, body[data-theme="forest"] .glass-card,
        html[data-theme="lavender"] .glass-card, body[data-theme="lavender"] .glass-card,
        html[data-theme="ocean"] .sidebar, body[data-theme="ocean"] .sidebar,
        html[data-theme="rose"] .sidebar, body[data-theme="rose"] .sidebar,
        html[data-theme="forest"] .sidebar, body[data-theme="forest"] .sidebar,
        html[data-theme="lavender"] .sidebar, body[data-theme="lavender"] .sidebar {
            background:var(--theme-surface) !important; color:var(--theme-ink) !important; backdrop-filter:blur(14px);
        }
        html[data-theme="ocean"] .glass-nav, body[data-theme="ocean"] .glass-nav,
        html[data-theme="rose"] .glass-nav, body[data-theme="rose"] .glass-nav,
        html[data-theme="forest"] .glass-nav, body[data-theme="forest"] .glass-nav,
        html[data-theme="lavender"] .glass-nav, body[data-theme="lavender"] .glass-nav,
        html[data-theme="ocean"] .chat-header, body[data-theme="ocean"] .chat-header,
        html[data-theme="rose"] .chat-header, body[data-theme="rose"] .chat-header,
        html[data-theme="forest"] .chat-header, body[data-theme="forest"] .chat-header,
        html[data-theme="lavender"] .chat-header, body[data-theme="lavender"] .chat-header,
        html[data-theme="ocean"] .input-area, body[data-theme="ocean"] .input-area,
        html[data-theme="rose"] .input-area, body[data-theme="rose"] .input-area,
        html[data-theme="forest"] .input-area, body[data-theme="forest"] .input-area,
        html[data-theme="lavender"] .input-area, body[data-theme="lavender"] .input-area,
        html[data-theme="ocean"] .main-chat, body[data-theme="ocean"] .main-chat,
        html[data-theme="rose"] .main-chat, body[data-theme="rose"] .main-chat,
        html[data-theme="forest"] .main-chat, body[data-theme="forest"] .main-chat,
        html[data-theme="lavender"] .main-chat, body[data-theme="lavender"] .main-chat {
            background:var(--theme-nav) !important; color:var(--theme-ink) !important;
        }
        html[data-theme="ocean"] #chatBox, body[data-theme="ocean"] #chatBox { background:linear-gradient(180deg,#effbff,#dff4fa) !important; }
        html[data-theme="rose"] #chatBox, body[data-theme="rose"] #chatBox { background:linear-gradient(180deg,#fff7fa,#fce8f1) !important; }
        html[data-theme="forest"] #chatBox, body[data-theme="forest"] #chatBox { background:linear-gradient(180deg,#f5faf2,#e8f2e4) !important; }
        html[data-theme="lavender"] #chatBox, body[data-theme="lavender"] #chatBox { background:linear-gradient(180deg,#faf7ff,#f0eaff) !important; }
        html[data-theme="ocean"] .sidebar-header, body[data-theme="ocean"] .sidebar-header { background:linear-gradient(135deg,#087ea4,#39a9c8) !important; }
        html[data-theme="rose"] .sidebar-header, body[data-theme="rose"] .sidebar-header { background:linear-gradient(135deg,#be185d,#ec4899) !important; }
        html[data-theme="forest"] .sidebar-header, body[data-theme="forest"] .sidebar-header { background:linear-gradient(135deg,#276749,#65a765) !important; }
        html[data-theme="lavender"] .sidebar-header, body[data-theme="lavender"] .sidebar-header { background:linear-gradient(135deg,#6841a5,#9b72d1) !important; }
        html[data-theme="ocean"] .friend-item.active, body[data-theme="ocean"] .friend-item.active { background:#c9f0fa !important; border-left-color:#087ea4 !important; }
        html[data-theme="rose"] .friend-item.active, body[data-theme="rose"] .friend-item.active { background:#fce0ed !important; border-left-color:#db2777 !important; }
        html[data-theme="forest"] .friend-item.active, body[data-theme="forest"] .friend-item.active { background:#dcefd8 !important; border-left-color:#367548 !important; }
        html[data-theme="lavender"] .friend-item.active, body[data-theme="lavender"] .friend-item.active { background:#e9ddfb !important; border-left-color:#7951b8 !important; }
        html[data-theme="ocean"] a, body[data-theme="ocean"] a { --tw-text-opacity:1; }
        html[data-theme="ocean"] .chat-header, body[data-theme="ocean"] .chat-header { color:#087ea4 !important; }
        html[data-theme="rose"] .chat-header, body[data-theme="rose"] .chat-header { color:#be185d !important; }
        html[data-theme="forest"] .chat-header, body[data-theme="forest"] .chat-header { color:#276749 !important; }
        html[data-theme="lavender"] .chat-header, body[data-theme="lavender"] .chat-header { color:#6841a5 !important; }
    `;
    document.head.appendChild(style);
}

function applyAccessibilityPreferences() {
    const scale = localStorage.getItem('ychat-font-scale') || '1';
    document.body.style.zoom = ['1.1', '1.2'].includes(scale) ? scale : '';
    document.body.classList.toggle('ychat-high-contrast', localStorage.getItem('ychat-high-contrast') === '1');
    const font = document.getElementById('ychatFontSize');
    const contrast = document.getElementById('ychatContrast');
    const receipts = document.getElementById('ychatHideReceipts');
    if (font) font.value = scale;
    if (contrast) contrast.checked = localStorage.getItem('ychat-high-contrast') === '1';
    if (receipts) receipts.checked = localStorage.getItem('ychat-hide-receipts') === '1';
    document.body.classList.toggle('ychat-hide-receipts', localStorage.getItem('ychat-hide-receipts') === '1');
}

function _injectAccessibilityTools() {
    if (document.getElementById('ychatAccessibilityPanel')) return;
    const button = document.createElement('button');
    button.type = 'button'; button.id = 'ychatAccessibilityButton';
    button.title = 'Accessibility and feed preferences'; button.setAttribute('aria-label', button.title);
    button.innerHTML = '<i class="fa-solid fa-universal-access" aria-hidden="true"></i>';
    button.style.cssText = 'position:fixed;right:18px;bottom:82px;z-index:9998;width:44px;height:44px;border:0;border-radius:50%;background:#2563eb;color:#fff;box-shadow:0 5px 18px #0003;cursor:pointer;font-size:19px';
    button.onclick = () => { const panel=document.getElementById('ychatAccessibilityPanel'); panel.hidden=!panel.hidden; if(!panel.hidden) document.getElementById('ychatFontSize').focus(); };
    const panel = document.createElement('section');
    panel.id='ychatAccessibilityPanel'; panel.hidden=true; panel.setAttribute('aria-label','Accessibility and feed preferences');
    panel.style.cssText='position:fixed;right:18px;bottom:136px;z-index:9999;width:min(330px,calc(100vw - 36px));max-height:70vh;overflow:auto;background:#fff;color:#172033;border:1px solid #cbd5e1;border-radius:18px;padding:18px;box-shadow:0 16px 50px #0004;font:14px system-ui,sans-serif';
    panel.innerHTML='<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px"><strong>Accessibility & feed</strong><button type="button" id="ychatCloseAccessibility" aria-label="Close preferences" style="border:0;background:transparent;font-size:20px;cursor:pointer">×</button></div>'+
      '<label for="ychatBgThemeSelect" style="display:block;font-weight:600;margin:10px 0 5px">Background / Theme</label><select id="ychatBgThemeSelect" style="width:100%;padding:9px;border:1px solid #cbd5e1;border-radius:9px"><option value="light">Default (Colorful)</option><option value="white">White Background</option><option value="dark">Dark Mode</option><option value="ocean">Ocean</option><option value="rose">Rose</option><option value="forest">Forest</option><option value="lavender">Lavender</option></select>'+
      '<label for="ychatFontSize" style="display:block;font-weight:600;margin:10px 0 5px">Text size</label><select id="ychatFontSize" style="width:100%;padding:9px;border:1px solid #cbd5e1;border-radius:9px"><option value="1">Default</option><option value="1.1">Large</option><option value="1.2">Extra large</option></select>'+
      '<label style="display:flex;gap:8px;align-items:center;margin:12px 0"><input type="checkbox" id="ychatContrast"> High contrast</label>'+
      '<label style="display:flex;gap:8px;align-items:center;margin:12px 0"><input type="checkbox" id="ychatHideReceipts"> Hide Seen/Sent labels in this browser</label>'+
      '<hr style="border:0;border-top:1px solid #e2e8f0;margin:14px 0"><label for="ychatHideKeyword" style="display:block;font-weight:600;margin-bottom:5px">Hide feed posts containing a keyword</label><div style="display:flex;gap:6px"><input id="ychatHideKeyword" type="text" maxlength="60" placeholder="Enter a word or phrase" style="min-width:0;flex:1;padding:8px;border:1px solid #cbd5e1;border-radius:8px"><button id="ychatAddKeyword" type="button" style="padding:8px 10px;border:0;border-radius:8px;background:#2563eb;color:#fff;cursor:pointer">Add</button></div><div id="ychatKeywordList" style="margin-top:8px"></div><button id="ychatClearSnoozes" type="button" style="margin-top:12px;padding:8px 10px;border:1px solid #cbd5e1;border-radius:8px;background:#f8fafc;cursor:pointer">Clear snoozed posts</button>';
    document.body.append(button,panel);
    panel.querySelector('#ychatCloseAccessibility').onclick=()=>panel.hidden=true;
    const bgSelect = panel.querySelector('#ychatBgThemeSelect');
    if (bgSelect) {
        bgSelect.value = getAppTheme();
        bgSelect.onchange = e => applyAppTheme(e.target.value);
    }
    panel.querySelector('#ychatFontSize').onchange=e=>{localStorage.setItem('ychat-font-scale',e.target.value);applyAccessibilityPreferences();};
    panel.querySelector('#ychatContrast').onchange=e=>{localStorage.setItem('ychat-high-contrast',e.target.checked?'1':'0');applyAccessibilityPreferences();};
    panel.querySelector('#ychatHideReceipts').onchange=e=>{localStorage.setItem('ychat-hide-receipts',e.target.checked?'1':'0');applyAccessibilityPreferences();};
    panel.querySelector('#ychatAddKeyword').onclick=()=>{const input=panel.querySelector('#ychatHideKeyword');const word=input.value.trim();if(!word)return;const words=getHiddenKeywords();if(!words.some(w=>w.toLowerCase()===word.toLowerCase()))words.push(word);localStorage.setItem('ychat-hidden-keywords',JSON.stringify(words));input.value='';renderHiddenKeywords();applyFeedPreferences();};
    panel.querySelector('#ychatHideKeyword').onkeydown=e=>{if(e.key==='Enter'){e.preventDefault();panel.querySelector('#ychatAddKeyword').click();}};
    panel.querySelector('#ychatClearSnoozes').onclick=()=>{localStorage.removeItem('ychat-snoozed-posts');applyFeedPreferences();};
    renderHiddenKeywords();
    document.addEventListener('keydown',e=>{if(e.altKey&&e.shiftKey&&e.key.toLowerCase()==='a'){e.preventDefault();panel.hidden=!panel.hidden;if(!panel.hidden)panel.querySelector('#ychatFontSize').focus();}if(e.key==='Escape'&&!panel.hidden)panel.hidden=true;});
    const highContrast=document.createElement('style'); highContrast.textContent='body.ychat-high-contrast{filter:contrast(1.2)} body.ychat-high-contrast :focus-visible{outline:3px solid #ffbf00!important;outline-offset:3px!important} body :focus-visible{outline:2px solid #2563eb;outline-offset:2px} body.ychat-hide-receipts .msg-status{visibility:hidden!important}'; document.head.appendChild(highContrast);
}

function getHiddenKeywords(){try{return JSON.parse(localStorage.getItem('ychat-hidden-keywords')||'[]').filter(v=>typeof v==='string');}catch(e){return[];}}
function renderHiddenKeywords(){const root=document.getElementById('ychatKeywordList');if(!root)return;const words=getHiddenKeywords();root.innerHTML=words.length?'':'<small style="color:#64748b">No hidden keywords</small>';words.forEach((word,i)=>{const row=document.createElement('div');row.style.cssText='display:flex;justify-content:space-between;gap:8px;align-items:center;padding:5px 0';const label=document.createElement('span');label.textContent=word;const remove=document.createElement('button');remove.type='button';remove.textContent='Remove';remove.setAttribute('aria-label','Remove hidden keyword '+word);remove.style.cssText='border:0;background:transparent;color:#b91c1c;cursor:pointer';remove.onclick=()=>{const next=getHiddenKeywords();next.splice(i,1);localStorage.setItem('ychat-hidden-keywords',JSON.stringify(next));renderHiddenKeywords();applyFeedPreferences();};row.append(label,remove);root.append(row);});}
function applyFeedPreferences(){const words=getHiddenKeywords().map(w=>w.toLocaleLowerCase());let snoozes={};try{snoozes=JSON.parse(localStorage.getItem('ychat-snoozed-posts')||'{}')||{};}catch(e){};const now=Date.now();Object.keys(snoozes).forEach(id=>{if(Number(snoozes[id])<=now)delete snoozes[id];});localStorage.setItem('ychat-snoozed-posts',JSON.stringify(snoozes));document.querySelectorAll('[data-post-id]').forEach(card=>{const id=card.dataset.postId;const text=(card.innerText||'').toLocaleLowerCase();card.style.display=(Number(snoozes[id])>now||words.some(w=>w&&text.includes(w)))?'none':'';});}
window.snoozePost=function(postId,days){const until=Date.now()+(Math.max(1,Number(days)||7)*86400000);let map={};try{map=JSON.parse(localStorage.getItem('ychat-snoozed-posts')||'{}')||{};}catch(e){}map[String(postId)]=until;localStorage.setItem('ychat-snoozed-posts',JSON.stringify(map));applyFeedPreferences();};
window.markNotInterested=function(postId){const card=document.querySelector('[data-post-id="'+String(postId).replace(/[^0-9]/g,'')+'"]');if(typeof window.hidePost==='function')window.hidePost(postId);else if(card)card.style.display='none';};

function _createInlineThemeBtn() {
    const btn = document.createElement('button');
    btn.id = 'themeToggleBtn';
    btn.type = 'button';
    btn.title = 'Change theme';
    btn.onclick = toggleThemeMode;
    const theme = getAppTheme();
    const meta = APP_THEME_META[theme];
    btn.className = `w-9 h-9 rounded-full flex items-center justify-center transition ${theme === 'dark' ? 'bg-slate-700' : 'bg-gray-200'}`;
    btn.innerHTML = `<i id="themeToggleIcon" class="fa ${meta.icon} ${meta.color}"></i>`;
    return btn;
}

function _injectThemeToggleButton() {
    // If a hardcoded inline button already exists, skip
    if (document.getElementById('themeToggleBtn')) {
        return;
    }
    // If floating button already exists, skip
    if (document.getElementById('floatingThemeBtn')) return;

    // Try to place inline button next to logout link
    const logoutLink = document.querySelector('a[href="UsersLogoutServlet"]');
    if (logoutLink) {
        const btn = _createInlineThemeBtn();
        logoutLink.parentNode.insertBefore(btn, logoutLink);
        return;
    }

    const profileLogout = document.querySelector('div[onclick*="UsersLogoutServlet"]');
    if (profileLogout) {
        const btn = _createInlineThemeBtn();
        profileLogout.parentNode.insertBefore(btn, profileLogout);
        return;
    }

    // Sidebar header fallback (messenger etc.)
    const sidebarHeader = document.querySelector('.sidebar-header');
    if (sidebarHeader) {
        const btn = _createInlineThemeBtn();
        btn.style.background = 'rgba(255,255,255,0.15)';
        btn.style.border = 'none';
        btn.style.borderRadius = '50%';
        btn.style.width = '35px';
        btn.style.height = '35px';
        btn.style.color = 'white';
        btn.style.cursor = 'pointer';
        btn.style.display = 'flex';
        btn.style.alignItems = 'center';
        btn.style.justifyContent = 'center';
        sidebarHeader.style.display = 'flex';
        sidebarHeader.style.justifyContent = 'space-between';
        sidebarHeader.style.alignItems = 'center';
        sidebarHeader.appendChild(btn);
        return;
    }

    // Final fallback: floating button visible on ALL pages
    const floatBtn = document.createElement('button');
    floatBtn.id = 'floatingThemeBtn';
    floatBtn.type = 'button';
    floatBtn.title = 'Change theme';
    floatBtn.onclick = toggleThemeMode;
    const meta = APP_THEME_META[getAppTheme()];
    floatBtn.innerHTML = `<i id="themeToggleIcon" class="fa ${meta.icon} ${meta.color}"></i>`;
    document.body.appendChild(floatBtn);
}

// Instant Search Autocomplete
function initInstantSearch() {
    const searchInput = document.querySelector('input[name="query"]');
    if (!searchInput) return;

    const form = searchInput.closest('form');
    if (form) {
        form.style.position = 'relative';
        form.id = 'headerSearchForm';
        searchInput.id = 'headerSearchInput';
        searchInput.autocomplete = 'off';
    }

    const dropdown = document.createElement('div');
    dropdown.id = 'instantSearchResults';
    dropdown.style.cssText = `
        display: none;
        position: absolute;
        top: 45px;
        left: 0;
        width: 100%;
        min-width: 260px;
        background: white;
        border-radius: 16px;
        box-shadow: 0 15px 45px rgba(0,0,0,0.15);
        border: 1px solid rgba(0,0,0,0.06);
        z-index: 9999;
        max-height: 350px;
        overflow-y: auto;
    `;
    
    const dropdownStyle = document.createElement('style');
    dropdownStyle.textContent = `
        body.dark #instantSearchResults {
            background: #1e293b !important;
            border-color: rgba(255,255,255,0.08) !important;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4) !important;
        }
        .search-suggest-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 15px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .search-suggest-item:hover {
            background: #f1f5f9;
        }
        body.dark .search-suggest-item:hover {
            background: #334155 !important;
        }
    `;
    document.head.appendChild(dropdownStyle);
    if (form) form.appendChild(dropdown);

    let debounceTimeout = null;

    searchInput.addEventListener('input', function() {
        const query = searchInput.value.trim();
        if (debounceTimeout) clearTimeout(debounceTimeout);
        
        if (query.length < 2) {
            dropdown.style.display = 'none';
            return;
        }

        debounceTimeout = setTimeout(() => {
            const derivedContext = window.location.pathname.split('/')[1];
            const contextPath = window.location.pathname.startsWith('/' + derivedContext) ? '/' + derivedContext : '';

            fetch(`${contextPath}/SearchServlet?query=${encodeURIComponent(query)}&ajax=true`)
            .then(res => res.json())
            .then(data => {
                dropdown.innerHTML = '';
                let hasResults = false;

                const users = data.users || [];
                const posts = data.posts || [];

                if (users.length > 0) {
                    hasResults = true;
                    const title = document.createElement('div');
                    title.style.cssText = 'font-size: 11px; font-weight: bold; color: #a855f7; padding: 8px 15px 4px 15px; text-transform: uppercase;';
                    title.innerText = 'People';
                    dropdown.appendChild(title);

                    users.slice(0, 5).forEach(user => {
                        const item = document.createElement('div');
                        item.className = 'search-suggest-item';
                        item.onclick = () => window.location.href = `${contextPath}/UsersProfileServlet?userId=${user.id}`;
                        
                        const profilePic = user.profile_pic || 'default.png';
                        item.innerHTML = `
                            <img src="${contextPath}/img/${profilePic}" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;">
                            <span style="font-weight: 600; font-size: 13px;">${user.name}</span>
                        `;
                        dropdown.appendChild(item);
                    });
                }

                if (posts.length > 0) {
                    hasResults = true;
                    const title = document.createElement('div');
                    title.style.cssText = 'font-size: 11px; font-weight: bold; color: #a855f7; padding: 8px 15px 4px 15px; text-transform: uppercase;';
                    title.innerText = 'Posts';
                    dropdown.appendChild(title);

                    posts.slice(0, 5).forEach(post => {
                        const item = document.createElement('div');
                        item.className = 'search-suggest-item';
                        item.onclick = () => window.location.href = `${contextPath}/SearchServlet?query=${encodeURIComponent(query)}`;
                        
                        const snippet = post.content.replace(/<[^>]*>/g, '').slice(0, 50) + (post.content.length > 50 ? '...' : '');
                        item.innerHTML = `
                            <div style="display:flex; flex-direction:column;">
                                <span style="font-weight: bold; font-size: 12px;">by ${post.name}</span>
                                <span style="font-size: 11px; color:#888;">${snippet}</span>
                            </div>
                        `;
                        dropdown.appendChild(item);
                    });
                }

                if (hasResults) {
                    dropdown.style.display = 'block';
                } else {
                    dropdown.innerHTML = '<div style="padding: 15px; font-size: 13px; color:#888; text-align:center;">No matches found</div>';
                    dropdown.style.display = 'block';
                }
            })
            .catch(err => {
                console.error("Instant search error:", err);
            });
        }, 300);
    });

    document.addEventListener('click', function(e) {
        if (form && !form.contains(e.target)) {
            dropdown.style.display = 'none';
        }
    });
}

// Floating Music Player
function initMusicPlayer() {
    const playerStyle = document.createElement('style');
    playerStyle.textContent = `
        #floating-music-btn {
            position: fixed;
            bottom: 85px;
            right: 25px;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #a855f7, #6366f1);
            box-shadow: 0 8px 24px rgba(124, 58, 237, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            cursor: pointer;
            z-index: 9999;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        #floating-music-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 12px 28px rgba(124, 58, 237, 0.6);
        }
        #floating-music-btn.playing {
            animation: spinRecord 4s linear infinite;
        }
        
        #music-player-panel {
            position: fixed;
            bottom: 145px;
            right: 25px;
            width: 280px;
            padding: 20px;
            border-radius: 24px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            z-index: 9998;
            opacity: 0;
            transform: translateY(20px) scale(0.95);
            pointer-events: none;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        #music-player-panel.show {
            opacity: 1;
            transform: translateY(0) scale(1);
            pointer-events: auto;
        }
    `;
    document.head.appendChild(playerStyle);

    const audio = document.createElement('audio');
    audio.id = 'lofi-audio';
    document.body.appendChild(audio);

    const tracks = [
        { name: "Lofi Chill Beat", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3" },
        { name: "Midnight Study", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3" },
        { name: "Summer Breeze", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3" }
    ];
    let currentTrackIdx = 0;

    function loadTrack(idx) {
        audio.src = tracks[idx].url;
        document.getElementById('track-title').innerText = tracks[idx].name;
    }

    const floatBtn = document.createElement('div');
    floatBtn.id = 'floating-music-btn';
    floatBtn.innerHTML = '<i class="fa fa-music text-lg"></i>';
    document.body.appendChild(floatBtn);

    const panel = document.createElement('div');
    panel.id = 'music-player-panel';
    panel.className = 'glass-card';
    panel.innerHTML = `
        <div style="display:flex; flex-direction:column; align-items:center; gap:12px; color:inherit;">
            <div style="font-weight:bold; font-size:12px; color:#a855f7; text-transform:uppercase; letter-spacing:1px;">Chill Lofi Station</div>
            
            <div id="vinyl-disc" style="width:70px; height:70px; border-radius:50%; background:#1e293b; border:5px solid #0f172a; display:flex; align-items:center; justify-content:center; box-shadow:0 8px 16px rgba(0,0,0,0.2); position:relative;">
                <div style="width:20px; height:20px; border-radius:50%; background:#a855f7; border:3px solid #1e293b;"></div>
            </div>
            
            <div id="track-title" style="font-weight:bold; font-size:14px; text-align:center; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; width:100%; margin:4px 0;">Track Name</div>
            
            <div style="width:100%; display:flex; flex-direction:column; gap:4px;">
                <div id="progress-container" style="width:100%; height:6px; background:rgba(0,0,0,0.1); border-radius:3px; cursor:pointer; position:relative;">
                    <div id="progress-bar" style="width:0%; height:100%; background:#a855f7; border-radius:3px;"></div>
                </div>
                <div style="display:flex; justify-content:space-between; font-size:10px; color:#888;">
                    <span id="current-time">0:00</span>
                    <span id="duration-time">0:00</span>
                </div>
            </div>

            <div style="display:flex; align-items:center; gap:15px;">
                <i class="fa fa-backward clickable text-lg" id="prev-track" style="cursor:pointer;"></i>
                <i class="fa fa-play clickable text-2xl" id="play-pause-btn" style="cursor:pointer; color:#a855f7;"></i>
                <i class="fa fa-forward clickable text-lg" id="next-track" style="cursor:pointer;"></i>
            </div>
            
            <div style="display:flex; align-items:center; gap:8px; width:100%; margin-top:8px;">
                <i class="fa fa-volume-low text-xs" style="color:#888;"></i>
                <input type="range" id="volume-slider" min="0" max="100" value="80" style="flex:1; accent-color:#a855f7; height:4px; border-radius:2px; cursor:pointer;">
                <i class="fa fa-volume-high text-xs" style="color:#888;"></i>
            </div>
        </div>
    `;
    document.body.appendChild(panel);

    floatBtn.onclick = function() {
        panel.classList.toggle('show');
    };

    document.addEventListener('click', function(e) {
        if (!floatBtn.contains(e.target) && !panel.contains(e.target)) {
            panel.classList.remove('show');
        }
    });

    const playPauseBtn = document.getElementById('play-pause-btn');
    const prevBtn = document.getElementById('prev-track');
    const nextBtn = document.getElementById('next-track');
    const volSlider = document.getElementById('volume-slider');
    const progressContainer = document.getElementById('progress-container');
    const progressBar = document.getElementById('progress-bar');
    const vinylDisc = document.getElementById('vinyl-disc');

    loadTrack(currentTrackIdx);
    audio.volume = 0.8;

    playPauseBtn.onclick = function() {
        if (audio.paused) {
            audio.play();
            playPauseBtn.className = 'fa fa-pause clickable text-2xl';
            floatBtn.classList.add('playing');
            vinylDisc.style.animation = 'spinRecord 4s linear infinite';
        } else {
            audio.pause();
            playPauseBtn.className = 'fa fa-play clickable text-2xl';
            floatBtn.classList.remove('playing');
            vinylDisc.style.animation = 'none';
        }
    };

    prevBtn.onclick = function() {
        currentTrackIdx = (currentTrackIdx - 1 + tracks.length) % tracks.length;
        loadTrack(currentTrackIdx);
        audio.play();
        playPauseBtn.className = 'fa fa-pause clickable text-2xl';
        floatBtn.classList.add('playing');
        vinylDisc.style.animation = 'spinRecord 4s linear infinite';
    };

    nextBtn.onclick = function() {
        currentTrackIdx = (currentTrackIdx + 1) % tracks.length;
        loadTrack(currentTrackIdx);
        audio.play();
        playPauseBtn.className = 'fa fa-pause clickable text-2xl';
        floatBtn.classList.add('playing');
        vinylDisc.style.animation = 'spinRecord 4s linear infinite';
    };

    volSlider.oninput = function() {
        audio.volume = volSlider.value / 100;
    };

    audio.ontimeupdate = function() {
        if (audio.duration) {
            const pct = (audio.currentTime / audio.duration) * 100;
            progressBar.style.width = pct + '%';
            
            const curMins = Math.floor(audio.currentTime / 60);
            const curSecs = Math.floor(audio.currentTime % 60).toString().padStart(2, '0');
            document.getElementById('current-time').innerText = `${curMins}:${curSecs}`;
            
            const durMins = Math.floor(audio.duration / 60);
            const durSecs = Math.floor(audio.duration % 60).toString().padStart(2, '0');
            document.getElementById('duration-time').innerText = `${durMins}:${durSecs}`;
        }
    };

    progressContainer.onclick = function(e) {
        const rect = progressContainer.getBoundingClientRect();
        const pct = (e.clientX - rect.left) / rect.width;
        audio.currentTime = pct * audio.duration;
    };

    audio.onended = function() {
        nextBtn.click();
    };
}

// Global Audio Selector, Parser and Post Actions Integration
function initAudioSelectorAndParser() {
    const tracks = {
        quran: [
            { name: "Surah Al-Fatihah", artist: "Mishary Alafasy", url: "https://download.quranicaudio.com/quran/mishari_rabee3_alafasy/001.mp3" },
            { name: "Surah Al-Kahf", artist: "Mishary Alafasy", url: "https://download.quranicaudio.com/quran/mishari_rabee3_alafasy/018.mp3" },
            { name: "Surah Ar-Rahman", artist: "Mishary Alafasy", url: "https://download.quranicaudio.com/quran/mishari_rabee3_alafasy/055.mp3" },
            { name: "Surah Al-Mulk", artist: "Mishary Alafasy", url: "https://download.quranicaudio.com/quran/mishari_rabee3_alafasy/067.mp3" },
            { name: "Surah Al-Ikhlas", artist: "Mishary Alafasy", url: "https://download.quranicaudio.com/quran/mishari_rabee3_alafasy/112.mp3" }
        ],
        music: [
            { name: "Lofi Chill Beat", artist: "SoundHelix 1", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3" },
            { name: "Midnight Study", artist: "SoundHelix 2", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3" },
            { name: "Summer Breeze", artist: "SoundHelix 3", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3" },
            { name: "Relaxing Piano", artist: "SoundHelix 4", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3" },
            { name: "Sunset Drive", artist: "SoundHelix 5", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3" }
        ]
    };

    let activeContext = '';
    let previewAudio = new Audio();
    let previewingTrackUrl = '';

    const modal = document.createElement('div');
    modal.id = 'audioSelectorModal';
    modal.style.cssText = `
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(12px);
        align-items: center;
        justify-content: center;
        z-index: 100000;
        opacity: 0;
        transition: opacity 0.3s ease;
    `;
    
    modal.innerHTML = `
        <div class="glass-card" style="width: 90%; max-width: 450px; border-radius: 24px; padding: 24px; display: flex; flex-direction: column; gap: 16px; max-height: 80vh; overflow: hidden; background: white; color: #1e293b; border: 1px solid rgba(0,0,0,0.1); box-shadow: 0 20px 50px rgba(0,0,0,0.2);">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <h3 style="font-weight:bold; font-size:18px; margin:0;" class="text-slate-900">Select Background Audio</h3>
                <button type="button" id="closeAudioSelectorBtn" style="background:rgba(0,0,0,0.05); border:none; width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; cursor:pointer;" class="hover:bg-red-100 hover:text-red-600 transition">
                    <i class="fa fa-times"></i>
                </button>
            </div>
            
            <input type="text" id="audioSearch" placeholder="Search surahs or music..." style="width:100%; padding:10px 15px; border-radius:12px; border:1px solid rgba(0,0,0,0.1); outline:none;" class="text-sm">
            
            <div style="display:flex; border-bottom:1px solid rgba(0,0,0,0.1);">
                <button type="button" id="tabQuran" style="flex:1; padding:10px; border:none; background:none; font-weight:bold; border-bottom:3px solid #a855f7; color:#a855f7; cursor:pointer;" class="text-sm">📖 Quranic Recitations</button>
                <button type="button" id="tabMusic" style="flex:1; padding:10px; border:none; background:none; font-weight:bold; border-bottom:3px solid transparent; color:#64748b; cursor:pointer;" class="text-sm">🎵 Relaxing Lofi</button>
            </div>
            
            <div id="audioTracksList" style="flex:1; overflow-y:auto; display:flex; flex-direction:column; gap:8px; padding-right:4px;" class="custom-scrollbar">
            </div>
        </div>
    `;

    document.body.appendChild(modal);

    const style = document.createElement('style');
    style.textContent = `
        body.dark #audioSelectorModal .glass-card {
            background: rgba(15, 23, 42, 0.95) !important;
            border-color: rgba(255, 255, 255, 0.08) !important;
            color: #f1f5f9 !important;
            box-shadow: 0 25px 60px rgba(0,0,0,0.5) !important;
        }
        body.dark #audioSelectorModal h3 {
            color: #f8fafc !important;
        }
        body.dark #audioSearch {
            background: rgba(30, 41, 59, 0.7) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: #f1f5f9 !important;
        }
        body.dark #closeAudioSelectorBtn {
            background: rgba(255,255,255,0.08) !important;
            color: #cbd5e1 !important;
        }
        .audio-track-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px;
            border-radius: 16px;
            background: rgba(0,0,0,0.02);
            transition: all 0.2s ease;
        }
        .audio-track-item:hover {
            background: rgba(168, 85, 247, 0.05);
        }
        body.dark .audio-track-item {
            background: rgba(255,255,255,0.02);
        }
        body.dark .audio-track-item:hover {
            background: rgba(168, 85, 247, 0.08);
        }
    `;
    document.head.appendChild(style);

    let currentTab = 'quran';

    function renderTracks() {
        const searchVal = document.getElementById('audioSearch').value.toLowerCase();
        const listContainer = document.getElementById('audioTracksList');
        listContainer.innerHTML = '';
        
        const currentTracks = tracks[currentTab];
        const filtered = currentTracks.filter(t => 
            t.name.toLowerCase().includes(searchVal) || t.artist.toLowerCase().includes(searchVal)
        );

        if (filtered.length === 0) {
            listContainer.innerHTML = '<div style="text-align:center; color:#888; padding:20px; font-size:13px;">No tracks found</div>';
            return;
        }

        filtered.forEach(track => {
            const isPlaying = (previewingTrackUrl === track.url && !previewAudio.paused);
            const item = document.createElement('div');
            item.className = 'audio-track-item';
            item.innerHTML = `
                <div style="display:flex; align-items:center; gap:12px; flex:1; min-width:0;">
                    <button type="button" class="preview-btn" data-url="${track.url}" style="background:#a855f7; color:white; border:none; width:34px; height:34px; border-radius:50%; display:flex; align-items:center; justify-content:center; cursor:pointer; flex-shrink:0;">
                        <i class="fa ${isPlaying ? 'fa-pause' : 'fa-play'}" style="font-size:12px;"></i>
                    </button>
                    <div style="display:flex; flex-direction:column; min-width:0;">
                        <span style="font-weight:bold; font-size:13px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;" class="text-slate-800 dark:text-slate-100">${track.name}</span>
                        <span style="font-size:11px; color:#888; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">${track.artist}</span>
                    </div>
                </div>
                <button type="button" class="select-btn" data-url="${track.url}" data-name="${track.name}" style="background:linear-gradient(135deg, #a855f7, #6366f1); color:white; border:none; padding:6px 12px; border-radius:10px; font-size:12px; font-weight:bold; cursor:pointer;" class="hover:scale-105 active:scale-95 transition">
                    Attach
                </button>
            `;
            listContainer.appendChild(item);
        });

        listContainer.querySelectorAll('.preview-btn').forEach(btn => {
            btn.onclick = function() {
                const url = this.dataset.url;
                togglePreview(url);
            };
        });

        listContainer.querySelectorAll('.select-btn').forEach(btn => {
            btn.onclick = function() {
                const url = this.dataset.url;
                const name = this.dataset.name;
                attachTrack(url, name);
            };
        });
    }

    function togglePreview(url) {
        pauseAllOtherAudio(previewAudio);

        if (previewingTrackUrl === url) {
            if (previewAudio.paused) {
                previewAudio.play();
            } else {
                previewAudio.pause();
            }
        } else {
            previewAudio.src = url;
            previewingTrackUrl = url;
            previewAudio.play();
        }
        renderTracks();
    }

    previewAudio.onplay = () => renderTracks();
    previewAudio.onpause = () => renderTracks();
    previewAudio.onended = () => {
        previewingTrackUrl = '';
        renderTracks();
    };

    function attachTrack(url, name) {
        previewAudio.pause();
        previewingTrackUrl = '';
        
        const formId = activeContext + 'Form';
        const form = document.getElementById(formId);
        if (form) {
            form.dataset.selectedAudioUrl = url;
            form.dataset.selectedAudioName = name;
            
            const badge = document.getElementById('audioBadge_' + activeContext);
            const badgeText = document.getElementById('audioBadgeText_' + activeContext);
            if (badge && badgeText) {
                badgeText.innerText = name;
                badge.classList.remove('hidden');
                badge.style.display = 'flex';
            }
        }
        
        closeAudioSelector();
    }

    window.openAudioSelector = function(context) {
        activeContext = context;
        modal.style.display = 'flex';
        setTimeout(() => { modal.style.opacity = '1'; }, 10);
        renderTracks();
    };

    function closeAudioSelector() {
        previewAudio.pause();
        previewingTrackUrl = '';
        modal.style.opacity = '0';
        setTimeout(() => {
            modal.style.display = 'none';
        }, 300);
    }

    document.getElementById('closeAudioSelectorBtn').onclick = closeAudioSelector;
    document.getElementById('audioSearch').oninput = renderTracks;

    document.getElementById('tabQuran').onclick = function() {
        currentTab = 'quran';
        this.style.borderColor = '#a855f7';
        this.style.color = '#a855f7';
        document.getElementById('tabMusic').style.borderColor = 'transparent';
        document.getElementById('tabMusic').style.color = '#64748b';
        renderTracks();
    };

    document.getElementById('tabMusic').onclick = function() {
        currentTab = 'music';
        this.style.borderColor = '#a855f7';
        this.style.color = '#a855f7';
        document.getElementById('tabQuran').style.borderColor = 'transparent';
        document.getElementById('tabQuran').style.color = '#64748b';
        renderTracks();
    };

    window.removeSelectedAudio = function(context) {
        const formId = context + 'Form';
        const form = document.getElementById(formId);
        if (form) {
            delete form.dataset.selectedAudioUrl;
            delete form.dataset.selectedAudioName;
            
            const badge = document.getElementById('audioBadge_' + context);
            if (badge) {
                badge.classList.add('hidden');
                badge.style.display = 'none';
            }
        }
    };
}

// Scan DOM for [AUDIO:url|name] inside elements with class `post-text-content`
window.parsePostAudioTags = function() {
    const postElements = document.querySelectorAll('.post-text-content');
    postElements.forEach(el => {
        if (el.dataset.audioParsed === 'true') return;
        
        const htmlContent = el.innerHTML;
        const audioRegex = /\[AUDIO:(.*?)\|(.*?)\]/g;
        let match = audioRegex.exec(htmlContent);
        
        if (match) {
            const audioUrl = match[1];
            const audioName = match[2];
            
            const cleanHtml = htmlContent.replace(audioRegex, '').trim();
            el.innerHTML = cleanHtml;
            
            const playerCard = document.createElement('div');
            playerCard.style.cssText = `
                margin-top: 15px;
                padding: 12px 16px;
                border-radius: 20px;
                background: rgba(168, 85, 247, 0.06);
                border: 1px solid rgba(168, 85, 247, 0.15);
                display: flex;
                align-items: center;
                gap: 12px;
                transition: all 0.3s ease;
            `;
            playerCard.className = 'glass-card audio-feed-player';
            
            const audioId = 'post-audio-' + Math.random().toString(36).substr(2, 9);
            playerCard.innerHTML = `
                <audio id="${audioId}" src="${audioUrl}"></audio>
                <button type="button" class="post-audio-play-btn" style="background:#a855f7; color:white; border:none; width:36px; height:36px; border-radius:50%; display:flex; align-items:center; justify-content:center; cursor:pointer; flex-shrink:0;" onclick="togglePostAudio('${audioId}', this)">
                    <i class="fa fa-play" style="font-size:12px; margin-left:2px;"></i>
                </button>
                <div style="display:flex; flex-direction:column; flex:1; min-width:0;">
                    <div style="display:flex; align-items:center; gap:6px; min-width:0;">
                        <i class="fa fa-music text-xs" style="color:#a855f7; flex-shrink:0;"></i>
                        <span style="font-weight:bold; font-size:12.5px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;" class="text-slate-800 dark:text-slate-100">${audioName}</span>
                    </div>
                    <div class="audio-progress-container" style="width:100%; height:4px; background:rgba(0,0,0,0.06); border-radius:2px; margin-top:6px; position:relative; cursor:pointer;" onclick="seekPostAudio('${audioId}', event, this)">
                        <div class="audio-progress-bar" style="width:0%; height:100%; background:#a855f7; border-radius:2px;"></div>
                    </div>
                </div>
            `;
            
            el.parentNode.insertBefore(playerCard, el.nextSibling);
            
            const audioEl = document.getElementById(audioId);
            const progressBar = playerCard.querySelector('.audio-progress-bar');
            audioEl.ontimeupdate = function() {
                if (audioEl.duration) {
                    const pct = (audioEl.currentTime / audioEl.duration) * 100;
                    progressBar.style.width = pct + '%';
                }
            };
            audioEl.onended = function() {
                const playIcon = playerCard.querySelector('.post-audio-play-btn i');
                playIcon.className = 'fa fa-play';
                progressBar.style.width = '0%';
            };
        }
        
        el.dataset.audioParsed = 'true';
    });
};

window.togglePostAudio = function(audioId, btn) {
    const audioEl = document.getElementById(audioId);
    const playIcon = btn.querySelector('i');
    
    pauseAllOtherAudio(audioEl);

    if (audioEl.paused) {
        audioEl.play();
        playIcon.className = 'fa fa-pause';
    } else {
        audioEl.pause();
        playIcon.className = 'fa fa-play';
    }
};

window.seekPostAudio = function(audioId, e, container) {
    const audioEl = document.getElementById(audioId);
    if (!audioEl || !audioEl.duration) return;
    const rect = container.getBoundingClientRect();
    const pct = (e.clientX - rect.left) / rect.width;
    audioEl.currentTime = pct * audioEl.duration;
};

// Pause all audio elements except the one specified
window.pauseAllOtherAudio = function(exceptElement) {
    const lofiAudio = document.getElementById('lofi-audio');
    if (lofiAudio && lofiAudio !== exceptElement && !lofiAudio.paused) {
        lofiAudio.pause();
        const playPauseBtn = document.getElementById('play-pause-btn');
        if (playPauseBtn) playPauseBtn.className = 'fa fa-play clickable text-2xl';
        const floatBtn = document.getElementById('floating-music-btn');
        if (floatBtn) floatBtn.classList.remove('playing');
        const vinylDisc = document.getElementById('vinyl-disc');
        if (vinylDisc) vinylDisc.style.animation = 'none';
    }

    document.querySelectorAll('.audio-feed-player audio').forEach(audio => {
        if (audio !== exceptElement && !audio.paused) {
            audio.pause();
            const btn = audio.parentNode.querySelector('.post-audio-play-btn i');
            if (btn) btn.className = 'fa fa-play';
        }
    });

    const storyVideo = document.getElementById('storyViewerVideo');
    if (storyVideo && storyVideo !== exceptElement && !storyVideo.paused) {
        storyVideo.pause();
    }
    const storyAudio = window.storyBackgroundAudio;
    if (storyAudio && storyAudio !== exceptElement && !storyAudio.paused) {
        storyAudio.pause();
    }

    const reelVideo = document.getElementById('viewerVideo');
    if (reelVideo && reelVideo !== exceptElement && !reelVideo.paused) {
        reelVideo.pause();
    }
    const reelAudio = window.reelBackgroundAudio;
    if (reelAudio && reelAudio !== exceptElement && !reelAudio.paused) {
        reelAudio.pause();
    }
};

// Post actions: Save, Delete, Hide, Report
window.toggleSavePost = function(postId, btn) {
    let isSaved = btn.innerText.includes("Unsave");
    let action = isSaved ? "UNSAVE" : "SAVE";
    
    const derivedContext = window.location.pathname.split('/')[1];
    const contextPath = window.location.pathname.startsWith('/' + derivedContext) ? '/' + derivedContext : '';

    fetch(`${contextPath}/FeaturesServlet?action=${action}&postId=${postId}`, { method: 'POST' })
    .then(res => res.json())
    .then(data => {
        if(data.success) {
            if(action === "SAVE") {
                btn.innerHTML = '<i class="fa fa-bookmark"></i> Unsave Post';
                alert("Post Saved successfully!");
            } else {
                btn.innerHTML = '<i class="fa fa-bookmark"></i> Save Post';
                alert("Post Unsaved successfully!");
            }
        } else {
            alert("Action failed!");
        }
    })
    .catch(err => {
        console.error("Save error:", err);
        alert("Error processing request");
    });
};

window.deletePost = function(postId) {
    if(!confirm("Are you sure you want to delete this post?")) return;
    
    const derivedContext = window.location.pathname.split('/')[1];
    const contextPath = window.location.pathname.startsWith('/' + derivedContext) ? '/' + derivedContext : '';

    let formData = new FormData();
    formData.append("action", "DELETE");
    formData.append("postId", postId);
    formData.append("ajax", "true");

    fetch(`${contextPath}/UsersPostServlet?ajax=true`, { method: 'POST', body: formData })
    .then(res => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json();
    })
    .then(data => {
        if(data.success) {
            alert("Post deleted successfully!");
            if (typeof refreshFeed === 'function') {
                refreshFeed();
            } else {
                window.location.reload();
            }
        } else {
            alert("Failed to delete post.");
        }
    })
    .catch(err => {
        console.error("Delete error: ", err);
        window.location.reload();
    });
};

window.hidePost = function(postId) {
    if(!confirm("Are you sure you want to hide this post? It will not be shown to you anymore.")) return;
    
    const derivedContext = window.location.pathname.split('/')[1];
    const contextPath = window.location.pathname.startsWith('/' + derivedContext) ? '/' + derivedContext : '';

    fetch(`${contextPath}/ReportHideServlet?action=hide&type=POST&id=${postId}`, { method: 'POST' })
    .then(res => res.json())
    .then(data => {
        if(data.success) {
            alert("Post hidden successfully!");
            if (typeof refreshFeed === 'function') {
                refreshFeed();
            } else {
                window.location.reload();
            }
        } else {
            alert("Failed to hide post: " + (data.message || ''));
        }
    })
    .catch(err => {
        console.error("Hide error: ", err);
        alert("Error hiding post");
    });
};

window.reportPost = function(postId) {
    const reason = prompt("Why are you reporting this post? (e.g. Inappropriate content, Spam, Harassment)");
    if (reason === null) return;
    if (reason.trim() === "") {
        alert("Please provide a reason to report.");
        return;
    }

    const details = prompt("Please provide additional details (optional):");
    if (details === null) return;

    const derivedContext = window.location.pathname.split('/')[1];
    const contextPath = window.location.pathname.startsWith('/' + derivedContext) ? '/' + derivedContext : '';

    fetch(`${contextPath}/ReportHideServlet?action=report&type=POST&id=${postId}&reason=${encodeURIComponent(reason)}&details=${encodeURIComponent(details)}`, { method: 'POST' })
    .then(res => res.json())
    .then(data => {
        if(data.success) {
            alert("Thank you for your report. We will review it shortly.");
        } else {
            alert("Failed to report post: " + (data.message || ''));
        }
    })
    .catch(err => {
        console.error("Report error: ", err);
        alert("Error reporting post");
    });
};

// Global Toast Notification System
window.showToast = function(message, type = 'info') {
    let container = document.getElementById('globalToastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'globalToastContainer';
        container.style.cssText = 'position: fixed; bottom: 25px; right: 25px; z-index: 100000; display: flex; flex-direction: column; gap: 10px; pointer-events: none;';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    const bgColors = {
        success: 'linear-gradient(135deg, #10b981, #059669)',
        error: 'linear-gradient(135deg, #ef4444, #dc2626)',
        info: 'linear-gradient(135deg, #3b82f6, #1d4ed8)',
        warning: 'linear-gradient(135deg, #f59e0b, #d97706)'
    };
    const icons = {
        success: 'fa-circle-check',
        error: 'fa-triangle-exclamation',
        info: 'fa-circle-info',
        warning: 'fa-bell'
    };

    toast.style.cssText = `
        background: ${bgColors[type] || bgColors.info};
        color: white;
        padding: 12px 20px;
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.25);
        font-weight: 600;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 10px;
        pointer-events: auto;
        opacity: 0;
        transform: translateY(20px) scale(0.95);
        transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        max-width: 350px;
    `;

    toast.innerHTML = `<i class="fa ${icons[type] || icons.info} text-lg"></i> <span>${message}</span>`;
    container.appendChild(toast);

    setTimeout(() => {
        toast.style.opacity = '1';
        toast.style.transform = 'translateY(0) scale(1)';
    }, 20);

    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(20px) scale(0.95)';
        setTimeout(() => toast.remove(), 350);
    }, 3500);
};

// Copy Post Link Helper
window.copyPostLink = function(postId) {
    const postUrl = window.location.origin + window.location.pathname + '?postId=' + postId;
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(postUrl).then(() => {
            showToast('Post link copied to clipboard! 📋', 'success');
        }).catch(() => {
            fallbackCopy(postUrl);
        });
    } else {
        fallbackCopy(postUrl);
    }
};

function fallbackCopy(text) {
    const tempInput = document.createElement('input');
    tempInput.value = text;
    document.body.appendChild(tempInput);
    tempInput.select();
    document.execCommand('copy');
    document.body.removeChild(tempInput);
}

// ============================================================
// 🌍 MULTI-LANGUAGE (i18n) UNIVERSAL TRANSLATION SYSTEM
// ============================================================
window.i18nTranslations = {
    en: {
        name: "English 🇬🇧",
        home_feed: "Home Feed",
        my_profile: "My Profile",
        friends: "Friends",
        messenger: "Messenger",
        memories: "Memories",
        saved: "Saved",
        create_reel: "Create Reel",
        ai_assistant: "AI Assistant",
        ads_manager: "Y-Ads Manager",
        marketplace: "Marketplace",
        short_videos: "Watch & Videos",
        groups: "Groups",
        events: "Events",
        privacy_policy: "Privacy & Policy",
        create_story: "Create Story",
        whats_on_mind: "What's on your mind?",
        live: "Live",
        photo: "Photo",
        feeling: "Feeling",
        save_post: "Save Post",
        copy_link: "Copy Link",
        hide_post: "Hide Post",
        report_post: "Report Post",
        delete_post: "Delete Post",
        like: "Like",
        comment: "Comment",
        share: "Share",
        notifications: "Notifications",
        settings: "Settings",
        logout: "Logout",
        language: "Language",
        search_placeholder: "Search Y-Chat...",
        write_comment: "Write a comment...",
        write_reply: "Write a reply...",
        shortcuts: "Shortcuts"
    },
    bn: {
        name: "বাংলা 🇧🇩",
        home_feed: "হোম ফিড",
        my_profile: "আমার প্রোফাইল",
        friends: "বন্ধু তালিকা",
        messenger: "মেসেঞ্জার",
        memories: "স্মৃতিসমূহ",
        saved: "সংরক্ষিত",
        create_reel: "রিল তৈরি করুন",
        ai_assistant: "এআই সহকারী",
        ads_manager: "বিজ্ঞাপন ম্যানেজার",
        marketplace: "মার্কেটপ্লেস",
        short_videos: "শর্ট ভিডিও",
        groups: "গ্রুপসমূহ",
        events: "ইভেন্টসমূহ",
        privacy_policy: "প্রাইভেসি নীতি",
        create_story: "স্টোরি তৈরি করুন",
        whats_on_mind: "আপনার মনে কি চলছে?",
        live: "লাইভ",
        photo: "ছবি",
        feeling: "অনুভূতি",
        save_post: "পোস্ট সেভ করুন",
        copy_link: "লিঙ্ক কপি করুন",
        hide_post: "পোস্ট লুকান",
        report_post: "রিপোর্ট করুন",
        delete_post: "ডিলিট করুন",
        like: "লাইক",
        comment: "কমেন্ট",
        share: "শেয়ার",
        notifications: "নোটিফিকেশন",
        settings: "সেটিংস",
        logout: "লগআউট",
        language: "ভাষা",
        search_placeholder: "Y-Chat-এ খুঁজুন...",
        write_comment: "কমেন্ট লিখুন...",
        write_reply: "উত্তর লিখুন...",
        shortcuts: "শর্টকাট"
    },
    ja: {
        name: "日本語 🇯🇵",
        home_feed: "ホーム",
        my_profile: "マイプロフィール",
        friends: "友達リスト",
        messenger: "メッセンジャー",
        memories: "思い出",
        saved: "保存済み",
        create_reel: "リールを作成",
        ai_assistant: "AIアシスタント",
        ads_manager: "広告マネージャー",
        marketplace: "マーケット",
        short_videos: "ショート動画",
        groups: "グループ",
        events: "イベント",
        privacy_policy: "プライバシーポリシー",
        create_story: "ストーリーを作成",
        whats_on_mind: "今何してる？",
        live: "ライブ",
        photo: "写真",
        feeling: "気分",
        save_post: "投稿を保存",
        copy_link: "リンクをコピー",
        hide_post: "投稿を非表示",
        report_post: "投稿を報告",
        delete_post: "投稿を削除",
        like: "いいね",
        comment: "コメント",
        share: "シェア",
        notifications: "通知",
        settings: "設定",
        logout: "ログアウト",
        language: "言語",
        search_placeholder: "Y-Chatを検索...",
        write_comment: "コメントを書く...",
        write_reply: "返信を書く...",
        shortcuts: "ショートカット"
    },
    es: {
        name: "Español 🇪🇸",
        home_feed: "Inicio",
        my_profile: "Mi Perfil",
        friends: "Amigos",
        messenger: "Mensajero",
        memories: "Recuerdos",
        saved: "Guardados",
        create_reel: "Crear Reel",
        ai_assistant: "Asistente IA",
        ads_manager: "Gestor de Anuncios",
        marketplace: "Mercado",
        short_videos: "Videos Cortos",
        groups: "Grupos",
        events: "Eventos",
        privacy_policy: "Política de Privacidad",
        create_story: "Crear Historia",
        whats_on_mind: "¿En qué estás pensando?",
        live: "En vivo",
        photo: "Foto",
        feeling: "Sentimiento",
        save_post: "Guardar Publicación",
        copy_link: "Copiar Enlace",
        hide_post: "Ocultar Publicación",
        report_post: "Reportar",
        delete_post: "Eliminar",
        like: "Me gusta",
        comment: "Comentar",
        share: "Compartir",
        notifications: "Notificaciones",
        settings: "Ajustes",
        logout: "Cerrar sesión",
        language: "Idioma",
        search_placeholder: "Buscar en Y-Chat...",
        write_comment: "Escribe un comentario...",
        write_reply: "Escribe una respuesta...",
        shortcuts: "Accesos directos"
    },
    fr: {
        name: "Français 🇫🇷",
        home_feed: "Accueil",
        my_profile: "Mon Profil",
        friends: "Amis",
        messenger: "Messagerie",
        memories: "Souvenirs",
        saved: "Enregistrés",
        create_reel: "Créer un Reel",
        ai_assistant: "Assistant IA",
        ads_manager: "Gestionnaire de Pubs",
        marketplace: "Marché",
        short_videos: "Vidéos Courtes",
        groups: "Groupes",
        events: "Événements",
        privacy_policy: "Politique de confidentialité",
        create_story: "Créer une story",
        whats_on_mind: "À quoi pensez-vous ?",
        live: "En direct",
        photo: "Photo",
        feeling: "Humeur",
        save_post: "Enregistrer",
        copy_link: "Copier le lien",
        hide_post: "Masquer",
        report_post: "Signaler",
        delete_post: "Supprimer",
        like: "J'aime",
        comment: "Commenter",
        share: "Partager",
        notifications: "Notifications",
        settings: "Paramètres",
        logout: "Déconnexion",
        language: "Langue",
        search_placeholder: "Rechercher...",
        write_comment: "Écrire un commentaire...",
        write_reply: "Écrire une réponse...",
        shortcuts: "Raccourcis"
    },
    de: {
        name: "Deutsch 🇩🇪",
        home_feed: "Startseite",
        my_profile: "Mein Profil",
        friends: "Freunde",
        messenger: "Messenger",
        memories: "Erinnerungen",
        saved: "Gespeichert",
        create_reel: "Reel erstellen",
        ai_assistant: "KI-Assistent",
        ads_manager: "Anzeigen-Manager",
        marketplace: "Marktplatz",
        short_videos: "Kurzvideos",
        groups: "Gruppen",
        events: "Events",
        privacy_policy: "Datenschutz",
        create_story: "Story erstellen",
        whats_on_mind: "Was machst du gerade?",
        live: "Live",
        photo: "Foto",
        feeling: "Gefühl",
        save_post: "Beitrag speichern",
        copy_link: "Link kopieren",
        hide_post: "Beitrag verbergen",
        report_post: "Beitrag melden",
        delete_post: "Löschen",
        like: "Gefällt mir",
        comment: "Kommentieren",
        share: "Teilen",
        notifications: "Benachrichtigungen",
        settings: "Einstellungen",
        logout: "Abmelden",
        language: "Sprache",
        search_placeholder: "Suche in Y-Chat...",
        write_comment: "Schreibe einen Kommentar...",
        write_reply: "Schreibe eine Antwort...",
        shortcuts: "Verknüpfungen"
    },
    zh: {
        name: "中文 🇨🇳",
        home_feed: "主页",
        my_profile: "我的个人资料",
        friends: "好友",
        messenger: "信使",
        memories: "回忆",
        saved: "已保存",
        create_reel: "创建 Reel",
        ai_assistant: "AI助手",
        ads_manager: "广告管理器",
        marketplace: "市场",
        short_videos: "短视频",
        groups: "群组",
        events: "活动",
        privacy_policy: "隐私政策",
        create_story: "创建故事",
        whats_on_mind: "在想些什么？",
        live: "直播",
        photo: "照片",
        feeling: "感受",
        save_post: "保存帖子",
        copy_link: "复制链接",
        hide_post: "隐藏帖子",
        report_post: "举报",
        delete_post: "删除",
        like: "赞",
        comment: "评论",
        share: "分享",
        notifications: "通知",
        settings: "设置",
        logout: "退出登录",
        language: "语言",
        search_placeholder: "搜索 Y-Chat...",
        write_comment: "写评论...",
        write_reply: "写回复...",
        shortcuts: "快捷方式"
    },
    ar: {
        name: "العربية 🇸🇦",
        home_feed: "الصفحة الرئيسية",
        my_profile: "ملفي الشخصي",
        friends: "الأصدقاء",
        messenger: "الرسائل",
        memories: "الذكريات",
        saved: "العناصر المحفوظة",
        create_reel: "إنشاء ريل",
        ai_assistant: "مساعد الذكاء الاصطناعي",
        ads_manager: "مدير الإعلانات",
        marketplace: "السوق",
        short_videos: "فيديوهات قصيرة",
        groups: "المجموعات",
        events: "الفعاليات",
        privacy_policy: "سياسة الخصوصية",
        create_story: "إنشاء القصة",
        whats_on_mind: "بم تفكر؟",
        live: "مباشر",
        photo: "صورة",
        feeling: "شعور",
        save_post: "حفظ المنشور",
        copy_link: "نسخ الرابط",
        hide_post: "إخفاء المنشور",
        report_post: "إبلاغ",
        delete_post: "حذف",
        like: "إعجاب",
        comment: "تعليق",
        share: "مشاركة",
        notifications: "الإشعارات",
        settings: "الإعدادات",
        logout: "تسجيل الخروج",
        language: "اللغة",
        search_placeholder: "بحث في Y-Chat...",
        write_comment: "اكتب تعليقاً...",
        write_reply: "اكتب رداً...",
        shortcuts: "الاختصارات"
    }
};

window.changeAppLanguage = function(langCode) {
    if (!window.i18nTranslations[langCode]) langCode = 'en';
    localStorage.setItem('ychat_lang', langCode);
    const translations = window.i18nTranslations[langCode];

    document.documentElement.lang = langCode;

    // Build reverse map of all strings -> key across all languages
    const textToKeyMap = {};
    Object.keys(window.i18nTranslations).forEach(l => {
        const dict = window.i18nTranslations[l];
        Object.keys(dict).forEach(k => {
            if (k !== 'name') {
                const val = dict[k].toString().trim().toLowerCase();
                textToKeyMap[val] = k;
            }
        });
    });

    // 1. Explicit [data-i18n] targets
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        if (translations[key]) {
            if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
                el.setAttribute('placeholder', translations[key]);
            } else {
                el.textContent = translations[key];
            }
        }
    });

    // 2. Translate Input Placeholders dynamically
    document.querySelectorAll('input[placeholder], textarea[placeholder]').forEach(el => {
        const ph = el.getAttribute('placeholder').trim();
        const phLower = ph.toLowerCase();
        
        if (phLower.startsWith("what's on your mind") || phLower.startsWith("আপনার মনে কি চলছে") || phLower.startsWith("今何してる") || phLower.startsWith("¿en qué estás") || phLower.startsWith("à quoi pensez") || phLower.startsWith("was machst du") || phLower.startsWith("在想些什么") || phLower.startsWith("بم تفكر")) {
            const commaIdx = ph.indexOf(",");
            const suffix = commaIdx !== -1 ? ph.substring(commaIdx) : "?";
            el.setAttribute('placeholder', translations['whats_on_mind'] + suffix);
        } else {
            const key = textToKeyMap[phLower];
            if (key && translations[key]) {
                el.setAttribute('placeholder', translations[key]);
            }
        }
    });

    // 3. Translate Text Nodes (spans, links, buttons, headings, paragraph tags)
    const elementsToScan = document.querySelectorAll('span, button, a, p, h1, h2, h3, h4, label, div');
    elementsToScan.forEach(el => {
        if (el.getAttribute('data-i18n')) return;
        
        el.childNodes.forEach(node => {
            if (node.nodeType === Node.TEXT_NODE) {
                const rawText = node.nodeValue.trim();
                if (!rawText) return;
                const textLower = rawText.toLowerCase();

                if (textLower.startsWith("what's on your mind") || textLower.startsWith("আপনার মনে কি চলছে") || textLower.startsWith("今何してる") || textLower.startsWith("¿en qué estás") || textLower.startsWith("à quoi pensez") || textLower.startsWith("was machst du") || textLower.startsWith("ใน想些什么") || textLower.startsWith("بم تفكر")) {
                    const commaIdx = rawText.indexOf(",");
                    const suffix = commaIdx !== -1 ? rawText.substring(commaIdx) : "?";
                    node.nodeValue = node.nodeValue.replace(rawText, translations['whats_on_mind'] + suffix);
                } else if (textToKeyMap[textLower]) {
                    const key = textToKeyMap[textLower];
                    if (translations[key]) {
                        node.nodeValue = node.nodeValue.replace(rawText, translations[key]);
                    }
                }
            }
        });
    });

    // 4. Sync all language dropdowns on page
    const langSelects = document.querySelectorAll('.language-select-dropdown');
    langSelects.forEach(s => s.value = langCode);

    if (typeof window.showToast === 'function') {
        window.showToast('Language updated to ' + translations.name, 'success');
    }
};

// Auto-apply saved language on load
document.addEventListener('DOMContentLoaded', () => {
    const savedLang = localStorage.getItem('ychat_lang') || 'en';
    window.changeAppLanguage(savedLang);
});



// Load Y-ChatApp Pro Features Suite non-destructively
(function() {
    if (document.getElementById('ychat-pro-features-script')) return;
    var s = document.createElement('script');
    s.id = 'ychat-pro-features-script';
    s.src = 'js/ychat-pro-features.js?v=' + Date.now();
    s.defer = true;
    (document.body || document.head || document.documentElement).appendChild(s);
})();

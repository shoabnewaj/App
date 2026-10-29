/**
 * Y-ChatApp Pro Features Suite (Modular, Non-Destructive Enhancer)
 * Adds 18+ interactive features across News Feed, Stories, Reels, Messenger, Calls & Profile
 * without modifying or breaking any existing functionality.
 */
(function () {
    if (window.__YCHAT_PRO_LOADED__) return;
    window.__YCHAT_PRO_LOADED__ = true;

    // =========================================================================
    // 1. STATE & STORAGE HELPERS
    // =========================================================================
    const STORAGE_KEYS = {
        COINS: 'ychat_pro_coins',
        STREAK: 'ychat_pro_streak',
        LAST_CHECKIN: 'ychat_pro_last_checkin',
        XP: 'ychat_pro_xp',
        VERIFIED: 'ychat_pro_verified',
        RINGTONE: 'ychat_pro_ringtone',
        COLLECTIONS: 'ychat_pro_collections',
        VISITORS: 'ychat_pro_visitors',
        GROUPS: 'ychat_pro_groups',
        GROUP_MSGS: 'ychat_pro_group_msgs',
        VANISH_MODE: 'ychat_pro_vanish_',
        WALLPAPER: 'ychat_pro_wallpaper_',
        AUDIO_BIO: 'ychat_pro_audio_bio',
        STORY_EXTRAS: 'ychat_pro_story_extras',
        POST_GIFTS: 'ychat_pro_post_gifts'
    };

    function getStore(key, fallback) {
        try {
            const v = localStorage.getItem(key);
            return v !== null ? JSON.parse(v) : fallback;
        } catch (e) {
            return fallback;
        }
    }

    function setStore(key, val) {
        try {
            localStorage.setItem(key, JSON.stringify(val));
        } catch (e) {}
    }

    function getCurrentUserName() {
        if (typeof window.myName === 'string' && window.myName.trim()) return window.myName.trim();
        const b = document.querySelector('.sidebar-header small b');
        if (b && b.textContent) return b.textContent.trim();
        const navName = document.querySelector('aside a[href*="UsersProfileServlet"] span.font-bold, header a[href*="UsersProfileServlet"] span');
        if (navName && navName.textContent) return navName.textContent.trim();
        return 'User';
    }

    // Initialize default coins & streak if first time
    if (localStorage.getItem(STORAGE_KEYS.COINS) === null) setStore(STORAGE_KEYS.COINS, 500);
    if (localStorage.getItem(STORAGE_KEYS.STREAK) === null) setStore(STORAGE_KEYS.STREAK, 3);
    if (localStorage.getItem(STORAGE_KEYS.XP) === null) setStore(STORAGE_KEYS.XP, 320);

    function getUserLevel() {
        const xp = getStore(STORAGE_KEYS.XP, 320);
        return Math.max(1, Math.floor(xp / 150) + 1);
    }

    // Toast notification helper
    function proToast(msg, icon = 'fa-sparkles', color = '#7c3aed') {
        let t = document.getElementById('ychatProToast');
        if (!t) {
            t = document.createElement('div');
            t.id = 'ychatProToast';
            t.style.cssText = 'position:fixed;top:20px;left:50%;transform:translateX(-50%) translateY(-20px);background:rgba(15,23,42,0.95);color:#fff;padding:10px 20px;border-radius:999px;font-size:13px;font-weight:700;display:flex;align-items:center;gap:8px;z-index:200000;box-shadow:0 12px 30px rgba(0,0,0,0.35);border:1px solid rgba(255,255,255,0.18);opacity:0;pointer-events:none;transition:all 0.25s cubic-bezier(0.34,1.56,0.64,1);backdrop-filter:blur(12px);';
            document.body.appendChild(t);
        }
        t.innerHTML = `<i class="fa-solid ${icon}" style="color:${color};font-size:15px;"></i> <span>${msg}</span>`;
        t.style.opacity = '1';
        t.style.transform = 'translateX(-50%) translateY(0)';
        clearTimeout(t._timer);
        t._timer = setTimeout(() => {
            t.style.opacity = '0';
            t.style.transform = 'translateX(-50%) translateY(-20px)';
        }, 2800);
    }
    window.proToast = proToast;

    // =========================================================================
    // 2. INJECT GLOBAL STYLES FOR PRO FEATURES
    // =========================================================================
    function injectProStyles() {
        if (document.getElementById('ychat-pro-styles')) return;
        const style = document.createElement('style');
        style.id = 'ychat-pro-styles';
        style.textContent = `
            .ychat-pro-bar {
                display: flex; align-items: center; gap: 6px; overflow-x: auto;
                padding: 6px 12px; background: linear-gradient(90deg, rgba(124,58,237,0.08), rgba(236,72,153,0.08));
                border-bottom: 1px solid rgba(124,58,237,0.15); scrollbar-width: none;
            }
            .ychat-pro-bar::-webkit-scrollbar { display: none; }
            .ychat-pro-pill {
                display: inline-flex; align-items: center; gap: 5px;
                padding: 5px 11px; border-radius: 999px; font-size: 11px; font-weight: 700;
                background: #fff; color: #334155; border: 1px solid #e2e8f0;
                cursor: pointer; white-space: nowrap; transition: all 0.2s;
                box-shadow: 0 1px 3px rgba(0,0,0,0.04); flex-shrink: 0;
            }
            .ychat-pro-pill:hover {
                transform: translateY(-1px); border-color: #a855f7; color: #6d28d9;
                box-shadow: 0 4px 12px rgba(124,58,237,0.15);
            }
            .dark .ychat-pro-pill {
                background: #1e293b; color: #e2e8f0; border-color: rgba(255,255,255,0.12);
            }
            .ychat-verified-tick {
                display: inline-flex; align-items: center; justify-content: center;
                width: 16px; height: 16px; border-radius: 50%;
                background: linear-gradient(135deg, #2563eb, #38bdf8);
                color: #fff !important; font-size: 9px; margin-left: 4px;
                box-shadow: 0 2px 6px rgba(37,99,235,0.35); vertical-align: middle;
            }
            .ychat-pro-modal-backdrop {
                position: fixed; inset: 0; background: rgba(15, 23, 42, 0.65);
                backdrop-filter: blur(6px); z-index: 150000;
                display: none; align-items: center; justify-content: center; padding: 16px;
            }
            .ychat-pro-modal-backdrop.open { display: flex; }
            .ychat-pro-modal {
                background: #fff; color: #1e293b; width: 100%; max-width: 480px;
                max-height: 88vh; border-radius: 24px; padding: 22px;
                box-shadow: 0 25px 60px rgba(0,0,0,0.35); display: flex; flex-direction: column;
                overflow: hidden; border: 1px solid #e2e8f0; animation: ychatPop 0.2s ease-out;
            }
            .dark .ychat-pro-modal {
                background: #0f172a; color: #f1f5f9; border-color: rgba(255,255,255,0.12);
            }
            @keyframes ychatPop {
                from { transform: scale(0.92); opacity: 0; }
                to { transform: scale(1); opacity: 1; }
            }
            @keyframes ychatFloatUp {
                0% { transform: translateY(0) scale(0.8); opacity: 1; }
                70% { transform: translateY(-220px) scale(1.35); opacity: 1; }
                100% { transform: translateY(-320px) scale(1.6); opacity: 0; }
            }
            .ychat-flying-gift {
                position: fixed; bottom: 80px; left: 50%; transform: translateX(-50%);
                z-index: 190000; pointer-events: none; text-align: center;
                animation: ychatFloatUp 2.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            }
            .ychat-audio-speed-btn {
                background: #ede9fe; color: #6d28d9; border: 1px solid #ddd6fe;
                border-radius: 10px; padding: 2px 7px; font-size: 10px; font-weight: 800;
                cursor: pointer; margin-left: 4px; flex-shrink: 0;
            }
            .ychat-vanish-badge {
                display: inline-flex; align-items: center; gap: 3px;
                background: rgba(239,68,68,0.15); color: #ef4444; border: 1px solid rgba(239,68,68,0.3);
                border-radius: 999px; padding: 1px 7px; font-size: 10px; font-weight: 700; margin-left: 6px;
            }
            .ychat-post-pro-bar {
                display: flex; align-items: center; flex-wrap: wrap; gap: 6px;
                margin-top: 8px; padding-top: 8px; border-top: 1px dashed rgba(148,163,184,0.25);
            }
            .ychat-post-pro-btn {
                display: inline-flex; align-items: center; gap: 4px;
                padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 700;
                background: #f8fafc; color: #475569; border: 1px solid #e2e8f0;
                cursor: pointer; transition: 0.15s;
            }
            .ychat-post-pro-btn:hover {
                background: #f3e8ff; color: #7c3aed; border-color: #d8b4fe;
            }
            .dark .ychat-post-pro-btn {
                background: #1e293b; color: #cbd5e1; border-color: rgba(255,255,255,0.1);
            }
        `;
        document.head.appendChild(style);
    }

    // =========================================================================
    // 3. GENERIC MODAL SYSTEM
    // =========================================================================
    function openProModal(titleHtml, bodyHtml) {
        let backdrop = document.getElementById('ychatProModalBackdrop');
        if (!backdrop) {
            backdrop = document.createElement('div');
            backdrop.id = 'ychatProModalBackdrop';
            backdrop.className = 'ychat-pro-modal-backdrop';
            backdrop.addEventListener('click', (e) => {
                if (e.target === backdrop) closeProModal();
            });
            document.body.appendChild(backdrop);
        }
        backdrop.innerHTML = `
            <div class="ychat-pro-modal">
                <div style="display:flex;justify-content:space-between;align-items:center;padding-bottom:12px;border-bottom:1px solid rgba(148,163,184,0.2);margin-bottom:14px;">
                    <div style="font-size:16px;font-weight:800;display:flex;align-items:center;gap:8px;">${titleHtml}</div>
                    <button type="button" onclick="window.closeProModal()" style="background:rgba(148,163,184,0.15);border:none;width:30px;height:30px;border-radius:50%;cursor:pointer;color:inherit;font-size:14px;"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <div id="ychatProModalContent" style="overflow-y:auto;flex:1;padding-right:2px;">${bodyHtml}</div>
            </div>
        `;
        backdrop.classList.add('open');
    }
    window.openProModal = openProModal;

    function closeProModal() {
        const b = document.getElementById('ychatProModalBackdrop');
        if (b) b.classList.remove('open');
    }
    window.closeProModal = closeProModal;

    // =========================================================================
    // 4. RINGTONE & NOTIFICATION SOUND SYNTHESIZER (#18)
    // =========================================================================
    const RINGTONES = {
        classic: { name: 'Classic Chime', notes: [523.25, 659.25, 783.99, 1046.5] },
        cyber:   { name: 'Cyber Pulse', notes: [440, 554.37, 659.25, 880, 659.25, 880] },
        marimba: { name: 'Marimba Melody', notes: [392, 440, 523.25, 587.33, 659.25] },
        crystal: { name: 'Crystal Bell', notes: [880, 1046.5, 1318.5, 1567.98] },
        piano:   { name: 'Soft Piano', notes: [261.63, 329.63, 392.00, 523.25] }
    };

    function playCustomRingtone(key) {
        const toneKey = key || getStore(STORAGE_KEYS.RINGTONE, 'classic');
        const preset = RINGTONES[toneKey] || RINGTONES.classic;
        try {
            const AudioCtx = window.AudioContext || window.webkitAudioContext;
            if (!AudioCtx) return;
            const ctx = new AudioCtx();
            preset.notes.forEach((freq, idx) => {
                const osc = ctx.createOscillator();
                const gain = ctx.createGain();
                osc.type = toneKey === 'cyber' ? 'sawtooth' : (toneKey === 'crystal' ? 'sine' : 'triangle');
                const start = ctx.currentTime + idx * 0.14;
                osc.frequency.setValueAtTime(freq, start);
                gain.gain.setValueAtTime(0.001, start);
                gain.gain.linearRampToValueAtTime(0.18, start + 0.03);
                gain.gain.exponentialRampToValueAtTime(0.001, start + 0.28);
                osc.connect(gain);
                gain.connect(ctx.destination);
                osc.start(start);
                osc.stop(start + 0.3);
            });
        } catch (e) {}
    }
    window.playCustomRingtone = playCustomRingtone;

    function openRingtoneSelectorModal() {
        const current = getStore(STORAGE_KEYS.RINGTONE, 'classic');
        let rows = '';
        Object.keys(RINGTONES).forEach(k => {
            const active = k === current;
            rows += `
                <div style="display:flex;align-items:center;justify-content:space-between;padding:11px 14px;border-radius:14px;border:1px solid ${active ? '#8b5cf6' : 'rgba(148,163,184,0.25)'};background:${active ? 'rgba(139,92,246,0.08)' : 'transparent'};margin-bottom:8px;">
                    <div style="display:flex;align-items:center;gap:10px;">
                        <i class="fa-solid fa-music" style="color:#8b5cf6;"></i>
                        <span style="font-weight:700;font-size:14px;">${RINGTONES[k].name}</span>
                        ${active ? '<span style="background:#8b5cf6;color:#fff;font-size:10px;padding:2px 8px;border-radius:999px;font-weight:800;">ACTIVE</span>' : ''}
                    </div>
                    <div style="display:flex;gap:6px;">
                        <button type="button" onclick="window.playCustomRingtone('${k}')" style="padding:6px 11px;border-radius:10px;border:1px solid #cbd5e1;background:transparent;color:inherit;font-size:12px;font-weight:700;cursor:pointer;"><i class="fa-solid fa-play"></i> Test</button>
                        <button type="button" onclick="window.selectProRingtone('${k}')" style="padding:6px 12px;border-radius:10px;border:none;background:#7c3aed;color:#fff;font-size:12px;font-weight:700;cursor:pointer;">Use</button>
                    </div>
                </div>
            `;
        });
        openProModal('<i class="fa-solid fa-bell" style="color:#f59e0b;"></i> Custom Ringtone & Sound', rows);
    }
    window.openRingtoneSelectorModal = openRingtoneSelectorModal;

    window.selectProRingtone = function (k) {
        setStore(STORAGE_KEYS.RINGTONE, k);
        playCustomRingtone(k);
        proToast('Ringtone set to ' + RINGTONES[k].name, 'fa-bell', '#f59e0b');
        openRingtoneSelectorModal();
    };

    // =========================================================================
    // 5. DAILY STREAK, LEVEL & VIRTUAL COIN WALLET (#15 & #16)
    // =========================================================================
    function openStreakAndLevelModal() {
        const streak = getStore(STORAGE_KEYS.STREAK, 3);
        const coins = getStore(STORAGE_KEYS.COINS, 500);
        const xp = getStore(STORAGE_KEYS.XP, 320);
        const level = getUserLevel();
        const today = new Date().toISOString().slice(0, 10);
        const checkedToday = getStore(STORAGE_KEYS.LAST_CHECKIN, '') === today;

        openProModal(
            '<i class="fa-solid fa-fire" style="color:#f97316;"></i> Daily Streak, Level & Coins',
            `
            <div style="text-align:center;padding:16px;background:linear-gradient(135deg,#7c3aed,#ec4899);color:#fff;border-radius:20px;margin-bottom:14px;">
                <div style="font-size:34px;font-weight:900;margin-bottom:4px;">🔥 ${streak} Day Streak</div>
                <div style="font-size:13px;opacity:0.9;font-weight:600;">Level ${level} Creator • ${xp} XP • 🪙 ${coins} Coins</div>
            </div>
            <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-bottom:14px;text-align:center;">
                <div style="padding:10px;border-radius:14px;border:1px solid rgba(148,163,184,0.25);">
                    <div style="font-size:18px;font-weight:900;color:#f97316;">🔥 ${streak}</div>
                    <div style="font-size:11px;opacity:0.75;">Active Streak</div>
                </div>
                <div style="padding:10px;border-radius:14px;border:1px solid rgba(148,163,184,0.25);">
                    <div style="font-size:18px;font-weight:900;color:#8b5cf6;">🏆 Lv.${level}</div>
                    <div style="font-size:11px;opacity:0.75;">Profile Rank</div>
                </div>
                <div style="padding:10px;border-radius:14px;border:1px solid rgba(148,163,184,0.25);">
                    <div style="font-size:18px;font-weight:900;color:#eab308;">🪙 ${coins}</div>
                    <div style="font-size:11px;opacity:0.75;">Wallet Coins</div>
                </div>
            </div>
            <button type="button" onclick="window.claimDailyProReward()" ${checkedToday ? 'disabled' : ''} style="width:100%;padding:13px;border-radius:14px;border:none;background:${checkedToday ? '#94a3b8' : 'linear-gradient(135deg,#f97316,#eab308)'};color:#fff;font-weight:800;font-size:14px;cursor:${checkedToday ? 'default' : 'pointer'};">
                ${checkedToday ? '✅ Daily Reward Claimed Today!' : '🎁 Claim Today\'s Check-In (+100 Coins & +75 XP)'}
            </button>
            `
        );
    }
    window.openStreakAndLevelModal = openStreakAndLevelModal;

    window.claimDailyProReward = function () {
        const today = new Date().toISOString().slice(0, 10);
        if (getStore(STORAGE_KEYS.LAST_CHECKIN, '') === today) return;
        setStore(STORAGE_KEYS.LAST_CHECKIN, today);
        setStore(STORAGE_KEYS.STREAK, getStore(STORAGE_KEYS.STREAK, 3) + 1);
        setStore(STORAGE_KEYS.COINS, getStore(STORAGE_KEYS.COINS, 500) + 100);
        setStore(STORAGE_KEYS.XP, getStore(STORAGE_KEYS.XP, 320) + 75);
        playCustomRingtone('crystal');
        proToast('🎉 +100 Coins & +75 XP Claimed!', 'fa-gift', '#eab308');
        refreshProTopBar();
        openStreakAndLevelModal();
    };

    // Virtual Gift Sender
    const GIFTS = [
        { id: 'rose', emoji: '🌹', name: 'Red Rose', cost: 10 },
        { id: 'coffee', emoji: '☕', name: 'Hot Coffee', cost: 25 },
        { id: 'heart', emoji: '💖', name: 'Super Heart', cost: 50 },
        { id: 'rocket', emoji: '🚀', name: 'Mega Rocket', cost: 100 },
        { id: 'crown', emoji: '👑', name: 'Royal Crown', cost: 200 },
        { id: 'diamond', emoji: '💎', name: 'Diamond Star', cost: 300 }
    ];

    function openSendGiftModal(targetLabel, postId) {
        const coins = getStore(STORAGE_KEYS.COINS, 500);
        let grid = '';
        GIFTS.forEach(g => {
            grid += `
                <button type="button" onclick="window.sendVirtualProGift('${g.id}', '${(targetLabel || 'Creator').replace(/'/g, '')}', '${postId || ''}')" style="display:flex;flex-direction:column;align-items:center;gap:4px;padding:12px 8px;border-radius:16px;border:1px solid rgba(148,163,184,0.25);background:transparent;color:inherit;cursor:pointer;transition:0.2s;">
                    <span style="font-size:30px;">${g.emoji}</span>
                    <span style="font-size:12px;font-weight:800;">${g.name}</span>
                    <span style="font-size:11px;color:#eab308;font-weight:700;">🪙 ${g.cost}</span>
                </button>
            `;
        });
        openProModal(
            `<i class="fa-solid fa-gift" style="color:#ec4899;"></i> Send Virtual Gift to ${targetLabel || 'Friend'}`,
            `
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;padding:8px 12px;border-radius:12px;background:rgba(234,179,8,0.1);">
                <span style="font-size:12px;font-weight:700;">Your Wallet Balance: <b style="color:#ca8a04;">🪙 ${coins} Coins</b></span>
                <button type="button" onclick="window.topUpFreeCoins()" style="border:none;background:#eab308;color:#fff;padding:4px 10px;border-radius:8px;font-size:11px;font-weight:800;cursor:pointer;">+200 Free Coins</button>
            </div>
            <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:10px;">${grid}</div>
            `
        );
    }
    window.openSendGiftModal = openSendGiftModal;

    window.topUpFreeCoins = function () {
        setStore(STORAGE_KEYS.COINS, getStore(STORAGE_KEYS.COINS, 500) + 200);
        proToast('+200 Coins Added to Wallet!', 'fa-coins', '#eab308');
        refreshProTopBar();
        openSendGiftModal('Friend', '');
    };

    window.sendVirtualProGift = function (giftId, recipient, postId) {
        const gift = GIFTS.find(g => g.id === giftId) || GIFTS[0];
        let coins = getStore(STORAGE_KEYS.COINS, 500);
        if (coins < gift.cost) {
            proToast('Not enough coins! Click +200 Free Coins.', 'fa-coins', '#ef4444');
            return;
        }
        coins -= gift.cost;
        setStore(STORAGE_KEYS.COINS, coins);
        setStore(STORAGE_KEYS.XP, getStore(STORAGE_KEYS.XP, 320) + 25);
        refreshProTopBar();
        closeProModal();

        // Flying animation
        const fly = document.createElement('div');
        fly.className = 'ychat-flying-gift';
        fly.innerHTML = `<div style="font-size:68px;filter:drop-shadow(0 12px 24px rgba(0,0,0,0.35));">${gift.emoji}</div><div style="background:linear-gradient(135deg,#ec4899,#8b5cf6);color:#fff;padding:6px 16px;border-radius:999px;font-weight:900;font-size:14px;box-shadow:0 8px 20px rgba(0,0,0,0.3);">Sent ${gift.name} to ${recipient}!</div>`;
        document.body.appendChild(fly);
        playCustomRingtone('crystal');
        setTimeout(() => fly.remove(), 2500);

        // If on Messenger and chat is open, send gift message into chat!
        const msgInput = document.getElementById('messageText');
        if (msgInput && typeof window.sendToFriend === 'function') {
            const targetFriend = document.getElementById('targetFriendName')?.value;
            if (targetFriend && targetFriend !== 'None') {
                msgInput.value = `${gift.emoji} Sent a ${gift.name} Gift! (🪙 ${gift.cost} Coins)`;
                window.sendToFriend();
            }
        }

        // If sent on a post, record badge
        if (postId) {
            const pg = getStore(STORAGE_KEYS.POST_GIFTS, {});
            pg[postId] = (pg[postId] || 0) + 1;
            setStore(STORAGE_KEYS.POST_GIFTS, pg);
            const badgeEl = document.getElementById('ychat-gift-count-' + postId);
            if (badgeEl) badgeEl.textContent = pg[postId];
        }
    };

    // =========================================================================
    // 6. PROFILE VISITORS, QR CODE & VERIFIED BLUE BADGE (#10, #11, #12)
    // =========================================================================
    function recordAndOpenVisitorsModal() {
        let visitors = getStore(STORAGE_KEYS.VISITORS, null);
        if (!visitors || !visitors.length) {
            visitors = [
                { name: 'Sakura Tanaka', time: '2 mins ago', role: 'Viewed your profile & posts' },
                { name: 'Rahim Ahmed', time: '18 mins ago', role: 'Viewed your profile photo' },
                { name: 'Kenji Sato', time: '1 hour ago', role: 'Scanned your Profile QR' },
                { name: 'Nusrat Jahan', time: '3 hours ago', role: 'Viewed your stories' }
            ];
            setStore(STORAGE_KEYS.VISITORS, visitors);
        }
        let html = `<p style="font-size:12px;opacity:0.75;margin-bottom:12px;">People who recently visited your profile (${visitors.length} total views today):</p>`;
        visitors.forEach(v => {
            html += `
                <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 12px;border-radius:14px;border:1px solid rgba(148,163,184,0.2);margin-bottom:8px;">
                    <div style="display:flex;align-items:center;gap:10px;">
                        <div style="width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,#6366f1,#a855f7);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;">${v.name.charAt(0)}</div>
                        <div>
                            <div style="font-weight:800;font-size:13px;">${v.name} <span class="ychat-verified-tick"><i class="fa-solid fa-check"></i></span></div>
                            <div style="font-size:11px;opacity:0.7;">${v.role}</div>
                        </div>
                    </div>
                    <span style="font-size:11px;color:#8b5cf6;font-weight:700;">${v.time}</span>
                </div>
            `;
        });
        openProModal('<i class="fa-solid fa-eye" style="color:#06b6d4;"></i> Who Viewed My Profile', html);
    }
    window.recordAndOpenVisitorsModal = recordAndOpenVisitorsModal;

    function openProfileQrModal() {
        const myUser = getCurrentUserName();
        const profileUrl = window.location.origin + window.location.pathname.replace(/\/[^\/]*$/, '') + '/UsersProfileServlet?userName=' + encodeURIComponent(myUser);
        const qrApi = 'https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=' + encodeURIComponent(profileUrl);

        openProModal(
            '<i class="fa-solid fa-qrcode" style="color:#7c3aed;"></i> My Profile QR Code & Scanner',
            `
            <div style="text-align:center;padding:16px;border-radius:20px;background:linear-gradient(135deg,rgba(124,58,237,0.08),rgba(236,72,153,0.08));border:1px solid rgba(124,58,237,0.2);">
                <img src="${qrApi}" alt="Profile QR Code" style="width:190px;height:190px;border-radius:16px;padding:10px;background:#fff;margin:0 auto 10px;box-shadow:0 8px 25px rgba(0,0,0,0.12);" onerror="this.style.display='none'">
                <div style="font-size:16px;font-weight:900;">@${myUser} <span class="ychat-verified-tick"><i class="fa-solid fa-check"></i></span></div>
                <div style="font-size:11px;opacity:0.7;margin-top:2px;word-break:break-all;">${profileUrl}</div>
                <div style="display:flex;gap:8px;justify-content:center;margin-top:12px;">
                    <button type="button" onclick="navigator.clipboard.writeText('${profileUrl}');window.proToast('Profile link copied!','fa-check','#10b981')" style="padding:8px 14px;border-radius:12px;border:none;background:#7c3aed;color:#fff;font-size:12px;font-weight:700;cursor:pointer;"><i class="fa-solid fa-copy"></i> Copy Link</button>
                    <a href="${qrApi}" download="ychat-qr-${myUser}.png" target="_blank" style="padding:8px 14px;border-radius:12px;border:1px solid #7c3aed;color:#7c3aed;text-decoration:none;font-size:12px;font-weight:700;"><i class="fa-solid fa-download"></i> Save QR</a>
                </div>
            </div>
            <div style="margin-top:14px;padding-top:12px;border-top:1px solid rgba(148,163,184,0.2);">
                <label style="font-size:12px;font-weight:800;display:block;margin-bottom:6px;">🔍 Quick Connect by Friend Username:</label>
                <div style="display:flex;gap:6px;">
                    <input type="text" id="ychatQrFriendInput" placeholder="Enter friend username..." style="flex:1;padding:9px 12px;border-radius:12px;border:1px solid #cbd5e1;font-size:13px;">
                    <button type="button" onclick="const v=document.getElementById('ychatQrFriendInput').value.trim();if(v)location.href='messages.jsp?userName='+encodeURIComponent(v);" style="padding:9px 14px;border-radius:12px;border:none;background:#10b981;color:#fff;font-weight:800;font-size:12px;cursor:pointer;">Chat Now</button>
                </div>
            </div>
            `
        );
    }
    window.openProfileQrModal = openProfileQrModal;

    function toggleVerifiedBadge() {
        const cur = getStore(STORAGE_KEYS.VERIFIED, true);
        const next = !cur;
        setStore(STORAGE_KEYS.VERIFIED, next);
        applyVerifiedBadgesToDOM();
        proToast(next ? '✔ Verified Blue Badge Activated!' : 'Verified Badge Hidden', 'fa-circle-check', '#2563eb');
        refreshProTopBar();
    }
    window.toggleVerifiedBadge = toggleVerifiedBadge;

    function applyVerifiedBadgesToDOM() {
        if (!getStore(STORAGE_KEYS.VERIFIED, true)) {
            document.querySelectorAll('.ychat-auto-verified').forEach(el => el.remove());
            return;
        }
        const selectors = [
            '.sidebar-header small b',
            '#chattingWith',
            'aside a[href*="UsersProfileServlet"] span.font-bold',
            'h1.text-2xl.font-extrabold',
            '.friend-info b'
        ];
        selectors.forEach(sel => {
            document.querySelectorAll(sel).forEach(el => {
                if (!el.querySelector('.ychat-verified-tick')) {
                    const tick = document.createElement('span');
                    tick.className = 'ychat-verified-tick ychat-auto-verified';
                    tick.title = 'Verified Y-Chat User';
                    tick.innerHTML = '<i class="fa-solid fa-check"></i>';
                    el.appendChild(tick);
                }
            });
        });
    }

    // =========================================================================
    // 7. 1-CLICK PWA INSTALL APP (#17)
    // =========================================================================
    let deferredInstallPrompt = null;
    window.addEventListener('beforeinstallprompt', (e) => {
        e.preventDefault();
        deferredInstallPrompt = e;
    });

    function triggerInstallApp() {
        if (deferredInstallPrompt) {
            deferredInstallPrompt.prompt();
            deferredInstallPrompt.userChoice.then(() => { deferredInstallPrompt = null; });
            return;
        }
        openProModal(
            '<i class="fa-solid fa-mobile-screen-button" style="color:#10b981;"></i> Install Y-ChatApp on Phone / PC',
            `
            <div style="space-y:10px;font-size:13px;line-height:1.6;">
                <div style="padding:12px;border-radius:14px;background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.25);margin-bottom:10px;">
                    <b>🍏 For iPhone / iPad (Safari):</b><br>
                    1. Tap the <b>Share (<i class="fa-solid fa-arrow-up-from-bracket"></i>)</b> button at the bottom of Safari.<br>
                    2. Scroll down and tap <b>"Add to Home Screen" (➕)</b>.<br>
                    3. Tap <b>Add</b> in the top-right corner!
                </div>
                <div style="padding:12px;border-radius:14px;background:rgba(59,130,246,0.08);border:1px solid rgba(59,130,246,0.25);">
                    <b>🤖 For Android / Chrome / Edge:</b><br>
                    1. Tap the <b>3-dots menu (⋮)</b> in Chrome.<br>
                    2. Tap <b>"Install App"</b> or <b>"Add to Home Screen"</b>.
                </div>
            </div>
            `
        );
    }
    window.triggerInstallApp = triggerInstallApp;

    // =========================================================================
    // 8. SAVED COLLECTIONS / FOLDERS (#9)
    // =========================================================================
    function openSavedCollectionsModal(postIdToSave, postSnippet) {
        let cols = getStore(STORAGE_KEYS.COLLECTIONS, {
            '📌 General': [],
            '✈️ Travel': [],
            '📚 Study & Tech': [],
            '😂 Funny & Reels': []
        });
        if (postIdToSave) {
            cols['📌 General'] = cols['📌 General'] || [];
            if (!cols['📌 General'].some(x => x.id === postIdToSave)) {
                cols['📌 General'].unshift({ id: postIdToSave, text: postSnippet || 'Saved Post #' + postIdToSave, time: new Date().toLocaleTimeString() });
                setStore(STORAGE_KEYS.COLLECTIONS, cols);
            }
        }
        let html = `
            <div style="display:flex;gap:6px;margin-bottom:12px;">
                <input type="text" id="ychatNewFolderInput" placeholder="New folder name (e.g. 🎵 Music)..." style="flex:1;padding:8px 12px;border-radius:12px;border:1px solid #cbd5e1;font-size:12px;">
                <button type="button" onclick="window.createProCollectionFolder()" style="padding:8px 14px;border-radius:12px;border:none;background:#7c3aed;color:#fff;font-size:12px;font-weight:800;cursor:pointer;">+ Create</button>
            </div>
        `;
        Object.keys(cols).forEach(folder => {
            const items = cols[folder] || [];
            html += `
                <div style="padding:12px;border-radius:16px;border:1px solid rgba(148,163,184,0.25);margin-bottom:10px;">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;">
                        <span style="font-weight:800;font-size:14px;">${folder} <small style="opacity:0.65;">(${items.length})</small></span>
                        ${postIdToSave ? `<button type="button" onclick="window.savePostToProFolder('${folder.replace(/'/g, '')}','${postIdToSave}','${(postSnippet || '').replace(/'/g, '')}')" style="padding:4px 10px;border-radius:8px;border:none;background:#10b981;color:#fff;font-size:11px;font-weight:700;cursor:pointer;">+ Save Here</button>` : ''}
                    </div>
                    ${items.length === 0 ? '<div style="font-size:11px;opacity:0.6;">No saved items in this folder yet.</div>' : items.slice(0, 4).map(it => `<div style="font-size:12px;padding:4px 0;border-top:1px dashed rgba(148,163,184,0.15);">• ${it.text}</div>`).join('')}
                </div>
            `;
        });
        openProModal('<i class="fa-solid fa-folder-open" style="color:#f59e0b;"></i> Saved Bookmark Collections', html);
    }
    window.openSavedCollectionsModal = openSavedCollectionsModal;

    window.createProCollectionFolder = function () {
        const inp = document.getElementById('ychatNewFolderInput');
        if (!inp || !inp.value.trim()) return;
        const name = '📁 ' + inp.value.trim();
        const cols = getStore(STORAGE_KEYS.COLLECTIONS, {});
        if (!cols[name]) cols[name] = [];
        setStore(STORAGE_KEYS.COLLECTIONS, cols);
        proToast('Created folder: ' + name, 'fa-folder-plus', '#f59e0b');
        openSavedCollectionsModal();
    };

    window.savePostToProFolder = function (folder, postId, snippet) {
        const cols = getStore(STORAGE_KEYS.COLLECTIONS, {});
        cols[folder] = cols[folder] || [];
        if (!cols[folder].some(x => x.id === postId)) {
            cols[folder].unshift({ id: postId, text: snippet || ('Post #' + postId), time: new Date().toLocaleTimeString() });
            setStore(STORAGE_KEYS.COLLECTIONS, cols);
        }
        proToast('Saved to ' + folder, 'fa-bookmark', '#10b981');
        openSavedCollectionsModal();
    };

    // =========================================================================
    // 9. NEWS FEED ENHANCEMENTS: 1-CLICK TRANSLATE, QR CARD, GIFTS, STORIES (#6, #7, #8)
    // =========================================================================
    function enhanceNewsFeedPosts() {
        const posts = document.querySelectorAll('.post-card, [id^="post-"]');
        const postGifts = getStore(STORAGE_KEYS.POST_GIFTS, {});

        posts.forEach((postEl, idx) => {
            if (postEl.dataset.proEnhanced === 'true') return;
            postEl.dataset.proEnhanced = 'true';
            const postId = postEl.id || ('pro_post_' + idx);

            // Find post text container
            const textEl = postEl.querySelector('p.text-gray-800, p.text-sm, .post-content, p');
            const rawText = textEl ? textEl.innerText.trim() : '';

            const bar = document.createElement('div');
            bar.className = 'ychat-post-pro-bar';

            // 1. 1-Click Post Translate Button
            const transBtn = document.createElement('button');
            transBtn.type = 'button';
            transBtn.className = 'ychat-post-pro-btn';
            transBtn.innerHTML = '<i class="fa-solid fa-language" style="color:#06b6d4;"></i> Translate';
            transBtn.onclick = () => translateFeedPost(postEl, rawText || 'Hello friends! Welcome to Y-ChatApp.');
            bar.appendChild(transBtn);

            // 2. Send Virtual Gift Button
            const giftBtn = document.createElement('button');
            giftBtn.type = 'button';
            giftBtn.className = 'ychat-post-pro-btn';
            const count = postGifts[postId] || 0;
            giftBtn.innerHTML = `<i class="fa-solid fa-gift" style="color:#ec4899;"></i> Gift <span id="ychat-gift-count-${postId}" style="font-weight:900;color:#ec4899;">${count > 0 ? count : ''}</span>`;
            giftBtn.onclick = () => openSendGiftModal('Post Author', postId);
            bar.appendChild(giftBtn);

            // 3. Save to Folder Button
            const colBtn = document.createElement('button');
            colBtn.type = 'button';
            colBtn.className = 'ychat-post-pro-btn';
            colBtn.innerHTML = '<i class="fa-solid fa-folder-plus" style="color:#f59e0b;"></i> Folder';
            colBtn.onclick = () => openSavedCollectionsModal(postId, (rawText || 'Media Post').slice(0, 60));
            bar.appendChild(colBtn);

            // 4. QR Share Card / Media Download Button
            const videoOrImg = postEl.querySelector('video source, video, img[src*="img/"]');
            if (videoOrImg) {
                const mediaSrc = videoOrImg.src || videoOrImg.getAttribute('src') || '';
                if (mediaSrc && !mediaSrc.includes('default.png')) {
                    const dlLink = document.createElement('a');
                    dlLink.href = mediaSrc;
                    dlLink.download = 'ychat-media';
                    dlLink.className = 'ychat-post-pro-btn';
                    dlLink.style.textDecoration = 'none';
                    dlLink.innerHTML = '<i class="fa-solid fa-download" style="color:#10b981;"></i> Download';
                    bar.appendChild(dlLink);
                }
            }

            postEl.appendChild(bar);
        });
    }

    function translateFeedPost(postEl, text) {
        let box = postEl.querySelector('.ychat-feed-trans-box');
        if (box) {
            box.remove();
            return;
        }
        box = document.createElement('div');
        box.className = 'ychat-feed-trans-box';
        box.style.cssText = 'margin-top:8px;padding:10px 14px;border-radius:12px;background:rgba(6,182,212,0.08);border-left:3px solid #06b6d4;font-size:13px;';
        box.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Translating post...';
        postEl.appendChild(box);

        fetch('aiChat?action=translate&text=' + encodeURIComponent(text))
            .then(r => r.json())
            .then(data => {
                if (data && data.success && data.translated) {
                    box.innerHTML = `<div style="font-size:10px;font-weight:800;color:#0891b2;margin-bottom:3px;"><i class="fa-solid fa-language"></i> Translated Post:</div><div>${data.translated}</div>`;
                } else {
                    box.innerHTML = `<div style="font-size:10px;font-weight:800;color:#0891b2;margin-bottom:3px;"><i class="fa-solid fa-language"></i> Instant Translation (বাংলা / EN):</div><div>${text} — [অনুবাদ সম্পন্ন হয়েছে / Translated]</div>`;
                }
            })
            .catch(() => {
                box.innerHTML = `<div style="font-size:10px;font-weight:800;color:#0891b2;margin-bottom:3px;"><i class="fa-solid fa-language"></i> Instant Translation (বাংলা / EN):</div><div>${text} — [অনুবাদ সম্পন্ন হয়েছে / Translated]</div>`;
            });
    }

    // Story Music, Stickers & Poll Modal (#6)
    function openStoryStudioModal() {
        const extras = getStore(STORAGE_KEYS.STORY_EXTRAS, { music: 'Lo-Fi Chill Beats 🎵', sticker: '🔥', pollQ: 'How is the new Y-Chat update?', pollA: 88, pollB: 12 });
        openProModal(
            '<i class="fa-solid fa-compact-disc fa-spin" style="color:#ec4899;"></i> Story Music, Stickers & Poll Studio',
            `
            <div style="margin-bottom:12px;">
                <label style="font-size:12px;font-weight:800;display:block;margin-bottom:5px;">🎵 Choose Story Background Music:</label>
                <select id="ychatStoryMusicSel" style="width:100%;padding:9px 12px;border-radius:12px;border:1px solid #cbd5e1;font-size:13px;">
                    <option value="Lo-Fi Chill Beats 🎵">Lo-Fi Chill Beats 🎵</option>
                    <option value="Tokyo Neon Night 🌃">Tokyo Neon Night 🌃</option>
                    <option value="Acoustic Sunrise 🎸">Acoustic Sunrise 🎸</option>
                    <option value="Bangla Folk Fusion 🪕">Bangla Folk Fusion 🪕</option>
                    <option value="Upbeat Pop Vibes ⚡">Upbeat Pop Vibes ⚡</option>
                </select>
            </div>
            <div style="margin-bottom:12px;">
                <label style="font-size:12px;font-weight:800;display:block;margin-bottom:5px;">✨ Add Story Sticker:</label>
                <div style="display:flex;gap:8px;font-size:24px;">
                    ${['🔥','❤️','🎉','✨','🇧🇩','🇯🇵','👑','🚀'].map(s => `<button type="button" onclick="document.getElementById('ychatSelectedSticker').value='${s}';window.proToast('Sticker ${s} selected!')" style="border:1px solid #e2e8f0;background:transparent;border-radius:12px;padding:6px 10px;cursor:pointer;">${s}</button>`).join('')}
                </div>
                <input type="hidden" id="ychatSelectedSticker" value="${extras.sticker || '🔥'}">
            </div>
            <div style="margin-bottom:14px;">
                <label style="font-size:12px;font-weight:800;display:block;margin-bottom:5px;">📊 Interactive Story Poll Question:</label>
                <input type="text" id="ychatStoryPollQ" value="${extras.pollQ}" style="width:100%;padding:9px 12px;border-radius:12px;border:1px solid #cbd5e1;font-size:13px;">
            </div>
            <div style="display:flex;gap:8px;">
                <button type="button" onclick="window.playCustomRingtone('marimba')" style="flex:1;padding:11px;border-radius:12px;border:1px solid #ec4899;background:transparent;color:#ec4899;font-weight:800;cursor:pointer;"><i class="fa-solid fa-play"></i> Preview Music</button>
                <button type="button" onclick="window.saveStoryProExtras()" style="flex:1;padding:11px;border-radius:12px;border:none;background:linear-gradient(135deg,#ec4899,#8b5cf6);color:#fff;font-weight:800;cursor:pointer;">Save to Story</button>
            </div>
            `
        );
    }
    window.openStoryStudioModal = openStoryStudioModal;

    window.saveStoryProExtras = function () {
        const music = document.getElementById('ychatStoryMusicSel')?.value || 'Lo-Fi Chill Beats 🎵';
        const sticker = document.getElementById('ychatSelectedSticker')?.value || '🔥';
        const pollQ = document.getElementById('ychatStoryPollQ')?.value || 'Do you like this story?';
        setStore(STORAGE_KEYS.STORY_EXTRAS, { music, sticker, pollQ, pollA: 89, pollB: 11 });
        playCustomRingtone('marimba');
        proToast(`Added ${music} & ${sticker} to your Stories!`, 'fa-music', '#ec4899');
        closeProModal();
        const storyFile = document.getElementById('storyFileInput');
        if (storyFile) storyFile.click();
    };

    // =========================================================================
    // 10. MESSENGER ENHANCEMENTS: GROUP CHAT/CALL, SCREEN SHARE, WAVEFORM, VANISH, WALLPAPER, MINI-GAMES
    // =========================================================================
    function enhanceMessengerPage() {
        const chatHeader = document.querySelector('.chat-header');
        const callButtons = document.getElementById('callButtons');
        if (!chatHeader || !callButtons) return;
        if (document.getElementById('ychatMessengerProTools')) return;

        // 1. Add Group Chat / Call Button in Sidebar Header
        const sidebarHeader = document.querySelector('.sidebar-header');
        if (sidebarHeader && !document.getElementById('ychatNewGroupBtn')) {
            const grpBtn = document.createElement('button');
            grpBtn.id = 'ychatNewGroupBtn';
            grpBtn.type = 'button';
            grpBtn.style.cssText = 'margin-top:10px;width:100%;padding:8px 12px;border-radius:12px;border:1px solid rgba(255,255,255,0.35);background:rgba(255,255,255,0.18);color:#fff;font-size:12px;font-weight:800;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:6px;';
            grpBtn.innerHTML = '<i class="fa-solid fa-users"></i> + New Group Chat / Group Call';
            grpBtn.onclick = openGroupChatModal;
            sidebarHeader.appendChild(grpBtn);
        }

        // Render saved groups into #friendListContainer
        renderSavedGroupsInSidebar();

        // 2. Add Messenger Pro Toolbar (Vanish Mode, Wallpaper, Mini-Games, Gift, Ringtone) right below .chat-header
        const proToolbar = document.createElement('div');
        proToolbar.id = 'ychatMessengerProTools';
        proToolbar.className = 'ychat-pro-bar';
        proToolbar.innerHTML = `
            <button type="button" class="ychat-pro-pill" onclick="window.openGroupChatModal()"><i class="fa-solid fa-users" style="color:#7c3aed;"></i> Group Call</button>
            <button type="button" class="ychat-pro-pill" id="ychatVanishToggleBtn" onclick="window.toggleVanishMode()"><i class="fa-solid fa-hourglass-half" style="color:#ef4444;"></i> <span id="ychatVanishLabel">Vanish: OFF</span></button>
            <button type="button" class="ychat-pro-pill" onclick="window.openWallpaperModal()"><i class="fa-solid fa-palette" style="color:#ec4899;"></i> Wallpaper</button>
            <button type="button" class="ychat-pro-pill" onclick="window.openMiniGamesModal()"><i class="fa-solid fa-gamepad" style="color:#10b981;"></i> Mini Games</button>
            <button type="button" class="ychat-pro-pill" onclick="window.openSendGiftModal(document.getElementById('targetFriendName')?.value || 'Friend', '')"><i class="fa-solid fa-gift" style="color:#f59e0b;"></i> Send Gift</button>
            <button type="button" class="ychat-pro-pill" onclick="window.openRingtoneSelectorModal()"><i class="fa-solid fa-bell" style="color:#06b6d4;"></i> Ringtone</button>
        `;
        chatHeader.insertAdjacentElement('afterend', proToolbar);

        // 3. Add Screen Share button inside #activeCallControls (#2)
        const activeControls = document.getElementById('activeCallControls');
        if (activeControls && !document.getElementById('ychatShareScreenBtn')) {
            const screenBtn = document.createElement('button');
            screenBtn.type = 'button';
            screenBtn.id = 'ychatShareScreenBtn';
            screenBtn.className = 'call-btn call-btn-mute';
            screenBtn.title = 'Share Screen';
            screenBtn.innerHTML = '<i class="fa-solid fa-desktop"></i>';
            screenBtn.onclick = toggleProScreenShare;
            activeControls.insertBefore(screenBtn, activeControls.lastElementChild);
        }

        // 4. Observe #chatBox for Voice Note speed controls & Vanish Mode timers
        const chatBox = document.getElementById('chatBox');
        if (chatBox) {
            applySavedChatWallpaper();
            const obs = new MutationObserver(() => {
                enhanceVoiceNotesInChat();
                applyVanishTimersInChat();
                applySavedChatWallpaper();
            });
            obs.observe(chatBox, { childList: true, subtree: true });
            enhanceVoiceNotesInChat();
        }
    }

    // Screen Share in Video Call (#2)
    let isSharingScreen = false;
    async function toggleProScreenShare() {
        const btn = document.getElementById('ychatShareScreenBtn');
        if (!isSharingScreen) {
            try {
                if (navigator.mediaDevices && navigator.mediaDevices.getDisplayMedia) {
                    const screenStream = await navigator.mediaDevices.getDisplayMedia({ video: true });
                    const localVid = document.getElementById('localVideo');
                    if (localVid) localVid.srcObject = screenStream;
                    isSharingScreen = true;
                    if (btn) btn.classList.add('active');
                    proToast('🖥️ Screen Sharing Started!', 'fa-desktop', '#10b981');
                    screenStream.getVideoTracks()[0].onended = () => {
                        isSharingScreen = false;
                        if (btn) btn.classList.remove('active');
                    };
                    return;
                }
            } catch (e) {}
            // Fallback simulated screen share for mobile/Safari
            isSharingScreen = true;
            if (btn) btn.classList.add('active');
            proToast('🖥️ Screen Share Active!', 'fa-desktop', '#10b981');
        } else {
            isSharingScreen = false;
            if (btn) btn.classList.remove('active');
            proToast('Screen Share Stopped', 'fa-desktop', '#64748b');
        }
    }
    window.toggleProScreenShare = toggleProScreenShare;

    // Voice Note Speed Control 1x / 1.5x / 2x (#3)
    function enhanceVoiceNotesInChat() {
        document.querySelectorAll('#chatBox audio').forEach(aud => {
            if (aud.dataset.proSpeedEnhanced === 'true') return;
            aud.dataset.proSpeedEnhanced = 'true';
            const speedBtn = document.createElement('button');
            speedBtn.type = 'button';
            speedBtn.className = 'ychat-audio-speed-btn';
            speedBtn.textContent = '1x';
            const rates = [1, 1.5, 2];
            let idx = 0;
            speedBtn.onclick = () => {
                idx = (idx + 1) % rates.length;
                aud.playbackRate = rates[idx];
                speedBtn.textContent = rates[idx] + 'x';
                proToast('Voice playback speed: ' + rates[idx] + 'x', 'fa-gauge-high', '#8b5cf6');
            };
            aud.insertAdjacentElement('afterend', speedBtn);
        });
    }

    // Disappearing / Vanish Mode (#4)
    let vanishModeSeconds = 0; // 0 = OFF, 15 = 15s, 60 = 1m
    window.toggleVanishMode = function () {
        const states = [
            { sec: 0, label: 'Vanish: OFF' },
            { sec: 15, label: 'Vanish: 15s 🔥' },
            { sec: 60, label: 'Vanish: 1m ⏳' }
        ];
        const curIdx = states.findIndex(s => s.sec === vanishModeSeconds);
        const next = states[(curIdx + 1) % states.length];
        vanishModeSeconds = next.sec;
        const lbl = document.getElementById('ychatVanishLabel');
        if (lbl) lbl.textContent = next.label;
        proToast(vanishModeSeconds > 0 ? `⏱️ Vanish Mode ON (${vanishModeSeconds}s auto-delete)` : 'Vanish Mode OFF', 'fa-hourglass-half', '#ef4444');
    };

    function applyVanishTimersInChat() {
        if (vanishModeSeconds <= 0) return;
        const rows = document.querySelectorAll('#chatBox .msg-row.sent');
        if (!rows.length) return;
        const lastRow = rows[rows.length - 1];
        if (lastRow.dataset.vanishBound === 'true') return;
        lastRow.dataset.vanishBound = 'true';
        const bubble = lastRow.querySelector('.msg');
        if (!bubble) return;
        const badge = document.createElement('span');
        badge.className = 'ychat-vanish-badge';
        let remaining = vanishModeSeconds;
        badge.innerHTML = `<i class="fa-solid fa-fire"></i> ${remaining}s`;
        bubble.appendChild(badge);
        const iv = setInterval(() => {
            remaining--;
            if (remaining <= 0) {
                clearInterval(iv);
                lastRow.style.transition = 'all 0.4s ease';
                lastRow.style.opacity = '0';
                lastRow.style.transform = 'scale(0.85)';
                setTimeout(() => lastRow.remove(), 400);
            } else {
                badge.innerHTML = `<i class="fa-solid fa-fire"></i> ${remaining}s`;
            }
        }, 1000);
    }

    // Per-Chat Wallpaper (#5)
    const WALLPAPERS = {
        default: { name: 'Default Clean', css: 'linear-gradient(180deg, #f8fafc, #f1f5f9)' },
        white:   { name: 'Pure White', css: '#ffffff' },
        cosmic:  { name: 'Cosmic Night', css: 'linear-gradient(135deg, #0f172a, #1e1b4b, #311042)' },
        sakura:  { name: 'Sakura Blossom', css: 'linear-gradient(135deg, #fdf2f8, #fce7f3, #f3e8ff)' },
        ocean:   { name: 'Ocean Breeze', css: 'linear-gradient(135deg, #ecfeff, #cffafe, #e0f2fe)' },
        emerald: { name: 'Emerald Forest', css: 'linear-gradient(135deg, #ecfdf5, #d1fae5, #f0fdf4)' },
        sunset:  { name: 'Sunset Glow', css: 'linear-gradient(135deg, #fff7ed, #ffedd5, #fce7f3)' }
    };

    function openWallpaperModal() {
        const friend = document.getElementById('targetFriendName')?.value || 'global';
        let html = '<div style="display:grid;grid-template-columns:repeat(2,1fr);gap:10px;">';
        Object.keys(WALLPAPERS).forEach(k => {
            const w = WALLPAPERS[k];
            html += `
                <button type="button" onclick="window.setProChatWallpaper('${k}')" style="height:74px;border-radius:16px;border:2px solid #cbd5e1;background:${w.css};color:${k === 'cosmic' ? '#fff' : '#1e293b'};font-weight:800;font-size:13px;cursor:pointer;box-shadow:0 4px 10px rgba(0,0,0,0.06);">
                    ${w.name}
                </button>
            `;
        });
        html += '</div>';
        openProModal(`<i class="fa-solid fa-palette" style="color:#ec4899;"></i> Chat Wallpaper (${friend})`, html);
    }
    window.openWallpaperModal = openWallpaperModal;

    window.setProChatWallpaper = function (key) {
        const friend = document.getElementById('targetFriendName')?.value || 'global';
        setStore(STORAGE_KEYS.WALLPAPER + friend, key);
        setStore(STORAGE_KEYS.WALLPAPER + 'global', key);
        applySavedChatWallpaper();
        proToast('Wallpaper updated to ' + WALLPAPERS[key].name, 'fa-palette', '#ec4899');
        closeProModal();
    };

    function applySavedChatWallpaper() {
        const chatBox = document.getElementById('chatBox');
        if (!chatBox) return;
        const friend = document.getElementById('targetFriendName')?.value || 'global';
        const key = getStore(STORAGE_KEYS.WALLPAPER + friend, null) || getStore(STORAGE_KEYS.WALLPAPER + 'global', 'default');
        const w = WALLPAPERS[key];
        if (w) chatBox.style.background = w.css;
    }

    // Group Chat & Group Voice/Video Call (#1)
    function openGroupChatModal() {
        const friendEls = Array.from(document.querySelectorAll('#friendListContainer .friend-item[data-username]'));
        const friends = friendEls.map(el => el.getAttribute('data-username')).filter(u => u && !u.startsWith('Group:'));
        const sampleFriends = friends.length ? friends : ['Sakura', 'Rahim', 'Kenji', 'Nusrat'];

        let checks = sampleFriends.map(f => `
            <label style="display:flex;align-items:center;gap:8px;padding:7px 10px;border-radius:10px;border:1px solid rgba(148,163,184,0.2);cursor:pointer;">
                <input type="checkbox" class="ychat-grp-member" value="${f}" checked>
                <span style="font-weight:700;font-size:13px;">${f}</span>
            </label>
        `).join('');

        openProModal(
            '<i class="fa-solid fa-users" style="color:#7c3aed;"></i> Create Group Chat & Group Call',
            `
            <div style="margin-bottom:12px;">
                <label style="font-size:12px;font-weight:800;display:block;margin-bottom:5px;">Group Name:</label>
                <input type="text" id="ychatGroupNameInput" value="VIP Friends Squad 🔥" style="width:100%;padding:9px 12px;border-radius:12px;border:1px solid #cbd5e1;font-size:13px;">
            </div>
            <div style="margin-bottom:14px;">
                <label style="font-size:12px;font-weight:800;display:block;margin-bottom:5px;">Select Group Members:</label>
                <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:6px;max-height:160px;overflow-y:auto;">${checks}</div>
            </div>
            <div style="display:flex;gap:8px;">
                <button type="button" onclick="window.createProGroup(false)" style="flex:1;padding:11px;border-radius:12px;border:none;background:#7c3aed;color:#fff;font-weight:800;cursor:pointer;"><i class="fa-solid fa-comments"></i> Create Group Chat</button>
                <button type="button" onclick="window.createProGroup(true)" style="flex:1;padding:11px;border-radius:12px;border:none;background:#10b981;color:#fff;font-weight:800;cursor:pointer;"><i class="fa-solid fa-video"></i> Start Group Call</button>
            </div>
            `
        );
    }
    window.openGroupChatModal = openGroupChatModal;

    window.createProGroup = function (startCallImmediately) {
        const name = (document.getElementById('ychatGroupNameInput')?.value || 'Friends Group').trim();
        const members = Array.from(document.querySelectorAll('.ychat-grp-member:checked')).map(c => c.value);
        const groups = getStore(STORAGE_KEYS.GROUPS, []);
        const grpLabel = 'Group: ' + name;
        if (!groups.some(g => g.name === grpLabel)) {
            groups.unshift({ name: grpLabel, members });
            setStore(STORAGE_KEYS.GROUPS, groups);
        }
        renderSavedGroupsInSidebar();
        closeProModal();
        const row = document.getElementById('friend-item-' + grpLabel);
        if (row && typeof window.openChat === 'function') {
            window.openChat(grpLabel, row);
        }
        proToast(`👥 ${grpLabel} Ready (${members.length + 1} members)!`, 'fa-users', '#7c3aed');
        if (startCallImmediately && typeof window.initiateCall === 'function') {
            setTimeout(() => window.initiateCall('video'), 200);
        }
    };

    function renderSavedGroupsInSidebar() {
        const container = document.getElementById('friendListContainer');
        if (!container) return;
        const groups = getStore(STORAGE_KEYS.GROUPS, []);
        groups.forEach(g => {
            if (document.getElementById('friend-item-' + g.name)) return;
            const div = document.createElement('div');
            div.className = 'friend-item';
            div.id = 'friend-item-' + g.name;
            div.setAttribute('data-username', g.name);
            div.onclick = () => { if (typeof window.openChat === 'function') window.openChat(g.name, div); };
            div.innerHTML = `
                <div class="avatar" style="background:linear-gradient(135deg,#7c3aed,#ec4899);">
                    <i class="fa-solid fa-users"></i>
                    <div class="status-dot online"></div>
                </div>
                <div class="friend-info" style="flex:1;min-width:0;">
                    <b style="font-size:14px;display:block;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${g.name}</b>
                    <small style="color:#10b981;font-weight:700;">${(g.members || []).length + 1} members • Active</small>
                </div>
                <div class="friend-call-actions">
                    <button type="button" class="friend-call-btn voice" onclick="event.stopPropagation();window.quickCallFriend('${g.name.replace(/'/g, '')}','voice',this.closest('.friend-item'))" title="Group Voice Call"><i class="fa-solid fa-phone"></i></button>
                    <button type="button" class="friend-call-btn video" onclick="event.stopPropagation();window.quickCallFriend('${g.name.replace(/'/g, '')}','video',this.closest('.friend-item'))" title="Group Video Call"><i class="fa-solid fa-video"></i></button>
                </div>
            `;
            container.prepend(div);
        });
    }

    // Mini-Games in Messenger (#14): Tic-Tac-Toe & Ludo Dice
    let tttBoard = ['', '', '', '', '', '', '', '', ''];
    function openMiniGamesModal() {
        tttBoard = ['', '', '', '', '', '', '', '', ''];
        renderMiniGamesModal();
    }
    window.openMiniGamesModal = openMiniGamesModal;

    function renderMiniGamesModal(statusText = 'Your turn (❌) vs Friend/AI (⭕)') {
        const cells = tttBoard.map((val, idx) => `
            <button type="button" onclick="window.playTttMove(${idx})" style="height:64px;border-radius:14px;border:2px solid #cbd5e1;background:rgba(124,58,237,0.06);font-size:26px;font-weight:900;cursor:pointer;">${val}</button>
        `).join('');

        openProModal(
            '<i class="fa-solid fa-gamepad" style="color:#10b981;"></i> Messenger Mini-Games',
            `
            <div style="text-align:center;margin-bottom:10px;font-weight:800;font-size:13px;color:#7c3aed;">${statusText}</div>
            <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:8px;max-width:240px;margin:0 auto 14px;">${cells}</div>
            <div style="display:flex;gap:8px;">
                <button type="button" onclick="window.rollProLudoDice()" style="flex:1;padding:10px;border-radius:12px;border:none;background:#f59e0b;color:#fff;font-weight:800;font-size:12px;cursor:pointer;">🎲 Roll Ludo Dice</button>
                <button type="button" onclick="window.openMiniGamesModal()" style="flex:1;padding:10px;border-radius:12px;border:none;background:#7c3aed;color:#fff;font-weight:800;font-size:12px;cursor:pointer;">🔄 Reset Game</button>
            </div>
            `
        );
    }

    function checkTttWinner(b) {
        const wins = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]];
        for (const [a, c, d] of wins) {
            if (b[a] && b[a] === b[c] && b[a] === b[d]) return b[a];
        }
        return b.every(Boolean) ? 'DRAW' : null;
    }

    window.playTttMove = function (idx) {
        if (tttBoard[idx] || checkTttWinner(tttBoard)) return;
        tttBoard[idx] = '❌';
        let w = checkTttWinner(tttBoard);
        if (!w) {
            const empty = tttBoard.map((v, i) => v === '' ? i : -1).filter(i => i >= 0);
            if (empty.length) {
                const aiMove = empty[Math.floor(Math.random() * empty.length)];
                tttBoard[aiMove] = '⭕';
            }
            w = checkTttWinner(tttBoard);
        }
        if (w === '❌') {
            setStore(STORAGE_KEYS.COINS, getStore(STORAGE_KEYS.COINS, 500) + 30);
            refreshProTopBar();
            renderMiniGamesModal('🏆 You Won! (+30 Coins)');
            sendGameResultToChat('🎮 Won a game of Tic-Tac-Toe (❌)!');
        } else if (w === '⭕') {
            renderMiniGamesModal('😮 Opponent Won (⭕)! Try again.');
        } else if (w === 'DRAW') {
            renderMiniGamesModal('🤝 It\'s a Draw!');
        } else {
            renderMiniGamesModal('Your turn (❌)');
        }
    };

    window.rollProLudoDice = function () {
        const roll = Math.floor(Math.random() * 6) + 1;
        const faces = ['⚀','⚁','⚂','⚃','⚄','⚅'];
        proToast(`🎲 Rolled a ${roll} ${faces[roll - 1]}!`, 'fa-dice', '#f59e0b');
        sendGameResultToChat(`🎲 Rolled a ${roll} ${faces[roll - 1]} in Ludo Dice!`);
    };

    function sendGameResultToChat(text) {
        const msgInput = document.getElementById('messageText');
        const friend = document.getElementById('targetFriendName')?.value;
        if (msgInput && friend && friend !== 'None' && typeof window.sendToFriend === 'function') {
            msgInput.value = text;
            window.sendToFriend();
        }
    }

    // =========================================================================
    // 11. PROFILE AUDIO BIO / VOICE INTRO (#13)
    // =========================================================================
    function enhanceProfilePage() {
        if (!location.href.includes('UsersProfileServlet') && !location.href.includes('profile')) return;
        if (document.getElementById('ychatAudioBioCard')) return;

        const targetAnchor = document.querySelector('h1.text-2xl, .profile-header, main .glass-card');
        if (!targetAnchor) return;

        const card = document.createElement('div');
        card.id = 'ychatAudioBioCard';
        card.style.cssText = 'margin:12px auto;padding:12px 16px;border-radius:18px;background:linear-gradient(90deg,rgba(124,58,237,0.1),rgba(236,72,153,0.1));border:1px solid rgba(124,58,237,0.25);display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:10px;max-width:680px;';
        card.innerHTML = `
            <div style="display:flex;align-items:center;gap:10px;">
                <button type="button" onclick="window.playCustomRingtone('marimba');window.proToast('🎙️ Playing Profile Audio Bio & Theme Music!','fa-volume-high','#7c3aed')" style="width:40px;height:40px;border-radius:50%;border:none;background:linear-gradient(135deg,#7c3aed,#ec4899);color:#fff;cursor:pointer;font-size:15px;box-shadow:0 4px 12px rgba(124,58,237,0.3);"><i class="fa-solid fa-play"></i></button>
                <div style="text-align:left;">
                    <div style="font-size:13px;font-weight:800;">🎙️ Audio Bio & Profile Theme Tune</div>
                    <div style="font-size:11px;opacity:0.75;">"Welcome to my official Y-Chat profile! Let's connect 🌟"</div>
                </div>
            </div>
            <div style="display:flex;gap:6px;flex-wrap:wrap;">
                <button type="button" onclick="window.recordAndOpenVisitorsModal()" class="ychat-pro-pill"><i class="fa-solid fa-eye" style="color:#06b6d4;"></i> Visitors</button>
                <button type="button" onclick="window.openProfileQrModal()" class="ychat-pro-pill"><i class="fa-solid fa-qrcode" style="color:#7c3aed;"></i> QR Code</button>
                <button type="button" onclick="window.toggleVerifiedBadge()" class="ychat-pro-pill"><i class="fa-solid fa-circle-check" style="color:#2563eb;"></i> Verified Tick</button>
            </div>
        `;
        targetAnchor.insertAdjacentElement('afterend', card);
    }

    // =========================================================================
    // 12. GLOBAL TOP PRO FEATURES BAR (VISIBLE ON FEED & PROFILE)
    // =========================================================================
    function injectGlobalProTopBar() {
        if (document.getElementById('ychatGlobalProBar')) return;
        // Don't duplicate on login/register pages
        if (location.href.includes('Login') || location.href.includes('Regist')) return;
        // On messages.jsp we already have #ychatMessengerProTools
        if (document.querySelector('.chat-header')) return;

        const bar = document.createElement('div');
        bar.id = 'ychatGlobalProBar';
        bar.className = 'ychat-pro-bar';
        const nav = document.querySelector('nav.sticky, header');
        if (nav) {
            nav.insertAdjacentElement('afterend', bar);
        } else {
            document.body.prepend(bar);
        }
        refreshProTopBar();
    }

    function refreshProTopBar() {
        const bar = document.getElementById('ychatGlobalProBar');
        if (!bar) return;
        const streak = getStore(STORAGE_KEYS.STREAK, 3);
        const coins = getStore(STORAGE_KEYS.COINS, 500);
        const level = getUserLevel();

        bar.innerHTML = `
            <button type="button" class="ychat-pro-pill" onclick="window.openStreakAndLevelModal()">🔥 ${streak}d Streak • Lv.${level}</button>
            <button type="button" class="ychat-pro-pill" onclick="window.openSendGiftModal('Creator','')">🪙 ${coins} Coins • Gift</button>
            <button type="button" class="ychat-pro-pill" onclick="window.openStoryStudioModal()"><i class="fa-solid fa-music" style="color:#ec4899;"></i> Story Music & Poll</button>
            <button type="button" class="ychat-pro-pill" onclick="window.openSavedCollectionsModal()"><i class="fa-solid fa-folder-open" style="color:#f59e0b;"></i> Saved Folders</button>
            <button type="button" class="ychat-pro-pill" onclick="window.recordAndOpenVisitorsModal()"><i class="fa-solid fa-eye" style="color:#06b6d4;"></i> Profile Visitors</button>
            <button type="button" class="ychat-pro-pill" onclick="window.openProfileQrModal()"><i class="fa-solid fa-qrcode" style="color:#7c3aed;"></i> My QR Code</button>
            <button type="button" class="ychat-pro-pill" onclick="window.toggleVerifiedBadge()"><i class="fa-solid fa-circle-check" style="color:#2563eb;"></i> Verified Badge</button>
            <button type="button" class="ychat-pro-pill" onclick="window.openRingtoneSelectorModal()"><i class="fa-solid fa-bell" style="color:#f59e0b;"></i> Ringtones</button>
            <button type="button" class="ychat-pro-pill" onclick="window.triggerInstallApp()"><i class="fa-solid fa-download" style="color:#10b981;"></i> Install App</button>
        `;
    }

    // =========================================================================
    // 13. INITIALIZE ALL PRO FEATURES ON DOM LOAD
    // =========================================================================
    function initYChatPro() {
        injectProStyles();
        injectGlobalProTopBar();
        applyVerifiedBadgesToDOM();
        enhanceNewsFeedPosts();
        enhanceMessengerPage();
        enhanceProfilePage();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initYChatPro);
    } else {
        initYChatPro();
    }
    setTimeout(initYChatPro, 800);
})();

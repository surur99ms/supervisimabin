<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supervisi Mabin IASS - Modern App</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    
    <style>
        /* --- GLOBAL STYLES --- */
        :root {
            --primary: #FF416C;
            --primary-gradient: linear-gradient(135deg, #FF4B2B, #FF416C);
            --admin-gradient: linear-gradient(135deg, #4facfe, #00f2fe);
            --bg-color: #f4f6f9;
            --text-main: #2b2b2b;
            --text-muted: #8d92a3;
        }

        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background-color: #e4e9f2;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: hidden; 
        }

        .app-container {
            width: 100%;
            max-width: 400px;
            background-color: #fbfbfd;
            height: 100vh;
            max-height: 850px;
            position: relative;
            box-shadow: 0 30px 60px rgba(0,0,0,0.15);
            overflow: hidden; 
            display: flex;
            flex-direction: column;
            border-radius: 0;
        }

        @media (min-width: 450px) {
            .app-container { border-radius: 40px; border: 8px solid #222; height: 90vh; }
        }

        /* --- ANIMASI --- */
        @keyframes slideUpFade { 0% { opacity: 0; transform: translateY(20px); } 100% { opacity: 1; transform: translateY(0); } }
        .animate-item { animation: slideUpFade 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; opacity: 0; }
        .delay-1 { animation-delay: 0.1s; } .delay-2 { animation-delay: 0.2s; } .delay-3 { animation-delay: 0.3s; } .delay-4 { animation-delay: 0.4s; }

        /* --- LOADING OVERLAY BLUR --- */
        #global-loading {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(8px);
            display: none; justify-content: center; align-items: center; z-index: 9999;
            flex-direction: column; gap: 15px; color: var(--text-main); font-weight: 600; font-size: 14px;
        }
        .spinner {
            width: 45px; height: 45px; border: 4px solid #eee; border-top: 4px solid var(--primary);
            border-radius: 50%; animation: spin 0.8s linear infinite;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

        /* --- HALAMAN LOGIN MODERN (CENTERED & RED THEME) --- */
        #login-screen {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 30px 25px;
            height: 100%;
            width: 100%;
            box-sizing: border-box;
            background: #ffffff;
            overflow-y: auto;
            text-align: center;
        }
        body.dark-mode #login-screen {
            background: #1a1b1e;
        }

        .login-logo-img {
            width: 75px;
            height: 75px;
            object-fit: contain;
            margin-bottom: 12px;
            border-radius: 12px;
        }

        .login-brand-top {
            font-weight: 700;
            font-size: 15px;
            letter-spacing: 0.5px;
            color: var(--text-main);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 6px;
            justify-content: center;
        }

        .login-header-title {
            font-size: 26px;
            font-weight: 700;
            color: var(--text-main);
            margin: 0 0 6px 0;
            text-align: center;
        }

        .login-header-subtitle {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 20px;
            text-align: center;
            line-height: 1.4;
        }

        /* Tab Switcher (Sign In / Create Account) */
        .auth-tab-container {
            display: flex;
            background: #f1f3f5;
            padding: 4px;
            border-radius: 16px;
            width: 100%;
            margin-bottom: 20px;
            box-sizing: border-box;
        }
        body.dark-mode .auth-tab-container {
            background: #2b2b2b;
        }
        .auth-tab-btn {
            flex: 1;
            padding: 12px;
            text-align: center;
            font-size: 13px;
            font-weight: 600;
            border-radius: 12px;
            cursor: pointer;
            transition: 0.2s;
            color: var(--text-muted);
            border: none;
            background: transparent;
            font-family: 'Poppins', sans-serif;
        }
        .auth-tab-btn.active {
            background: #ffffff;
            color: var(--text-main);
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        }
        body.dark-mode .auth-tab-btn.active {
            background: #3a3b3f;
            color: #fff;
        }

        /* Input dengan ikon */
        .modern-input-group {
            position: relative;
            margin-bottom: 15px;
            width: 100%;
        }
        .modern-input-group i.input-icon-left {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 18px;
        }
        .modern-input-group i.input-icon-right {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 18px;
            cursor: pointer;
        }
        .modern-input-group input {
            width: 100%;
            padding: 16px 18px 16px 50px;
            border: 1.5px solid #eaeaea;
            background-color: #fafbfc;
            border-radius: 16px;
            box-sizing: border-box;
            font-size: 13px;
            font-family: 'Poppins', sans-serif;
            outline: none;
            transition: 0.3s;
            color: var(--text-main);
        }
        body.dark-mode .modern-input-group input {
            background-color: #25262a;
            border-color: #333;
            color: #fff;
        }
        .modern-input-group input:focus {
            border-color: var(--primary);
            background-color: #fff;
            box-shadow: 0 0 0 4px rgba(255, 65, 108, 0.1);
        }

        /* Tombol Utama Merah Bergradasi (Menyesuaikan Tema Beranda) */
        .btn-modern-red {
            width: 100%;
            padding: 16px;
            background: var(--primary-gradient);
            color: white;
            border: none;
            border-radius: 16px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 8px 20px rgba(255, 65, 108, 0.35);
            font-family: 'Poppins', sans-serif;
            margin-top: 5px;
            transition: 0.2s;
        }
        .btn-modern-red:active {
            transform: scale(0.97);
        }

        .error-msg {
            background-color: #ffeaea; color: #ff3b3b; padding: 12px; border-radius: 10px;
            font-size: 13px; margin-bottom: 15px; display: none; text-align: center; font-weight: 500; width: 100%; box-sizing: border-box;
        }

        .login-bottom-hint {
            font-size: 12px;
            color: var(--primary);
            text-align: center;
            margin-top: 18px;
            font-weight: 500;
            cursor: pointer;
        }
        .login-bottom-hint:hover {
            text-decoration: underline;
        }

        /* --- WRAPPER APLIKASI UTAMA --- */
        #main-app, #admin-app { display: none; width: 100%; height: 100%; position: relative; }
        
        .screen-content { height: 100%; overflow-y: auto; padding-bottom: 85px; display: none; box-sizing: border-box; background: var(--bg-color); }
        .screen-content::-webkit-scrollbar { display: none; } .screen-content { -ms-overflow-style: none; scrollbar-width: none; }
        .screen-content.active { display: block; }

        /* Header Universal */
        .header { padding: 40px 25px 20px; display: flex; justify-content: space-between; align-items: center; }
        .header-text h1 { margin: 0; font-size: 16px; color: var(--text-muted); font-weight: 500; }
        .header-text h2 { margin: 0; font-size: 22px; color: var(--text-main); font-weight: 700; transition: 0.3s; }
        .header-text p { margin: 0; font-size: 13px; color: var(--text-muted); transition: 0.3s; }
        
        /* Badge Periode & Madrasah Interaktif */
        .periode-badge { background: #e0f2fe; color: #0284c7; padding: 5px 12px; border-radius: 10px; font-size: 11px; font-weight: 700; display: inline-block; margin-top: 6px; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.15); border: 1px solid #bae6fd; }
        .periode-badge:hover { background: #bae6fd; transform: translateY(-1px); }
        .periode-badge:active { transform: scale(0.95); }

        .madrasah-badge-header { background: #e0f2fe; color: #0284c7; padding: 5px 12px; border-radius: 10px; font-size: 11px; font-weight: 700; display: inline-block; margin-top: 6px; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.15); border: 1px solid #bae6fd; max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; vertical-align: middle; }
        .madrasah-badge-header:hover { background: #bae6fd; transform: translateY(-1px); }
        .madrasah-badge-header:active { transform: scale(0.95); }
        
        .btn-back { display: none; background: #fff; border: 1px solid #eee; font-size: 18px; border-radius: 14px; width: 42px; height: 42px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); cursor: pointer; color: var(--primary); transition: all 0.3s; align-items: center; justify-content: center;}
        .btn-back:hover { background: var(--primary); color: #fff; transform: translateY(-3px); box-shadow: 0 10px 20px rgba(255, 65, 108, 0.25); border-color: var(--primary); }
        .btn-back:active { transform: scale(0.9); }

        .banner-container { padding: 0 25px; margin-bottom: 25px; }
       .banner { background: linear-gradient(135deg, #f97316, #eab308); border-radius: 24px; padding: 30px 25px; color: white; position: relative; overflow: hidden; box-shadow: 0 15px 35px rgba(249, 115, 22, 0.4); }

/* Styling Logo Transparan di Sebelah Kanan Banner */
.banner-logo-putih {
    position: absolute;
    right: -8px;      /* Geser sedikit ke kiri agar tidak terlalu mepet pinggir */
    bottom: 2px;     /* Geser sedikit ke atas agar pas di dalam kotak */
    width: 150px;      /* Ukuran diperkecil agar pas dan proporsional */
    height: 90px;     /* Ukuran tinggi disesuaikan */
    object-fit: contain;
    opacity: 0.05;     /* Tingkat transparansi watermark */
    pointer-events: none;
    z-index: 1;
}

/* Memastikan teks banner berada di atas logo background */
.banner .banner-badge, .banner h3, .banner p {
    position: relative;
    z-index: 2;
}
        .banner.admin-banner { background: var(--admin-gradient); box-shadow: 0 15px 35px rgba(79, 172, 254, 0.35); }
        .banner-badge { background: rgba(255,255,255,0.2); backdrop-filter: blur(5px); padding: 6px 12px; border-radius: 20px; font-size: 11px; font-weight: 600; display: inline-block; margin-bottom: 12px; }
        .banner h3 { margin: 0; font-size: 24px; font-weight: 700; line-height: 1.3; }
        .banner p { margin: 8px 0 0 0; font-size: 13px; opacity: 0.9; }

        .section-header { padding: 0 25px; margin-bottom: 15px; }
        .section-header h3 { margin: 0; font-size: 18px; color: var(--text-main); font-weight: 600; }

        .list-container { padding: 0 25px; display: flex; flex-direction: column; gap: 15px; }
        .item-card { background: #fff; border-radius: 20px; padding: 20px; display: flex; align-items: center; box-shadow: 0 8px 15px rgba(0,0,0,0.03); border: 2px solid transparent; transition: all 0.4s; cursor: pointer; position: relative; }
        .item-card:hover { transform: translateY(-3px); box-shadow: 0 12px 25px rgba(0,0,0,0.08); }
        .item-card:active { transform: scale(0.97); }
        /* Styling khusus agar teks di dalam 3 kotak utama berwarna putih */
.card-manajemen, .card-pendataan, .card-kbm {
    color: #ffffff !important;
    border: none !important;
}
/* Styling khusus untuk 3 kotak utama gradasi & watermark ikon */
.card-manajemen, .card-pendataan, .card-kbm {
    color: #ffffff !important;
    border: none !important;
    position: relative;
    overflow: hidden;
}
.card-manajemen .item-text h4, .card-pendataan .item-text h4, .card-kbm .item-text h4 {
    color: #ffffff !important;
}
.card-manajemen .item-text p, .card-pendataan .item-text p, .card-kbm .item-text p {
    color: rgba(255, 255, 255, 0.85) !important;
}

/* Variasi Warna Gradasi Modern */
.card-manajemen { background: linear-gradient(135deg, #a855f7, #ec4899); } /* Ungu-Pink */
.card-pendataan { background: linear-gradient(135deg, #3b82f6, #06b6d4); } /* Biru */
.card-kbm { background: linear-gradient(135deg, #f97316, #eab308); }        /* Oranye-Kuning */

/* Ikon Transparan Besar di Bagian Kanan Kotak */
.card-bg-icon {
    position: absolute;
    right: -10px;
    bottom: -15px;
    font-size: 85px;
    color: rgba(255, 255, 255, 0.18);
    pointer-events: none;
    z-index: 1;
}

/* Memastikan teks dan ikon utama berada di atas background */
.card-manajemen .item-text, .card-pendataan .item-text, .card-kbm .item-text,
.card-manajemen .item-icon, .card-pendataan .item-icon, .card-kbm .item-icon {
    position: relative;
    z-index: 2;
}

        .item-icon { width: 50px; height: 50px; border-radius: 15px; display: flex; justify-content: center; align-items: center; font-size: 26px; margin-right: 15px; flex-shrink: 0; z-index: 2;}
        .icon-blue { background: linear-gradient(135deg, #4facfe, #00f2fe); color: white; }
        .icon-green { background: linear-gradient(135deg, #43e97b, #38f9d7); color: white; }
        .icon-orange { background: linear-gradient(135deg, #fa709a, #fee140); color: white; }
        .icon-purple { background: linear-gradient(135deg, #c471ed, #f64f59); color: white; }

        .item-text h4 { margin: 0 0 4px 0; font-size: 15px; color: var(--text-main); font-weight: 600; line-height: 1.2; z-index: 2;}
        .item-text p { margin: 0; font-size: 12px; color: var(--text-muted); line-height: 1.4; z-index: 2;}

        .item-card.task-baik { background: #f0fdf4; border: 2px solid #bbf7d0; }
        .item-card.task-baik .item-icon { background: linear-gradient(135deg, #43e97b, #10b981); color: white; box-shadow: 0 5px 15px rgba(16, 185, 129, 0.3); }
        .item-card.task-sedang { background: #fefce8; border: 2px solid #fef08a; }
        .item-card.task-sedang .item-icon { background: linear-gradient(135deg, #fde047, #eab308); color: white; box-shadow: 0 5px 15px rgba(234, 179, 8, 0.3); }
        .item-card.task-buruk { background: #fef2f2; border: 2px solid #fecaca; }
        .item-card.task-buruk .item-icon { background: linear-gradient(135deg, #f87171, #ef4444); color: white; box-shadow: 0 5px 15px rgba(239, 68, 68, 0.3); }

        .btn-template { margin-top: 10px; display: inline-block; padding: 6px 12px; background: #e0f2fe; color: #0284c7; border-radius: 8px; font-size: 11px; font-weight: 600; border: none; cursor: pointer; transition: 0.2s; }
        .btn-template:hover { background: #bae6fd; }

        select.custom-select { width: 100%; padding: 12px 15px; border-radius: 12px; border: 2px solid #eee; font-family: 'Poppins', sans-serif; font-size: 13px; color: var(--text-main); background-color: #fafafa; outline: none; transition: 0.3s; }
        select.custom-select:focus { border-color: var(--primary); }
        textarea.custom-textarea { width: 100%; padding: 12px; margin-top: 10px; border-radius: 12px; border: 2px solid #eee; font-family: 'Poppins', sans-serif; font-size: 13px; color: var(--text-main); background-color: #fafafa; outline: none; transition: 0.3s; box-sizing: border-box; resize: vertical; min-height: 80px; }
        textarea.custom-textarea:focus { border-color: var(--primary); }
        
        .summary-card { background: linear-gradient(135deg, #2b2b2b, #444); border-radius: 20px; padding: 25px; color: white; text-align: center; margin-bottom: 25px; box-shadow: 0 15px 30px rgba(0,0,0,0.15); }
        .summary-card h3 { margin: 0 0 5px 0; font-size: 28px; color: #00f2fe; }
        .summary-card p { margin: 0; font-size: 13px; opacity: 0.8; }
        .cat-header { font-size: 14px; font-weight: 700; color: var(--text-main); margin: 15px 0 5px 5px; text-transform: uppercase; letter-spacing: 0.5px; }
        .btn-sync { width: 100%; padding: 18px; margin-top: 25px; background: var(--primary-gradient); color: white; border: none; border-radius: 16px; font-size: 15px; font-weight: 600; font-family: 'Poppins'; cursor: pointer; box-shadow: 0 10px 25px rgba(255, 65, 108, 0.4); transition: 0.3s; }
        .btn-sync:active { transform: scale(0.96); }
        .btn-sync:disabled { background: #cccccc; box-shadow: none; cursor: not-allowed; transform: none; }

        .badge-baik { background: #dcfce7; color: #16a34a; padding: 6px 12px; border-radius: 12px; font-weight: 700; font-size: 12px; margin-left: auto; }
        .badge-sedang { background: #fef9c3; color: #ca8a04; padding: 6px 12px; border-radius: 12px; font-weight: 700; font-size: 12px; margin-left: auto;}
        .badge-buruk { background: #fee2e2; color: #dc2626; padding: 6px 12px; border-radius: 12px; font-weight: 700; font-size: 12px; margin-left: auto;}
        .badge-belum { background: #f3f4f6; color: #9ca3af; padding: 6px 12px; border-radius: 12px; font-weight: 600; font-size: 12px; margin-left: auto;}

        /* MODAL STYLES & NOTIFIKASI */
        .modal-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); display: none; justify-content: center; align-items: center; z-index: 200; padding: 20px; box-sizing: border-box; }
        .modal-card { background: white; width: 100%; max-width: 340px; border-radius: 24px; padding: 25px; box-shadow: 0 20px 40px rgba(0,0,0,0.2); animation: slideUpFade 0.3s forwards; max-height: 85vh; display: flex; flex-direction: column;}
        .modal-card h3 { margin: 0 0 5px 0; font-size: 18px; color: var(--text-main); }
        .modal-card p { margin: 0 0 15px 0; font-size: 13px; color: var(--text-muted); }
        
        .modal-search-input { width: 100%; padding: 12px 15px; margin-bottom: 12px; border: 2px solid #eee; border-radius: 12px; font-family: 'Poppins', sans-serif; font-size: 13px; outline: none; box-sizing: border-box; transition: 0.3s; }
        .modal-search-input:focus { border-color: var(--primary); }

        .radio-group { display: flex; flex-direction: column; gap: 10px; margin-bottom: 20px; overflow-y: auto; padding-right: 5px;}
        .radio-label { display: flex; align-items: center; padding: 12px 15px; border-radius: 14px; border: 2px solid #eee; cursor: pointer; font-size: 14px; font-weight: 500; transition: 0.2s; }
        .radio-label input { margin-right: 12px; accent-color: var(--primary); }
        
        .modal-actions { display: flex; gap: 10px; margin-top: auto; padding-top: 15px;}
        .btn-modal-cancel { flex: 1; padding: 12px; background: #f3f4f6; border: none; border-radius: 12px; font-weight: 600; color: #6b7280; cursor: pointer; font-family: 'Poppins'; }
        .btn-modal-save { flex: 1; padding: 12px; background: var(--primary-gradient); border: none; border-radius: 12px; font-weight: 600; color: white; cursor: pointer; font-family: 'Poppins'; }

        .export-item { border: 1px solid #eee; padding: 15px; border-radius: 15px; display: flex; flex-direction: column; gap: 8px; margin-bottom: 10px; background: #fafafa; transition: 0.3s; cursor: pointer;}
        .export-item:active { transform: scale(0.98); }
        .export-item strong { font-size: 14px; color: var(--text-main); }
        .export-item span { font-size: 11px; color: #666; display: flex; align-items: center; gap: 5px;}
        .export-btn { padding: 10px; background: #e0f2fe; color: #0284c7; border: none; border-radius: 10px; font-size: 12px; font-weight: 600; cursor: pointer; margin-top: 5px; font-family: 'Poppins';}

        /* --- STYLES PROFIL --- */
        .profile-container { padding: 0 25px 30px; text-align: center; }
        .profile-avatar-wrapper { position: relative; display: inline-block; margin-bottom: 15px; }
        .profile-avatar { width: 95px; height: 95px; background: #ff4b72; border-radius: 28px; display: flex; justify-content: center; align-items: center; color: white; font-size: 38px; font-weight: 600; box-shadow: 0 10px 25px rgba(255, 75, 114, 0.3); }
        .camera-badge { position: absolute; bottom: -5px; right: -5px; background: #ff4b72; color: white; width: 32px; height: 32px; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 16px; border: 3px solid #fbfbfd; box-shadow: 0 4px 10px rgba(0,0,0,0.15); cursor: pointer; }
        
        .profile-menu-item { background: #fff; border-radius: 20px; padding: 15px 18px; margin-bottom: 15px; display: flex; align-items: center; box-shadow: 0 4px 15px rgba(0,0,0,0.03); cursor: pointer; transition: 0.3s; border: 1px solid #f0f2f5; }
        .profile-menu-item:active { transform: scale(0.98); }
        .menu-icon { width: 48px; height: 48px; border-radius: 16px; display: flex; justify-content: center; align-items: center; font-size: 24px; color: white; margin-right: 15px; flex-shrink: 0; }
        .menu-text { flex: 1; text-align: left; }
        .menu-text h4 { margin: 0 0 2px 0; font-size: 14px; color: var(--text-main); font-weight: 700; line-height: 1.2;}
        .menu-text p { margin: 0; font-size: 11px; color: var(--text-muted); }
        .menu-arrow { color: var(--text-muted); font-size: 16px; margin-left: 10px; }

        .btn-logout-new { width: 100%; padding: 18px; margin-top: 10px; background: linear-gradient(to right, #ff416c, #ff4b2b); color: white; border: none; border-radius: 18px; font-size: 15px; font-weight: 600; font-family: 'Poppins', sans-serif; cursor: pointer; box-shadow: 0 8px 20px rgba(219, 39, 39, 0.25); display: flex; justify-content: center; align-items: center; gap: 8px; transition: 0.3s; }
        .btn-logout-new:active { transform: scale(0.96); }

        .toggle-switch { position: relative; display: inline-block; width: 48px; height: 26px; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .toggle-slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: .4s; border-radius: 34px; }
        .toggle-slider:before { position: absolute; content: ""; height: 20px; width: 20px; left: 3px; bottom: 3px; background-color: white; transition: .4s; border-radius: 50%; }
        .toggle-switch input:checked + .toggle-slider { background-color: var(--primary); }
        .toggle-switch input:checked + .toggle-slider:before { transform: translateX(22px); }

        .profile-footer { text-align: center; font-size: 11px; color: var(--text-muted); margin-top: 25px; line-height: 1.6; font-weight: 500; padding-bottom: 20px; }

        /* --- BOTTOM NAV STYLES (MODERN, SLEEK & PRECISE) --- */
        .bottom-nav { 
            position: absolute; bottom: 0; left: 0; width: 100%; 
            background: rgba(255, 255, 255, 0.94); 
            backdrop-filter: blur(20px); 
            -webkit-backdrop-filter: blur(20px);
            display: flex; justify-content: space-around; align-items: center; 
            height: 68px; 
            padding: 6px 12px calc(6px + env(safe-area-inset-bottom, 0px)); 
            box-sizing: border-box;
            box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.05); 
            border-top-left-radius: 24px; 
            border-top-right-radius: 24px; 
            border-top: 1px solid rgba(230, 235, 245, 0.8);
            z-index: 100; 
        }
        .nav-item { 
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            color: #94a3b8; font-size: 11px; font-weight: 500; cursor: pointer; 
            transition: color 0.25s ease; 
            width: 25%; position: relative; height: 100%;
            border-radius: 16px;
            user-select: none;
            -webkit-tap-highlight-color: transparent;
        }
        .nav-icon { 
            font-size: 20px; 
            width: 38px; height: 38px;
            border-radius: 50%;
            display: flex; justify-content: center; align-items: center;
            transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1); 
            margin-bottom: 2px; 
            position: relative;
        }
        .nav-item span { 
            font-size: 10.5px;
            font-weight: 600;
            transition: all 0.25s ease; 
            opacity: 0.75;
            line-height: 1.1;
        }
        
        /* ACTIVE SUPERVISOR (Red Theme) */
        .nav-item.active { color: #FF416C; }
        .nav-item.active .nav-icon { 
            transform: translateY(-6px) scale(1.1);
            background: var(--primary-gradient); 
            color: #ffffff; 
            box-shadow: 0 6px 16px rgba(255, 65, 108, 0.4); 
            border: 3px solid #ffffff;
        }
        body.dark-mode .nav-item.active .nav-icon {
            border-color: #1a1b1e;
        }
        .nav-item.active span { 
            font-weight: 700; 
            opacity: 1;
            transform: translateY(-2px);
            color: #FF416C;
        }
        
        /* ACTIVE ADMIN (Cyan Theme) */
        .nav-item.admin-active { color: #0084ff; }
        .nav-item.admin-active .nav-icon { 
            transform: translateY(-6px) scale(1.1);
            background: var(--admin-gradient); 
            color: #ffffff; 
            box-shadow: 0 6px 16px rgba(0, 132, 255, 0.4); 
            border: 3px solid #ffffff;
        }
        body.dark-mode .nav-item.admin-active .nav-icon {
            border-color: #1a1b1e;
        }
        .nav-item.admin-active span { 
            font-weight: 700; 
            opacity: 1;
            transform: translateY(-2px);
            color: #0084ff;
        }

        /* Smooth Tap Response */
        .nav-item:active .nav-icon {
            transform: scale(0.92);
        }
        .dashboard-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; padding: 0 25px; margin-bottom: 25px; }
        .rank-card { border-radius: 20px; padding: 15px 10px; color: white; display: flex; flex-direction: column; align-items: flex-start; box-shadow: 0 10px 20px rgba(0,0,0,0.08); transition: 0.3s; cursor: pointer; box-sizing: border-box; min-width: 0; }
        .rank-card:active { transform: scale(0.95); }
        .rank-card.r1 { background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); }
        .rank-card.r2 { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .rank-card.r3 { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
        .rank-badge-box { background: rgba(255,255,255,0.25); border-radius: 8px; padding: 4px 6px; font-size: 9px; font-weight: 700; margin-bottom: 8px; white-space: nowrap; }
        .rank-score { font-size: 19px; font-weight: 700; margin-bottom: 2px; }
        .rank-name { font-size: 11px; font-weight: 500; opacity: 0.95; white-space: normal; word-break: break-word; line-height: 1.2; width: 100%; }

        .chart-container { background: #fff; border-radius: 24px; padding: 25px; margin: 0 25px 25px; box-shadow: 0 10px 25px rgba(0,0,0,0.04); display: flex; align-items: center; justify-content: space-between; transition: 0.3s; border: 2px solid transparent;}
        .chart-legend { flex: 1; display: flex; flex-direction: column; gap: 12px; }
        .legend-item { display: flex; align-items: center; font-size: 13px; font-weight: 500; color: var(--text-muted); }
        .legend-dot { width: 10px; height: 10px; border-radius: 50%; margin-right: 10px; }
        .legend-val { font-weight: 700; color: var(--text-main); margin-right: 5px; font-size: 14px;}
        .donut-chart { width: 100px; height: 100px; border-radius: 50%; background: conic-gradient(#f6d365 0% 33%, #4facfe 33% 66%, #43e97b 66% 100%); display: flex; justify-content: center; align-items: center; position: relative; box-shadow: 0 5px 15px rgba(0,0,0,0.05);}
        .donut-inner { width: 75px; height: 75px; background: #fff; border-radius: 50%; display: flex; flex-direction: column; justify-content: center; align-items: center; z-index: 2;}
        .donut-inner span:first-child { font-size: 18px; font-weight: 700; color: var(--text-main); line-height: 1; }
        .donut-inner span:last-child { font-size: 9px; color: var(--text-muted); margin-top: 2px; }

        /* --- TOAST NOTIFICATION STYLES --- */
        .toast-container {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            flex-direction: column;
            gap: 12px;
            z-index: 10000;
            width: 90%;
            max-width: 360px;
            pointer-events: none;
        }

        .toast-notification {
            pointer-events: auto;
            display: flex;
            align-items: center;
            padding: 14px 18px;
            border-radius: 50px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            animation: slideDownToast 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            gap: 12px;
            transition: all 0.3s ease;
        }

        .toast-notification.hide {
            animation: fadeOutToast 0.4s forwards;
        }

        .toast-icon {
            font-size: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .toast-text {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .toast-text h4 {
            margin: 0;
            font-size: 14px;
            font-weight: 700;
            line-height: 1.2;
            text-align: left;
        }

        .toast-text p {
            margin: 2px 0 0 0;
            font-size: 11px;
            opacity: 0.9;
            text-align: left;
        }

        .toast-close {
            background: transparent;
            border: none;
            font-size: 16px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4px;
            border-radius: 50%;
            transition: 0.2s;
        }

        .toast-close:hover {
            background: rgba(0,0,0,0.05);
        }

        .toast-success {
            background-color: #ebfcf1;
            border: 1px solid #bbf7d0;
            color: #15803d;
        }
        .toast-success .toast-close { color: #15803d; }

        .toast-error {
            background-color: #fef2f2;
            border: 1px solid #fecaca;
            color: #b91c1c;
        }
        .toast-error .toast-close { color: #b91c1c; }

        @keyframes slideDownToast {
            0% { opacity: 0; transform: translateY(-30px) scale(0.95); }
            100% { opacity: 1; transform: translateY(0) scale(1); }
        }
        @keyframes fadeOutToast {
            0% { opacity: 1; transform: scale(1); }
            100% { opacity: 0; transform: scale(0.95); margin-top: -60px; }
        }

        /* --- DARK MODE STYLES --- */
        body.dark-mode { --bg-color: #1a1b1e; --text-main: #f0f2f5; --text-muted: #a1a5b3; background-color: #121214; }
        body.dark-mode .app-container { background-color: #1a1b1e; box-shadow: 0 30px 60px rgba(0,0,0,0.5); border-color: #333; }
        body.dark-mode #global-loading { background: rgba(26, 27, 30, 0.8); color: #fff; }
        body.dark-mode .screen-content { background: #1a1b1e; }
        body.dark-mode .modern-input-group input { background-color: #25262a; color: #fff; border-color: #333; }
        body.dark-mode .modern-input-group input:focus { border-color: var(--primary); }
        body.dark-mode .item-card { background: #25262a; border-color: #333; }
        /* Pastikan gradasi tetap tampil di mode gelap untuk 3 kotak utama */
body.dark-mode .item-card.card-manajemen { 
    background: linear-gradient(135deg, #a855f7, #ec4899) !important; 
    border: none !important; 
}
body.dark-mode .item-card.card-pendataan { 
    background: linear-gradient(135deg, #3b82f6, #06b6d4) !important; 
    border: none !important; 
}
body.dark-mode .item-card.card-kbm { 
    background: linear-gradient(135deg, #f97316, #eab308) !important; 
    border: none !important; 
}
        body.dark-mode .item-card:hover { box-shadow: 0 12px 25px rgba(0,0,0,0.3); }
        body.dark-mode select.custom-select { background-color: #2b2b2b; color: #fff; border-color: #444; }
        body.dark-mode .bottom-nav { background: rgba(26, 27, 30, 0.95); box-shadow: 0 -10px 30px rgba(0,0,0,0.2); }
        body.dark-mode .nav-item.active .nav-icon, body.dark-mode .nav-item.admin-active .nav-icon { border-color: #1a1b1e; }
        body.dark-mode .btn-back { background: #2b2b2b; border-color: #444; }
        body.dark-mode .modal-card { background: #25262a; }
        body.dark-mode .radio-label { border-color: #444; color: #eee; }
        body.dark-mode .btn-modal-cancel { background: #333; color: #ccc; }
        body.dark-mode .export-item { background: #25262a; border-color: #444; }
        body.dark-mode .export-item strong { color: #eee; }
        body.dark-mode .badge-belum { background: #333; color: #aaa; }
        body.dark-mode textarea.custom-textarea { background-color: #2b2b2b; color: #fff; border-color: #444; }
        body.dark-mode .modal-search-input { background-color: #2b2b2b; color: #fff; border-color: #444; }
        body.dark-mode .periode-badge, body.dark-mode .madrasah-badge-header { background: #0369a1; color: #e0f2fe; border-color: #0284c7; }
        body.dark-mode .chart-container { background: #25262a; border-color: #333; }
        body.dark-mode .donut-inner { background: #25262a; }
        body.dark-mode .profile-menu-item { background: #25262a; border-color: #333; }
        body.dark-mode .camera-badge { border-color: #1a1b1e; }
        
        body.dark-mode .toast-success { background-color: #143323; border-color: #166534; color: #4ade80; }
        body.dark-mode .toast-success .toast-close { color: #4ade80; }
        body.dark-mode .toast-error { background-color: #3f1616; border-color: #7f1d1d; color: #f87171; }
        body.dark-mode .toast-error .toast-close { color: #f87171; }
    </style>
</head>
<body>

<div class="app-container">
    
    <!-- TOAST CONTAINER (Untuk notifikasi hasil simpan per poin) -->
    <div id="toast-container" class="toast-container"></div>
    
    <!-- LOADING BLUR OVERLAY -->
    <div id="global-loading">
        <div class="spinner"></div>
        <span id="loading-text">Memproses data...</span>
    </div>

    <!-- ================= 1. HALAMAN LOGIN (CENTERED & RED THEME) ================= -->
    <div id="login-screen">
        <img src="logo.png" alt="Logo IASS" class="login-logo-img" id="login-logo-preview" />
        
        <div class="login-brand-top">
             Madrasah Binaan IASS
        </div>

        <h2 class="login-header-title">Selamat Datang</h2>
        <div class="login-header-subtitle">Selamat Berkhidmah!</div>

        <!-- Tab Navigasi Simulasi -->
        <div class="auth-tab-container">
            <button class="auth-tab-btn active">Sign In</button>
            <button class="auth-tab-btn" onclick="tampilkanNotifInfo('Fitur pendaftaran akun mandiri dinonaktifkan oleh Admin.')">Guest Account</button>
        </div>

        <div class="error-msg" id="error-msg">Username atau password salah!</div>

        <form class="login-form" onsubmit="handleLogin(event)" style="width: 100%;">
            <div style="font-size: 13px; font-weight: 600; color: var(--text-main); margin-bottom: 6px; text-align: left;">Sign in to continue</div>
            <div style="font-size: 11px; color: var(--text-muted); margin-bottom: 15px; text-align: left;">Harap Membaca Bismillah Terlebih Dahulu!</div>

            <div class="modern-input-group">
                <i class="ph-duotone ph-user input-icon-left"></i>
                <input type="text" id="username" placeholder="Username" autocomplete="off" required>
            </div>

            <div class="modern-input-group">
                <i class="ph-duotone ph-lock-key input-icon-left"></i>
                <input type="password" id="password" placeholder="Password" required>
                <i class="ph-duotone ph-eye-slash input-icon-right" onclick="togglePasswordVisibility(this)"></i>
            </div>

            <button type="submit" class="btn-modern-red">Sign In</button>
        </form>

        <div class="login-bottom-hint" onclick="tampilkanNotifInfo('Hint Login:\n- Admin: admin / admin123\n- Supervisor: spv / 123', 'Informasi Akun')">
            No account yet? View Login Hint
        </div>
    </div>


    <!-- ================= 2. APLIKASI ADMIN ================= -->
    <div id="admin-app">
        
        <!-- === TAB MANAJEMEN ADMIN (KIRI) === -->
        <div id="tab-manajemen-admin" class="screen-content">
            <div class="header">
               <div class="header-text">
                   <h2>Manajemen Admin</h2>
                   <p>Pengaturan & Kontrol Data Pusat</p>
               </div>
            </div>

            <div class="section-header animate-item delay-1" style="margin-top: 5px;">
                <h3>Menu Administrator</h3>
            </div>
            <div class="list-container animate-item delay-1">
               
               <div class="item-card" onclick="triggerExcelImport('madrasah')">
                   <div class="item-icon icon-green"><i class="ph-duotone ph-download-simple"></i></div>
                   <div class="item-text" style="width:100%">
                       <h4>Import Madrasah Binaan</h4>
                       <p>Unggah file Excel (.xlsx)</p>
                       <button class="btn-template" onclick="downloadTemplate(event, 'madrasah')"><i class="ph-duotone ph-file-text"></i> Download Template .xlsx</button>
                   </div>
               </div>

               <div class="item-card" onclick="triggerExcelImport('supervisor')">
                   <div class="item-icon icon-purple"><i class="ph-duotone ph-users-three"></i></div>
                   <div class="item-text" style="width:100%">
                       <h4>Import Akun Supervisor</h4>
                       <p>Daftar akun dari Excel (.xlsx)</p>
                       <button class="btn-template" onclick="downloadTemplate(event, 'supervisor')"><i class="ph-duotone ph-file-text"></i> Download Template .xlsx</button>
                   </div>
               </div>

               <!-- TAMBAH AKUN SUPERVISOR MANUAL -->
               <div class="item-card" onclick="bukaModalTambahSupervisor()">
                   <div class="item-icon icon-orange"><i class="ph-duotone ph-user-plus"></i></div>
                   <div class="item-text" style="width:100%">
                       <h4>Tambah Akun Supervisor</h4>
                       <p>Input data akun petugas secara manual</p>
                   </div>
               </div>

               <div class="item-card" onclick="bukaModalRiwayatAdmin()">
                   <div class="item-icon icon-blue"><i class="ph-duotone ph-export"></i></div>
                   <div class="item-text">
                       <h4>Export Hasil Supervisi</h4>
                       <p>Lihat & Unduh rikap madrasah (.xlsx)</p>
                   </div>
               </div>

            </div>
            
            <div class="section-header animate-item delay-2" style="margin-top: 20px;">
                <h3>Manajemen Data</h3>
            </div>
            <div class="list-container animate-item delay-2" style="margin-bottom: 30px;">
               <button class="btn-logout-new" style="margin-top: 0; padding: 12px; background: #fff; color: #db2727; border: 1px solid #ffeaea; box-shadow: none;" onclick="resetDataAdmin('hasil')"><i class="ph-duotone ph-trash"></i> Hapus Hasil Supervisi</button>
               <button class="btn-logout-new" style="margin-top: 0; padding: 12px; background: #fff; color: #db2727; border: 1px solid #ffeaea; box-shadow: none;" onclick="resetDataAdmin('madrasah')"><i class="ph-duotone ph-trash"></i> Hapus Data Madrasah</button>
               <button class="btn-logout-new" style="margin-top: 0; padding: 12px; background: #fff; color: #db2727; border: 1px solid #ffeaea; box-shadow: none;" onclick="resetDataAdmin('supervisor')"><i class="ph-duotone ph-trash"></i> Hapus Data Supervisor</button>
            </div>
        </div>

        <!-- === TAB DASHBOARD ADMIN (TENGAH - DEFAULT AWAL) === -->
        <div id="tab-dashboard-admin" class="screen-content active">
            <div class="header animate-item delay-1">
               <div class="header-text">
                   <h1>Selamat Datang!</h1>
                   <h2>Admin Pusat</h2>
                   <div class="periode-badge" id="periode-badge-admin" onclick="bukaModalGantiPeriode()"><i class="ph-duotone ph-calendar"></i> Periode: -</div>
               </div>
            </div>
            
            <div class="banner-container animate-item delay-2">
               <div class="banner admin-banner">
                   <div class="banner-badge" style="background: rgba(255,255,255,0.3);"><i class="ph-duotone ph-chart-bar"></i> Laporan Real-Time</div>
                   <h3>Dashboard Rekap</h3>
                   <p>Sistem otomatis (Baik: 100, Sedang: 75, Buruk: 50)</p>
                   <!-- Tambahan Logo Putih Transparan untuk Admin -->
        <img src="logo-putih.png" alt="Logo Admin" class="banner-logo-putih" />
               </div>
            </div>

            <!-- TOP 3 MADRASAH -->
            <div class="section-header animate-item delay-2" style="display: flex; justify-content: space-between; align-items: flex-end;">
                 <h3 style="margin:0;">Top 3 Madrasah</h3>
                 <a href="#" onclick="bukaSemuaRanking(); return false;" style="font-size: 12px; color: #4facfe; font-weight: 600; text-decoration: none;">Lihat Semua ></a>
            </div>
            <div id="top3-container" class="dashboard-grid animate-item delay-2"></div>

            <!-- RATA-RATA PER ITEM -->
            <div class="section-header animate-item delay-3" style="display: flex; justify-content: space-between; align-items: flex-end;">
                 <h3 style="margin:0;">Rata-rata Per Item</h3>
                 <a href="#" onclick="bukaSemuaRataRataItem(); return false;" style="font-size: 12px; color: #4facfe; font-weight: 600; text-decoration: none;">Lihat Detail ></a>
            </div>
            <div class="chart-container animate-item delay-3">
               <div class="chart-legend">
                   <div class="legend-item"><div class="legend-dot" style="background: #f6d365;"></div><span class="legend-val" id="avg-adm">0.0</span> Administrasi</div>
                   <div class="legend-item"><div class="legend-dot" style="background: #4facfe;"></div><span class="legend-val" id="avg-kur">0.0</span> Pendataan Digital</div>
                   <div class="legend-item"><div class="legend-dot" style="background: #43e97b;"></div><span class="legend-val" id="avg-loy">0.0</span> KBM & Laporan</div>
               </div>
               <div class="donut-chart" id="donut-chart"><div class="donut-inner"><span id="avg-total">0.0</span><span>Avg Total</span></div></div>
            </div>

            <!-- STATISTIK WILAYAH & PROGRES SUPERVISI -->
            <div class="section-header animate-item delay-3" style="margin-top: 5px;">
               <h3>Statistik Wilayah & Progres</h3>
            </div>
            <div id="wilayah-stats-container" class="list-container animate-item delay-3" style="margin-bottom: 25px;"></div>
        </div>

        <!-- === TAB PROFIL ADMIN (KANAN) === -->
        <div id="tab-profil-admin" class="screen-content">
            <div class="header"><div class="header-text"><h2>Profil Saya</h2></div></div>
            
            <div class="profile-container animate-item">
               <div class="profile-avatar-wrapper">
                   <div class="profile-avatar">AP</div>
                   <div class="camera-badge"><i class="ph-fill ph-camera"></i></div>
               </div>
               
               <h3 style="margin: 0; color: var(--text-main); font-size: 18px;">Admin Pusat</h3>
               <p style="margin: 5px 0 25px 0; color: var(--text-muted); font-size: 13px;">Administrator Utama</p>
               
               <div class="profile-menu-item">
                   <div class="menu-icon" style="background: #333;"><i class="ph-duotone ph-moon"></i></div>
                   <div class="menu-text">
                       <h4>Mode Gelap</h4>
                       <p>Tampilan malam hari</p>
                   </div>
                   <label class="toggle-switch"><input type="checkbox" id="dark-mode-toggle-admin" onchange="toggleDarkMode(this)"><span class="toggle-slider"></span></label>
               </div>

               <div class="profile-menu-item" onclick="tampilkanNotifInfo('Fitur ubah kata sandi belum tersedia pada versi ini.')">
                   <div class="menu-icon" style="background: #d4af37;"><i class="ph-duotone ph-lock-key"></i></div>
                   <div class="menu-text">
                       <h4>Ubah Kata Sandi</h4>
                       <p>Perbarui keamanan akun lokal</p>
                   </div>
                   <i class="ph-bold ph-caret-right menu-arrow"></i>
               </div>

               <div class="profile-menu-item" onclick="tampilkanNotifInfo('Fitur sidik jari belum tersedia pada versi ini.')">
                   <div class="menu-icon" style="background: #00f2fe;"><i class="ph-duotone ph-fingerprint"></i></div>
                   <div class="menu-text">
                       <h4>Daftarkan Sidik Jari</h4>
                       <p>Login cepat dengan biometrik</p>
                   </div>
                   <i class="ph-bold ph-caret-right menu-arrow"></i>
               </div>

               <div class="profile-menu-item" onclick="window.open('https://wa.me/6285606373627', '_blank')">
                   <div class="menu-icon" style="background: #16a34a;"><i class="ph-duotone ph-whatsapp-logo"></i></div>
                   <div class="menu-text">
                       <h4>Hubungi Developer</h4>
                       <p>Ada pertanyaan? Chat me on WhatsApp 085606373627</p>
                   </div>
                   <i class="ph-bold ph-caret-right menu-arrow"></i>
               </div>

               <button class="btn-logout-new" onclick="konfirmasiLogout()"><i class="ph-bold ph-sign-out"></i> Keluar Aplikasi</button>
               
               <div class="profile-footer">
                   Supervisi Mabin App - Versi 2.0.0<br>
                    Â© 2026 <strong>Tim IT Mabin IASS</strong>
               </div>
            </div>
        </div>

        <div class="bottom-nav">
            <div class="nav-item" onclick="switchTabAdmin('tab-manajemen-admin', this)"><div class="nav-icon"><i class="ph-duotone ph-sliders"></i></div><span>Manajemen</span></div>
            <div class="nav-item admin-active" onclick="switchTabAdmin('tab-dashboard-admin', this)"><div class="nav-icon"><i class="ph-duotone ph-chart-bar"></i></div><span>Dashboard</span></div>
            <div class="nav-item" onclick="switchTabAdmin('tab-profil-admin', this)"><div class="nav-icon"><i class="ph-duotone ph-user"></i></div><span>Profil</span></div>
        </div>
    </div>


    <!-- ================= 3. APLIKASI SUPERVISOR ================= -->
    <div id="main-app">
        <!-- === TAB BERANDA === -->
        <div id="tab-beranda" class="screen-content active">
            <div class="header animate-item delay-1">
               <div class="header-text">
                   <h1>Selamat Datang!</h1>
                   <h2 id="spv-greeting-name">Supervisor Mabin</h2>
                   <div class="periode-badge" id="periode-badge-spv" onclick="bukaModalGantiPeriode()"><i class="ph-duotone ph-calendar"></i> Periode: -</div>
               </div>
            </div>
           <div class="banner-container animate-item delay-2">
   <div class="banner">
       <div class="banner-badge"><i class="ph-duotone ph-sparkle"></i> Supervisi</div>
       <h3>Khidmah Lil Ma'had<br>Khidmah Lil Ummah</h3>
       <p>Khidmah Maximal</p>
       
       <!-- Menggunakan file khusus untuk beranda tanpa mengganggu menu login -->
       <img src="logo-putih.png" alt="Logo Beranda" class="banner-logo-putih" />
   </div>
</div>

            <!-- TOP 3 MADRASAH -->
            <div class="section-header animate-item delay-2" style="display: flex; justify-content: space-between; align-items: flex-end;">
                 <h3 style="margin:0;">Top 3 Madrasah</h3>
                 <a href="#" onclick="bukaSemuaRanking(); return false;" style="font-size: 12px; color: rgba(128, 128, 128, 0.5); font-weight: 600; text-decoration: none;">Lihat Semua ></a>
            </div>
            <div id="top3-container-spv" class="dashboard-grid animate-item delay-2"></div>

            <!-- RATA-RATA PER ITEM -->
            <div class="section-header animate-item delay-3" style="display: flex; justify-content: space-between; align-items: flex-end;">
                 <h3 style="margin:0;">Rata-rata Per Item</h3>
                 <a href="#" onclick="bukaSemuaRataRataItem(); return false;" style="font-size: 12px; color: rgba(128, 128, 128, 0.5); font-weight: 600; text-decoration: none;">Lihat Detail ></a>
            </div>
            <div class="chart-container animate-item delay-3">
               <div class="chart-legend">
                   <div class="legend-item"><div class="legend-dot" style="background: #f6d365;"></div><span class="legend-val" id="avg-adm-spv">0.0</span> Administrasi</div>
                   <div class="legend-item"><div class="legend-dot" style="background: #4facfe;"></div><span class="legend-val" id="avg-kur-spv">0.0</span> Pendataan Digital</div>
                   <div class="legend-item"><div class="legend-dot" style="background: #43e97b;"></div><span class="legend-val" id="avg-loy-spv">0.0</span> KBM & Laporan</div>
               </div>
               <div class="donut-chart" id="donut-chart-spv"><div class="donut-inner"><span id="avg-total-spv">0.0</span><span>Avg Total</span></div></div>
            </div>

            <!-- STATISTIK WILAYAH & PROGRES SUPERVISI (SUPERVISOR) -->
            <div class="section-header animate-item delay-3" style="margin-top: 5px;">
               <h3>Statistik Wilayah & Progres</h3>
            </div>
            <div id="wilayah-stats-container-spv" class="list-container animate-item delay-3" style="margin-bottom: 25px;"></div>
        </div>

        <!-- === TAB TUGAS === -->
        <div id="tab-tugas" class="screen-content">
            <div class="header">
               <div class="header-text" style="width: 100%;">
                   <h2 id="tugas-title">Pokok Supervisi</h2>
                   <div class="madrasah-badge-header" id="madrasah-badge-tugas" onclick="bukaModalPilihMadrasah()">
                       <i class="ph-duotone ph-buildings"></i> <span id="label-madrasah-terpilih-header">Pilih Madrasah</span>
                   </div>
               </div>
               <button class="btn-back" id="btn-back-tugas" onclick="resetTugasView()">&#10094;</button>
            </div>

            <div id="view-kategori-tugas" class="list-container">
               <!-- Kotak 1: Manajemen & Administrasi -->
   <div class="item-card card-manajemen" onclick="openSubMenu('administrasi')">
       <div class="item-icon" style="background: rgba(255,255,255,0.25); color: white;"><i class="ph-duotone ph-folder-open"></i></div>
       <div class="item-text" style="width:100%;">
           <h4>Manajemen & Administrasi</h4>
           <p>Dokumen & Pengelolaan kelembagaan</p>
       </div>
       <i class="ph-duotone ph-folder-open card-bg-icon"></i>
   </div>

   <!-- Kotak 2: Pendataan & Validasi Digital -->
   <div class="item-card card-pendataan" onclick="openSubMenu('pendataan')">
       <div class="item-icon" style="background: rgba(255,255,255,0.25); color: white;"><i class="ph-duotone ph-database"></i></div>
       <div class="item-text" style="width:100%;">
           <h4>Pendataan & Validasi Digital</h4>
           <p>Validasi lembaga, murid, guru, sahabat khidmah</p>
       </div>
       <i class="ph-duotone ph-database card-bg-icon"></i>
   </div>

   <!-- Kotak 3: KBM, Agenda & Laporan -->
   <div class="item-card card-kbm" onclick="openSubMenu('kbm')">
       <div class="item-icon" style="background: rgba(255,255,255,0.25); color: white;"><i class="ph-duotone ph-chalkboard-teacher"></i></div>
       <div class="item-text" style="width:100%;">
           <h4>KBM, Agenda & Laporan Bulanan</h4>
           <p>KBM, agenda kegiatan, keuangan & laporan</p>
       </div>
       <i class="ph-duotone ph-chalkboard-teacher card-bg-icon"></i>
   </div>

               <div class="section-header" style="padding: 10px 0 5px 0; margin-top: 5px;">
                   <h3 style="font-size: 15px;">Ringkasan Rata-rata</h3>
               </div>
               
               <div class="chart-container" style="margin: 0; box-shadow: 0 8px 20px rgba(0,0,0,0.03);">
                   <div class="chart-legend">
                       <div class="legend-item"><div class="legend-dot" style="background: #f6d365;"></div><span class="legend-val" id="avg-adm-task">0.0</span> Administrasi</div>
                       <div class="legend-item"><div class="legend-dot" style="background: #4facfe;"></div><span class="legend-val" id="avg-kur-task">0.0</span> Pendataan Digital</div>
                       <div class="legend-item"><div class="legend-dot" style="background: #43e97b;"></div><span class="legend-val" id="avg-loy-task">0.0</span> KBM & Laporan</div>
                   </div>
                   <div class="donut-chart" id="donut-chart-task" style="width: 85px; height: 85px;">
                       <div class="donut-inner" style="width: 65px; height: 65px;">
                           <span id="avg-total-task" style="font-size: 15px;">0.0</span>
                           <span style="font-size: 8px;">Avg</span>
                       </div>
                   </div>
               </div>
            </div>

            <div id="view-administrasi" class="list-container" style="display: none;">
               <div class="item-card" id="card-adm_1" onclick="bukaFormPenilaian('Buku Tamu', 'adm_1')"><div class="item-icon icon-blue"><i class="ph-duotone ph-book-open"></i></div><div class="item-text"><h4>Buku Tamu</h4><p>Pemeriksaan pencatatan tamu</p></div></div>
               <div class="item-card" id="card-adm_2" onclick="bukaFormPenilaian('Visi, Misi, dan Tujuan', 'adm_2')"><div class="item-icon icon-green"><i class="ph-duotone ph-target"></i></div><div class="item-text"><h4>Visi, Misi, dan Tujuan</h4><p>Kesesuaian visi misi dan tujuan</p></div></div>
               <div class="item-card" id="card-adm_3" onclick="bukaFormPenilaian('RKM', 'adm_3')"><div class="item-icon icon-orange"><i class="ph-duotone ph-clipboard-text"></i></div><div class="item-text"><h4>RKM</h4><p>Rencana Kerja Madrasah</p></div></div>
               <div class="item-card" id="card-adm_4" onclick="bukaFormPenilaian('RKAM', 'adm_4')"><div class="item-icon icon-purple"><i class="ph-duotone ph-money"></i></div><div class="item-text"><h4>RKAM</h4><p>Rencana Kegiatan & Anggaran Madrasah</p></div></div>
               <div class="item-card" id="card-adm_5" onclick="bukaFormPenilaian('Struktur Organisasi Madrasah', 'adm_5')"><div class="item-icon icon-blue"><i class="ph-duotone ph-bank"></i></div><div class="item-text"><h4>Struktur Organisasi</h4><p>Bagan dan susunan pengurus madrasah</p></div></div>
               <div class="item-card" id="card-adm_6" onclick="bukaFormPenilaian('TUPOKSI', 'adm_6')"><div class="item-icon icon-orange"><i class="ph-duotone ph-gear"></i></div><div class="item-text"><h4>TUPOKSI</h4><p>Tugas pokok fungsi pengurus</p></div></div>
            </div>

            <div id="view-pendataan" class="list-container" style="display: none;">
               <div class="item-card" id="card-kur_1" onclick="bukaFormPenilaian('Validasi Data Lembaga', 'kur_1')"><div class="item-icon icon-orange"><i class="ph-duotone ph-buildings"></i></div><div class="item-text"><h4>Data Lembaga</h4><p>Pengecekan keabsahan profil lembaga</p></div></div>
               <div class="item-card" id="card-kur_2" onclick="bukaFormPenilaian('Input Data Murid', 'kur_2')"><div class="item-icon icon-green"><i class="ph-duotone ph-student"></i></div><div class="item-text"><h4>Input Data Murid</h4><p>Pencatatan data santri/murid aktif</p></div></div>
               <div class="item-card" id="card-kur_3" onclick="bukaFormPenilaian('Input Data Guru', 'kur_3')"><div class="item-icon icon-blue"><i class="ph-duotone ph-chalkboard"></i></div><div class="item-text"><h4>Input Data Guru</h4><p>Pendataan tenaga pendidik</p></div></div>
               <div class="item-card" id="card-kur_4" onclick="bukaFormPenilaian('Input Data Sahabat Khidmah', 'kur_4')"><div class="item-icon icon-purple"><i class="ph-duotone ph-users"></i></div><div class="item-text"><h4>Sahabat Khidmah</h4><p>Pendataan mitra dan sahabat khidmah</p></div></div>
            </div>

            <div id="view-kbm" class="list-container" style="display: none;">
               <div class="item-card" id="card-loy_1" onclick="bukaFormPenilaian('Input KBM', 'loy_1')"><div class="item-icon icon-green"><i class="ph-duotone ph-book-bookmark"></i></div><div class="item-text"><h4>Input KBM</h4><p>Kegiatan Belajar Mengajar aktif</p></div></div>
               <div class="item-card" id="card-loy_2" onclick="bukaFormPenilaian('Input Agenda Kegiatan Madrasah', 'loy_2')"><div class="item-icon icon-blue"><i class="ph-duotone ph-calendar-check"></i></div><div class="item-text"><h4>Agenda Kegiatan</h4><p>Catatan agenda harian / bulanan</p></div></div>
               <div class="item-card" id="card-loy_3" onclick="bukaFormPenilaian('Input Data Keuangan', 'loy_3')"><div class="item-icon icon-purple"><i class="ph-duotone ph-wallet"></i></div><div class="item-text"><h4>Input Data Keuangan</h4><p>Pencatatan kas dan keuangan madrasah</p></div></div>
               <div class="item-card" id="card-loy_4" onclick="bukaFormPenilaian('Input Laporan Bulanan', 'loy_4')"><div class="item-icon icon-orange"><i class="ph-duotone ph-file-doc"></i></div><div class="item-text"><h4>Laporan Bulanan</h4><p>Rekapitulasi laporan berkala</p></div></div>
            </div>
        </div>

        <!-- === TAB NILAI === -->
        <div id="tab-nilai" class="screen-content">
            <div class="header">
               <div class="header-text"><h2>Rekap Nilai</h2><p>Detail hasil supervisi sementara</p></div>
            </div>
            <div class="list-container" id="rekap-nilai-container"></div>
        </div>

        <!-- === TAB PROFIL (SUPERVISOR) === -->
        <div id="tab-profil" class="screen-content">
            <div class="header"><div class="header-text"><h2>Profil Saya</h2></div></div>
            
            <div class="profile-container animate-item">
               <div class="profile-avatar-wrapper">
                   <div class="profile-avatar" id="avatar-spv-text">SM</div>
                   <div class="camera-badge"><i class="ph-fill ph-camera"></i></div>
               </div>
               
               <h3 id="profile-name" style="margin: 0; color: var(--text-main); font-size: 18px;">Moh. Rifqi Al Mahmudy</h3>
               <p id="profile-role" style="margin: 5px 0 25px 0; color: var(--text-muted); font-size: 13px;">Petugas Supervisi</p>
               
               <div class="profile-menu-item">
                   <div class="menu-icon" style="background: #333;"><i class="ph-duotone ph-moon"></i></div>
                   <div class="menu-text">
                       <h4>Mode Gelap</h4>
                       <p>Tampilan malam hari</p>
                   </div>
                   <label class="toggle-switch"><input type="checkbox" id="dark-mode-toggle-spv" onchange="toggleDarkMode(this)"><span class="toggle-slider"></span></label>
               </div>

               <div class="profile-menu-item" onclick="tampilkanNotifInfo('Fitur ubah kata sandi belum tersedia pada versi ini.')">
                   <div class="menu-icon" style="background: #d4af37;"><i class="ph-duotone ph-lock-key"></i></div>
                   <div class="menu-text">
                       <h4>Ubah Kata Sandi</h4>
                       <p>Perbarui keamanan akun lokal</p>
                   </div>
                   <i class="ph-bold ph-caret-right menu-arrow"></i>
               </div>

               <div class="profile-menu-item" onclick="tampilkanNotifInfo('Fitur sidik jari belum tersedia pada versi ini.')">
                   <div class="menu-icon" style="background: #00f2fe;"><i class="ph-duotone ph-fingerprint"></i></div>
                   <div class="menu-text">
                       <h4>Daftarkan Sidik Jari</h4>
                       <p>Login cepat dengan biometrik</p>
                   </div>
                   <i class="ph-bold ph-caret-right menu-arrow"></i>
               </div>

               <div class="profile-menu-item" onclick="window.open('https://wa.me/6285606373627', '_blank')">
                   <div class="menu-icon" style="background: #16a34a;"><i class="ph-duotone ph-whatsapp-logo"></i></div>
                   <div class="menu-text">
                       <h4>Hubungi Admin Pusat</h4>
                       <p>Ada pertanyaan? Chat me on WhatsApp 085606373627</p>
                   </div>
                   <i class="ph-bold ph-caret-right menu-arrow"></i>
               </div>

               <button class="btn-logout-new" onclick="konfirmasiLogout()"><i class="ph-bold ph-sign-out"></i> Keluar Aplikasi</button>
               
               <div class="profile-footer">
                   Supervisi Mabin App - Versi 2.0.0<br>
                    Â© 2026 <strong>Tim IT Mabin IASS</strong>
               </div>
            </div>
        </div>

        <div class="bottom-nav">
            <div class="nav-item active" onclick="switchTab('tab-beranda', this)"><div class="nav-icon"><i class="ph-duotone ph-house"></i></div><span>Beranda</span></div>
            <div class="nav-item" onclick="switchTab('tab-tugas', this)"><div class="nav-icon"><i class="ph-duotone ph-file-text"></i></div><span>Tugas</span></div>
            <div class="nav-item" onclick="switchTab('tab-nilai', this)"><div class="nav-icon"><i class="ph-duotone ph-star"></i></div><span>Nilai</span></div>
            <div class="nav-item" onclick="switchTab('tab-profil', this)"><div class="nav-icon"><i class="ph-duotone ph-user"></i></div><span>Profil</span></div>
        </div>
    </div>

    <!-- MODAL NOTIFIKASI KUSTOM / INTERAKTIF -->
    <div id="modal-notif-custom" class="modal-overlay" style="z-index: 500;">
        <div class="modal-card" style="max-width: 320px; text-align: center;">
            <div id="notif-icon-box" style="width: 50px; height: 50px; background: #e0f2fe; color: #0284c7; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; margin: 0 auto 15px;">
                <i class="ph-duotone ph-info"></i>
            </div>
            <h3 id="notif-title">Pemberitahuan</h3>
            <p id="notif-desc" style="margin-bottom: 20px;">Pesan informasi sistem.</p>
            <div id="notif-actions" class="modal-actions" style="margin-top: 0;">
               <button class="btn-modal-save" style="width:100%; flex:none;" onclick="tutupNotifCustom()">Mengerti</button>
            </div>
        </div>
    </div>

    <!-- MODAL TAMBAH AKUN SUPERVISOR MANUAL -->
    <div id="modal-tambah-spv" class="modal-overlay" style="z-index: 350;">
        <div class="modal-card">
           <h3>Tambah Akun Supervisor</h3>
           <p>Masukkan data akun supervisor baru secara manual:</p>
            <div class="input-group" style="margin-bottom: 10px;"><input type="text" id="add-spv-user" placeholder="Username" autocomplete="off" style="width:100%; padding:12px; border-radius:12px; border:1.5px solid #eee;"></div>
            <div class="input-group" style="margin-bottom: 10px;"><input type="password" id="add-spv-pass" placeholder="Password" style="width:100%; padding:12px; border-radius:12px; border:1.5px solid #eee;"></div>
            <div class="input-group" style="margin-bottom: 10px;"><input type="text" id="add-spv-name" placeholder="Nama Lengkap Supervisor" autocomplete="off" style="width:100%; padding:12px; border-radius:12px; border:1.5px solid #eee;"></div>
            <div class="input-group" style="margin-bottom: 15px;"><input type="text" id="add-spv-wilayah" placeholder="Wilayah Tugas" autocomplete="off" style="width:100%; padding:12px; border-radius:12px; border:1.5px solid #eee;"></div>
            <div class="modal-actions">
               <button class="btn-modal-cancel" onclick="document.getElementById('modal-tambah-spv').style.display='none'">Batal</button>
               <button class="btn-modal-save" onclick="simpanAkunSupervisorManual()">Simpan Akun</button>
            </div>
        </div>
    </div>

    <!-- MODAL POP-UP GANTI PERIODE -->
    <div id="modal-ganti-periode" class="modal-overlay" style="z-index: 400;">
        <div class="modal-card" style="max-width: 320px; text-align: center;">
            <div style="width: 50px; height: 50px; background: #e0f2fe; color: #0284c7; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; margin: 0 auto 15px;">
                <i class="ph-duotone ph-calendar-blank"></i>
            </div>
           <h3>Pilih Tahun Ajaran</h3>
           <p>Pilih periode tahun ajaran aktif untuk melihat atau mencatat data supervisi:</p>
            <div id="list-opsi-periode" class="radio-group" style="text-align: left; margin-bottom: 15px;"></div>
            <div class="modal-actions" style="margin-top: 0;">
               <button class="btn-modal-cancel" style="width:100%; flex:none;" onclick="document.getElementById('modal-ganti-periode').style.display='none'">Batal</button>
            </div>
        </div>
    </div>

    <!-- MODAL PEMILIHAN TARGET MADRASAH -->
    <div id="modal-pilih-madrasah" class="modal-overlay" style="z-index: 300;">
        <div class="modal-card" style="max-height: 85vh;">
           <h3>Pilih Madrasah Binaan</h3>
           <p>Silakan pilih lembaga target supervisi Anda:</p>
            <input type="text" id="search-input-target" class="modal-search-input" placeholder="ðŸ” Cari nama madrasah atau wilayah..." oninput="filterModalMadrasah()">
            <div id="list-modal-madrasah" class="radio-group" style="padding-right: 5px;"></div>
            <div class="modal-actions" style="margin-top: 15px;"><button class="btn-modal-cancel" style="width:100%; flex:none;" onclick="document.getElementById('modal-pilih-madrasah').style.display='none'">Tutup</button></div>
        </div>
    </div>

    <!-- MODAL SUPERVISOR (PENILAIAN) -->
    <div id="modal-penilaian" class="modal-overlay">
        <div class="modal-card">
            <h3 id="modal-materi-title">Penilaian Materi</h3>
            <p id="modal-madrasah-target">Madrasah: -</p>
            <div class="radio-group" style="margin-bottom: 10px;">
               <label class="radio-label" style="border-color: #dcfce7; color: #16a34a;"><input type="radio" name="pilihan-nilai" value="Baik"> <i class="ph-fill ph-check-circle"></i> &nbsp; Baik</label>
               <label class="radio-label" style="border-color: #fef9c3; color: #ca8a04;"><input type="radio" name="pilihan-nilai" value="Sedang"> <i class="ph-fill ph-warning-circle"></i> &nbsp; Sedang</label>
               <label class="radio-label" style="border-color: #fee2e2; color: #dc2626;"><input type="radio" name="pilihan-nilai" value="Buruk"> <i class="ph-fill ph-x-circle"></i> &nbsp; Buruk</label>
               <label class="radio-label" style="border-color: #e5e7eb; color: #6b7280;"><input type="radio" name="pilihan-nilai" value="Belum"> <i class="ph-fill ph-minus-circle"></i> &nbsp; Belum Dinilai (Reset)</label>
            </div>
           <textarea id="modal-catatan" class="custom-textarea" placeholder="Tulis catatan lapangan di sini (opsional)..." style="margin-bottom: 20px;"></textarea>
            <div class="modal-actions">
               <button class="btn-modal-cancel" onclick="document.getElementById('modal-penilaian').style.display = 'none';">Batal</button>
               <button class="btn-modal-save" onclick="simpanNilaiSementara()">Simpan</button>
            </div>
        </div>
    </div>

    <!-- MODAL ADMIN (DAFTAR EXPORT) -->
    <div id="modal-export-admin" class="modal-overlay">
        <div class="modal-card" style="max-height: 85vh;">
           <h3>Daftar Hasil Supervisi</h3>
           <p>Pilih lembaga untuk mengunduh laporan excel:</p>
            <input type="text" id="search-input-export" class="modal-search-input" placeholder="ðŸ” Cari lembaga atau supervisor..." oninput="filterModalExport()">
            <div id="list-hasil-supervisi" class="radio-group" style="padding-right: 5px;"></div>
            <div class="modal-actions" style="margin-top: 15px;"><button class="btn-modal-cancel" style="width:100%; flex:none;" onclick="document.getElementById('modal-export-admin').style.display='none'">Tutup</button></div>
        </div>
    </div>

    <!-- MODAL ADMIN (SEMUA RANKING) -->
    <div id="modal-semua-ranking" class="modal-overlay">
        <div class="modal-card" style="max-height: 85vh;">
           <h3>Ranking Keseluruhan</h3>
           <p>Peringkat berdasarkan rata-rata gabungan aspek pokok:</p>
            <input type="text" id="search-input-ranking" class="modal-search-input" placeholder="ðŸ” Cari nama madrasah..." oninput="filterModalRanking()">
            <div id="list-semua-ranking" class="radio-group" style="padding-right: 5px;"></div>
            <div class="modal-actions" style="margin-top: 15px;"><button class="btn-modal-cancel" style="width:100%; flex:none;" onclick="document.getElementById('modal-semua-ranking').style.display='none'">Tutup</button></div>
        </div>
    </div>

    <!-- MODAL DETAIL RATA-RATA PER ITEM -->
    <div id="modal-detail-item-avg" class="modal-overlay">
        <div class="modal-card" style="max-height: 85vh;">
           <h3>Detail Rata-rata Per Aspek</h3>
           <p>Rincian rata-rata keseluruhan untuk setiap kategori:</p>

            <div class="radio-group" style="padding-right: 5px; gap: 12px;">
               <div class="export-item" style="border-left: 4px solid #f6d365; background: #fffbe6;" onclick="bukaDetailSubItemAvg('Administrasi')">
                   <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                       <strong><i class="ph-duotone ph-folder-open"></i> Administrasi</strong>
                       <span style="color:#b7791f; font-size:11px;">Lihat Rincian ></span>
                   </div>
                   <span id="detail-avg-adm-val" style="font-size: 16px; font-weight: bold; color: #b7791f; margin-top: 2px;">0.0</span>
                   <span style="color: #666;">Nilai rata-rata aspek manajemen dan administrasi.</span>
               </div>
               <div class="export-item" style="border-left: 4px solid #4facfe; background: #e0f2fe;" onclick="bukaDetailSubItemAvg('Pendataan')">
                   <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                       <strong><i class="ph-duotone ph-database"></i> Pendataan Digital</strong>
                       <span style="color:#0369a1; font-size:11px;">Lihat Rincian ></span>
                   </div>
                   <span id="detail-avg-kur-val" style="font-size: 16px; font-weight: bold; color: #0369a1; margin-top: 2px;">0.0</span>
                   <span style="color: #666;">Nilai rata-rata aspek pendataan dan validasi digital.</span>
               </div>
               <div class="export-item" style="border-left: 4px solid #43e97b; background: #f0fdf4;" onclick="bukaDetailSubItemAvg('KBM')">
                   <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                       <strong><i class="ph-duotone ph-chalkboard-teacher"></i> KBM & Laporan</strong>
                       <span style="color:#15803d; font-size:11px;">Lihat Rincian ></span>
                   </div>
                   <span id="detail-avg-loy-val" style="font-size: 16px; font-weight: bold; color: #15803d; margin-top: 2px;">0.0</span>
                   <span style="color: #666;">Nilai rata-rata aspek KBM, agenda, keuangan dan laporan.</span>
               </div>
            </div>

            <div class="modal-actions" style="margin-top: 15px;">
               <button class="btn-modal-cancel" style="width:100%; flex:none;" onclick="document.getElementById('modal-detail-item-avg').style.display='none'">Tutup</button>
            </div>
        </div>
    </div>

    <!-- MODAL DETAIL SUB-ITEM AVG -->
    <div id="modal-detail-subitem-avg" class="modal-overlay" style="z-index: 260;">
        <div class="modal-card" style="max-height: 85vh;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 5px;">
                <h3 id="subitem-avg-title" style="margin:0; font-size: 16px; color: var(--text-main);">Detail Kategori</h3>
           </div>
            <p style="margin-bottom: 15px;">Rata-rata setiap poin penilaian:</p>
            <div id="list-subitem-avg" class="radio-group" style="padding-right: 5px; flex: 1;"></div>
            <div class="modal-actions" style="margin-top: 15px;"><button class="btn-modal-cancel" style="width:100%; flex:none;" onclick="document.getElementById('modal-detail-subitem-avg').style.display='none'">Kembali</button></div>
        </div>
    </div>

    <!-- MODAL DETAIL REKAP & RIWAYAT -->
    <div id="modal-detail-rekap" class="modal-overlay" style="z-index: 250;">
        <div class="modal-card" style="max-height: 90vh;">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom: 5px;">
                <h3 id="detail-rekap-title" style="margin:0; font-size: 16px; color: var(--text-main); line-height: 1.3;">Nama Madrasah</h3>
           </div>
            <p style="margin: 0 0 10px 0; font-size: 12px; color: var(--text-muted);">Riwayat Evaluasi Madrasah (Paling atas adalah yang terbaru)</p>
            <div id="list-detail-rekap" class="radio-group" style="padding-right: 5px; flex: 1; margin-top: 5px; max-height: 55vh; overflow-y: auto; display: flex; flex-direction: column; gap: 15px;"></div>
            <div class="modal-actions" style="margin-top: 15px;"><button class="btn-modal-cancel" style="width:100%; flex:none;" onclick="document.getElementById('modal-detail-rekap').style.display='none'">Tutup</button></div>
        </div>
    </div>

</div>

<script>
    // Auto detect host (Laragon localhost / local IP / production)
    const WEB_APP_URL = (window.location.protocol === 'file:' || !window.location.origin)
        ? "https://supervisi.mabin.corefive.my.id/api.php"
        : (window.location.origin + window.location.pathname.replace(/\/index\.php\/?$/, '').replace(/\/$/, '') + '/api.php');

    /* MATERI SUPERVISI TERBARU */
    const daftarPoinSupervisi = [
        { id: 'adm_1', kategori: 'Administrasi', nama: 'Buku Tamu' },
        { id: 'adm_2', kategori: 'Administrasi', nama: 'Visi, Misi, dan Tujuan' },
        { id: 'adm_3', kategori: 'Administrasi', nama: 'RKM' },
        { id: 'adm_4', kategori: 'Administrasi', nama: 'RKAM' },
        { id: 'adm_5', kategori: 'Administrasi', nama: 'Struktur Organisasi' },
        { id: 'adm_6', kategori: 'Administrasi', nama: 'TUPOKSI' },
        { id: 'kur_1', kategori: 'Pendataan', nama: 'Data Lembaga' },
        { id: 'kur_2', kategori: 'Pendataan', nama: 'Input Data Murid' },
        { id: 'kur_3', kategori: 'Pendataan', nama: 'Input Data Guru' },
        { id: 'kur_4', kategori: 'Pendataan', nama: 'Sahabat Khidmah' },
        { id: 'loy_1', kategori: 'KBM', nama: 'Input KBM' },
        { id: 'loy_2', kategori: 'KBM', nama: 'Agenda Kegiatan' },
        { id: 'loy_3', kategori: 'KBM', nama: 'Input Data Keuangan' },
        { id: 'loy_4', kategori: 'KBM', nama: 'Laporan Bulanan' }
    ];

    const daftarPilihanPeriode = ["1445-1446 H", "1446-1447 H", "1447-1448 H", "1448-1449 H", "1449-1450 H"];

    let hasilNilaiSupervisi = {};
    let hasilCatatanSupervisi = {};
    let activePoinId = null;

    let masterListMadrasahObj = []; 
    let masterListMadrasah = [];
    let masterListRanking = [];
    let masterListExport = [];
    
    let globalActivePeriode = localStorage.getItem('activePeriode') || '1447-1448 H';

    // ================= FITUR AUTO LOGOUT INAKTIF ================= //
    let inactivityLimit = 10 * 60 * 1000; // Tepat 10 menit dalam milidetik
    let inactivityTimer;

    function logoutDueToInactivity() {
        // Cek apakah pengguna sedang login (halaman login tersembunyi)
        if (document.getElementById('login-screen').style.display === 'none') {
            tampilkanNotifInfo("Sesi Anda telah berakhir karena tidak ada aktivitas selama 10 menit.", "Sesi Berakhir", "warning");
            setTimeout(() => {
                handleLogout();
            }, 1500);
        }
    }

    function resetTimer() {
        clearTimeout(inactivityTimer);
        // Hanya jalankan timer jika pengguna sudah login
        if (document.getElementById('login-screen').style.display === 'none') {
            inactivityTimer = setTimeout(logoutDueToInactivity, inactivityLimit);
        }
    }

    // Daftarkan event listener untuk memantau aktivitas pengguna
    ['mousemove', 'keydown', 'click', 'scroll', 'touchstart'].forEach(eventName => {
        window.addEventListener(eventName, resetTimer, true);
    });
    // ============================================================ //

    function showLoading(text = "Memproses data...") {
        document.getElementById('loading-text').innerText = text;
        document.getElementById('global-loading').style.display = 'flex';
    }

    function hideLoading() {
        document.getElementById('global-loading').style.display = 'none';
    }

    // ================= FUNGSI TOAST NOTIFICATION ================= //
    function showToast(title, message, type = 'success') {
        const container = document.getElementById('toast-container');
        if (!container) return;
        
        const toast = document.createElement('div');
        toast.className = `toast-notification ${type === 'success' ? 'toast-success' : 'toast-error'}`;
        
        const iconClass = type === 'success' ? 'ph-check-circle' : 'ph-warning-circle';
        
        toast.innerHTML = `
            <div class="toast-icon"><i class="ph-fill ${iconClass}"></i></div>
            <div class="toast-text">
                <h4>${title}</h4>
                <p>${message}</p>
            </div>
            <button class="toast-close" onclick="closeToast(this)"><i class="ph-bold ph-x"></i></button>
        `;
        
        container.appendChild(toast);

        const timeoutId = setTimeout(() => {
            closeToast(toast.querySelector('.toast-close'));
        }, 4000);

        toast.dataset.timeoutId = timeoutId;
    }

    function closeToast(buttonElement) {
        const toast = buttonElement.closest('.toast-notification');
        if (!toast) return;

        clearTimeout(toast.dataset.timeoutId);
        toast.classList.add('hide');
        
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 400);
    }
    // ============================================================== //

    function togglePasswordVisibility(iconEl) {
        let passInput = document.getElementById('password');
        if (passInput.type === 'password') {
            passInput.type = 'text';
            iconEl.classList.remove('ph-eye-slash');
            iconEl.classList.add('ph-eye');
        } else {
            passInput.type = 'password';
            iconEl.classList.remove('ph-eye');
            iconEl.classList.add('ph-eye-slash');
        }
    }

    function tampilkanNotifInfo(pesan, judul = "Pemberitahuan", tipe = "info") {
        document.getElementById('notif-title').innerText = judul;
        document.getElementById('notif-desc').innerText = pesan;
        let iconBox = document.getElementById('notif-icon-box');
        if(tipe === 'success') {
            iconBox.innerHTML = '<i class="ph-duotone ph-check-circle" style="color:#16a34a;"><i>';
            iconBox.style.background = '#dcfce7';
        } else if(tipe === 'warning') {
            iconBox.innerHTML = '<i class="ph-duotone ph-warning" style="color:#ca8a04;"></i>';
            iconBox.style.background = '#fef9c3';
        } else if(tipe === 'error') {
            iconBox.innerHTML = '<i class="ph-duotone ph-x-circle" style="color:#dc2626;"></i>';
            iconBox.style.background = '#fee2e2';
        } else {
            iconBox.innerHTML = '<i class="ph-duotone ph-info" style="color:#0284c7;"></i>';
            iconBox.style.background = '#e0f2fe';
        }
        document.getElementById('notif-actions').innerHTML = `<button class="btn-modal-save" style="width:100%; flex:none;" onclick="tutupNotifCustom()">Mengerti</button>`;
        document.getElementById('modal-notif-custom').style.display = 'flex';
    }

    function tutupNotifCustom() {
        document.getElementById('modal-notif-custom').style.display = 'none';
    }

    function konfirmasiLogout() {
        document.getElementById('notif-title').innerText = "Konfirmasi Keluar";
        document.getElementById('notif-desc').innerText = "Apakah Anda yakin ingin keluar dari sesi aplikasi saat ini?";
        let iconBox = document.getElementById('notif-icon-box');
        iconBox.innerHTML = '<i class="ph-duotone ph-sign-out" style="color:#dc2626;"></i>';
        iconBox.style.background = '#fee2e2';

        document.getElementById('notif-actions').innerHTML = `
            <button class="btn-modal-cancel" onclick="tutupNotifCustom()">Batal</button>
            <button class="btn-modal-save" style="background:linear-gradient(135deg, #ff5e3a, #ff2a6d);" onclick="tutupNotifCustom(); handleLogout();">Keluar</button>
        `;
        document.getElementById('modal-notif-custom').style.display = 'flex';
    }

    // ================= FUNGSI MENGAMBIL DATA DARI SERVER ================= //
    function unduhDataDariServer() {
        fetch(WEB_APP_URL + "?action=get_rekap", { method: "GET" })
        .then(response => response.json())
        .then(result => {
            let actualData = [];
            if (Array.isArray(result)) {
                actualData = result;
            } else if (result.success && result.data) {
                actualData = result.data;
            }

            let dataPusat = actualData.map(item => {
                let parsedNilai = item.nilai;
                let parsedCatatan = item.catatan;
                
                try { if (typeof parsedNilai === 'string') parsedNilai = JSON.parse(parsedNilai); } catch(e){}
                try { if (typeof parsedCatatan === 'string') parsedCatatan = JSON.parse(parsedCatatan); } catch(e){}
                
                return {
                    id: item.id,
                    madrasah: item.madrasah || item.madrasah_nama,
                    supervisor_nama: item.supervisor_nama,
                    supervisor_id: item.supervisor_id,
                    waktu: item.waktu,
                    periode: item.periode || '1447-1448 H',
                    nilai: parsedNilai,
                    catatan: parsedCatatan
                };
            });

            localStorage.setItem('riwayatSupervisiSemua', JSON.stringify(dataPusat));
            
            if (document.getElementById('admin-app').style.display === 'block') {
                updateAdminDashboard();
            } else if (document.getElementById('main-app').style.display === 'block') {
                updateSupervisorDashboard();
            }
        })
        .catch(error => {
            console.error("Gagal mengunduh rekap dari server:", error);
        });
    }

    function getRiwayatSemua() {
        try {
            let data = JSON.parse(localStorage.getItem('riwayatSupervisiSemua'));
            return Array.isArray(data) ? data : [];
        } catch(e) {
            return [];
        }
    }

    // Load Master Madrasah langsung dari Server API
    function loadMasterMadrasah() {
        fetch(WEB_APP_URL + "?action=get_madrasah", { method: "GET" })
        .then(response => response.json())
        .then(result => {
            let savedMadrasah = Array.isArray(result) ? result : (result.data || []);
            
            masterListMadrasahObj = [];
            masterListMadrasah = [];
            
            if (savedMadrasah && savedMadrasah.length > 0) {
                savedMadrasah.forEach(row => {
                    let nama = row.Nama_Madrasah || row.nama_madrasah || "Tanpa Nama";
                    let wilayah = row.Wilayah || row.wilayah || "Pusat";
                    masterListMadrasahObj.push({ Nama_Madrasah: nama, Wilayah: wilayah });
                    masterListMadrasah.push(wilayah ? `${nama} - ${wilayah}` : nama);
                });
            } else {
                masterListMadrasahObj = [
                    { Nama_Madrasah: "MI Al-Hidayah", Wilayah: "Surabaya" },
                    { Nama_Madrasah: "MTs Nurul Iman", Wilayah: "Jakarta" },
                    { Nama_Madrasah: "MA As-Salam", Wilayah: "Bandung" }
                ];
                masterListMadrasah = ["MI Al-Hidayah - Surabaya", "MTs Nurul Iman - Jakarta", "MA As-Salam - Bandung"];
            }
        })
        .catch(error => {
            console.error("Gagal memuat master madrasah dari server:", error);
        });
    }

    // CEK SESI SAAT HALAMAN DIMUAT (SESSION PERSISTENCE)
    window.onload = function() {
        loadMasterMadrasah();
        updateTampilanBadgePeriode();
        
        let isDark = localStorage.getItem('darkMode') === 'true';
        if (isDark) {
            let elAdmin = document.getElementById('dark-mode-toggle-admin');
            let elSpv = document.getElementById('dark-mode-toggle-spv');
            if(elAdmin) elAdmin.checked = true;
            if(elSpv) elSpv.checked = true;
            document.body.classList.add('dark-mode');
        }

        let savedRole = sessionStorage.getItem('activeUserRole');
        let savedName = sessionStorage.getItem('activeSupervisorName');

        if (savedRole === 'admin') {
            document.getElementById('login-screen').style.display = 'none';
            document.getElementById('admin-app').style.display = 'block';
            switchTabAdmin('tab-dashboard-admin', document.querySelectorAll('#admin-app .bottom-nav .nav-item')[1]);
            updateAdminDashboard();
            resetTimer(); // Mulai timer inaktivitas
        } else if (savedRole === 'supervisor') {
            document.getElementById('login-screen').style.display = 'none';
            document.getElementById('main-app').style.display = 'block';
            
            if(savedName) {
                document.getElementById('spv-greeting-name').innerText = savedName;
                document.getElementById('profile-name').innerText = savedName;
                document.getElementById('avatar-spv-text').innerText = savedName.substring(0, 2).toUpperCase();
            }

            switchTab('tab-beranda', document.querySelector('#main-app .bottom-nav .nav-item'));
            updateSupervisorDashboard();
            resetTimer(); // Mulai timer inaktivitas
        }

        unduhDataDariServer();
    };

    function updateTampilanBadgePeriode() {
        let badgeHtml = `<i class="ph-duotone ph-calendar"></i> Periode: ${globalActivePeriode}`;
        let elAdmin = document.getElementById('periode-badge-admin');
        let elSpv = document.getElementById('periode-badge-spv');
        if(elAdmin) elAdmin.innerHTML = badgeHtml;
        if(elSpv) elSpv.innerHTML = badgeHtml;
    }

    function bukaModalGantiPeriode() {
        let container = document.getElementById('list-opsi-periode');
        container.innerHTML = '';
        
        daftarPilihanPeriode.forEach(p => {
            let isSelected = (p === globalActivePeriode);
            container.innerHTML += `
                <label class="radio-label" style="border-color: ${isSelected ? 'var(--primary)' : '#eee'}; background: ${isSelected ? '#ffe5ec' : '#fafafa'};">
                    <input type="radio" name="pilihan-periode-pop" value="${p}" ${isSelected ? 'checked' : ''} onclick="pilihPeriodeBaru('${p}')"> 
                    <span style="font-weight: ${isSelected ? 'bold' : 'normal'}; color: var(--text-main);">${p} ${isSelected ? '(Aktif)' : ''}</span>
                </label>
            `;
        });
        document.getElementById('modal-ganti-periode').style.display = 'flex';
    }

    function pilihPeriodeBaru(newPeriode) {
        showLoading("Mengubah periode aktif...");
        setTimeout(() => {
            globalActivePeriode = newPeriode;
            localStorage.setItem('activePeriode', newPeriode);
            updateTampilanBadgePeriode();
            document.getElementById('modal-ganti-periode').style.display = 'none';

            if(document.getElementById('admin-app').style.display === 'block') {
                updateAdminDashboard();
            } else {
                updateSupervisorDashboard();
                let selectedM = document.getElementById('label-madrasah-terpilih-header').innerText;
                if(selectedM !== 'Pilih Madrasah') {
                    pilihMadrasahTarget(selectedM);
                }
            }
            hideLoading();
        }, 300);
    }

    function toggleDarkMode(element) {
        let isDark = element.checked;
        let elAdmin = document.getElementById('dark-mode-toggle-admin');
        let elSpv = document.getElementById('dark-mode-toggle-spv');
        if(elAdmin) elAdmin.checked = isDark;
        if(elSpv) elSpv.checked = isDark;
        
        if (isDark) {
            document.body.classList.add('dark-mode');
            localStorage.setItem('darkMode', 'true');
        } else {
            document.body.classList.remove('dark-mode');
            localStorage.setItem('darkMode', 'false');
        }
    }

    function populateMadrasahModalList(filterKeyword = "") {
        let container = document.getElementById('list-modal-madrasah');
        if(!container) return;
        container.innerHTML = '';
        
        let filtered = masterListMadrasah.filter(m => m.toLowerCase().includes(filterKeyword.toLowerCase()));
        if(filtered.length === 0) {
            container.innerHTML = `<p style="text-align:center; color:var(--text-muted); font-size:13px; padding:15px;">Madrasah tidak ditemukan.</p>`;
            return;
        }
        filtered.forEach(lembaga => {
            container.innerHTML += `
                <div class="export-item" onclick="pilihMadrasahTarget('${lembaga}')">
                    <div style="display:flex; justify-content: space-between; align-items:flex-start;">
                        <strong style="font-size:14px; color:var(--text-main); line-height:1.3;"><i class="ph-duotone ph-buildings"></i> ${lembaga}</strong>
                    </div>
                    <span style="color:var(--primary); margin-top:3px;">Pilih sebagai target supervisi ></span>
                </div>
            `;
        });
    }

    function filterModalMadrasah() {
        let keyword = document.getElementById('search-input-target').value;
        populateMadrasahModalList(keyword);
    }

    function bukaModalPilihMadrasah() {
        document.getElementById('search-input-target').value = '';
        populateMadrasahModalList('');
        document.getElementById('modal-pilih-madrasah').style.display = 'flex';
    }

    function pilihMadrasahTarget(namaLembaga) {
        document.getElementById('label-madrasah-terpilih-header').innerText = namaLembaga;
        document.getElementById('modal-pilih-madrasah').style.display = 'none';

        hasilNilaiSupervisi = {};
        hasilCatatanSupervisi = {};
        updateVisualMenuTugas();
    }

    // Fungsi Login Menggunakan Database Server Pusat
    function handleLogin(event) {
        event.preventDefault();
        const user = document.getElementById('username').value.trim();
        const pass = document.getElementById('password').value.trim();
        const errorMsg = document.getElementById('error-msg');

        showLoading("Verifikasi akun ke server...");

        fetch(WEB_APP_URL + "?action=login", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ username: user, password: pass })
        })
        .then(response => response.json())
        .then(result => {
            hideLoading();
            updateTampilanBadgePeriode();

            if (result.success) {
                errorMsg.style.display = 'none';
                document.getElementById('login-screen').style.display = 'none';

                sessionStorage.setItem('activeUserRole', result.role);

                if (result.role === 'admin') {
                    document.getElementById('admin-app').style.display = 'block';
                    switchTabAdmin('tab-dashboard-admin', document.querySelectorAll('#admin-app .bottom-nav .nav-item')[1]);
                    updateAdminDashboard();
                } else if (result.role === 'supervisor') {
                    document.getElementById('main-app').style.display = 'block';
                    let spvName = result.name || user;
                    sessionStorage.setItem('activeSupervisorName', spvName);
                    sessionStorage.setItem('activeSupervisorId', result.id);

                    document.getElementById('spv-greeting-name').innerText = spvName;
                    document.getElementById('profile-name').innerText = spvName;
                    document.getElementById('avatar-spv-text').innerText = spvName.substring(0, 2).toUpperCase();

                    switchTab('tab-beranda', document.querySelector('#main-app .bottom-nav .nav-item'));
                    updateSupervisorDashboard();
                    loadMasterMadrasah();
                }
                
                // Mulai timer inaktivitas setelah berhasil login
                resetTimer();
            } else {
                errorMsg.innerText = result.message || "Username atau password salah!";
                errorMsg.style.display = 'block';
            }
        })
        .catch(error => {
            hideLoading();
            console.error("Login Error:", error);
            errorMsg.innerText = "Terjadi kesalahan koneksi ke server.";
            errorMsg.style.display = 'block';
        });
    }

    function handleLogout() {
        showLoading("Keluar sesi...");
        // Bersihkan timer inaktivitas saat logout
        clearTimeout(inactivityTimer);

        setTimeout(() => {
            document.getElementById('main-app').style.display = 'none';
            document.getElementById('admin-app').style.display = 'none';
            document.getElementById('login-screen').style.display = 'flex';
            document.getElementById('username').value = '';
            document.getElementById('password').value = '';
            
            sessionStorage.removeItem('activeUserRole');
            sessionStorage.removeItem('activeSupervisorName');
            sessionStorage.removeItem('activeSupervisorId');

            switchTab('tab-beranda', document.querySelector('#main-app .bottom-nav .nav-item'));
            hideLoading();
        }, 400);
    }

    function getValScore(status) {
        if (status === 'Baik') return 100;
        if (status === 'Sedang') return 75;
        if (status === 'Buruk') return 50;
        return 0;
    }

    function updateAdminDashboard() {
        renderDashboardData('admin');
        renderStatistikWilayah('admin');
    }

    function updateSupervisorDashboard() {
        renderDashboardData('spv');
        renderStatistikWilayah('spv');
    }

    function renderStatistikWilayah(targetApp) {
        let riwayatAll = getRiwayatSemua();
        let riwayatPeriode = riwayatAll.filter(r => (r.periode || '1447-1448 H') === globalActivePeriode);

        let setSudahDisupervisi = new Set();
        riwayatPeriode.forEach(r => {
            setSudahDisupervisi.add(r.madrasah);
        });

        let wilayahMap = {};
        masterListMadrasahObj.forEach(item => {
            let wil = item.Wilayah || "Pusat";
            let fullName = item.Wilayah ? `${item.Nama_Madrasah} - ${item.Wilayah}` : item.Nama_Madrasah;
            
            if(!wilayahMap[wil]) {
                wilayahMap[wil] = { total: 0, sudah: 0, belum: 0 };
            }
            wilayahMap[wil].total += 1;
            
            if(setSudahDisupervisi.has(fullName) || setSudahDisupervisi.has(item.Nama_Madrasah)) {
                wilayahMap[wil].sudah += 1;
            } else {
                wilayahMap[wil].belum += 1;
            }
        });

        let containerId = targetApp === 'admin' ? 'wilayah-stats-container' : 'wilayah-stats-container-spv';
        let container = document.getElementById(containerId);
        if(!container) return;

        if(Object.keys(wilayahMap).length === 0) {
            container.innerHTML = `<div style="text-align: center; color: var(--text-muted); font-size: 13px; padding: 15px; background: #fff; border-radius: 20px;">Belum ada data madrasah binaan.</div>`;
            return;
        }

        let html = '';
        for(let wil in wilayahMap) {
            let data = wilayahMap[wil];
            html += `
                <div class="item-card" style="padding: 16px 20px; display: flex; flex-direction: column; align-items: stretch; gap: 10px; cursor: default;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <strong style="font-size: 15px; color: var(--text-main);"><i class="ph-duotone ph-map-pin"></i> Wilayah: ${wil}</strong>
                        <span style="font-size: 12px; font-weight: 600; color: var(--primary); background: #ffe5ec; padding: 3px 10px; border-radius: 8px;">Total: ${data.total} Madrasah</span>
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <div style="flex: 1; background: #f0fdf4; border: 1px solid #bbf7d0; padding: 8px; border-radius: 12px; text-align: center;">
                            <div style="font-size: 10px; color: #16a34a; font-weight: 700;">Sudah Disupervisi</div>
                            <div style="font-size: 16px; font-weight: bold; color: #15803d; margin-top: 2px;">${data.sudah}</div>
                        </div>
                        <div style="flex: 1; background: #fef2f2; border: 1px solid #fecaca; padding: 8px; border-radius: 12px; text-align: center;">
                            <div style="font-size: 10px; color: #dc2626; font-weight: 700;">Belum Disupervisi</div>
                            <div style="font-size: 16px; font-weight: bold; color: #b91c1c; margin-top: 2px;">${data.belum}</div>
                        </div>
                    </div>
                </div>
            `;
        }
        container.innerHTML = html;
    }

    function renderDashboardData(targetApp) {
        let riwayatAll = getRiwayatSemua();
        let riwayatPeriode = riwayatAll.filter(r => (r.periode || '1447-1448 H') === globalActivePeriode);
        // --- LOGIKA BARU: Ambil data paling baru saja untuk tiap madrasah di Dashboard ---
let mapUnik = {};
riwayatPeriode.forEach(item => {
    if (!mapUnik[item.madrasah]) {
        mapUnik[item.madrasah] = item;
    }
});
let riwayat = Object.values(mapUnik);
// ---------------------------------------------------------------------------------

        let madrasahScores = [];
        let totalAdmGlobal = 0, totalKurGlobal = 0, totalLoyGlobal = 0;

        riwayat.forEach(item => {
            let n = item.nilai || {};
            let admScore = (getValScore(n.adm_1) + getValScore(n.adm_2) + getValScore(n.adm_3) + getValScore(n.adm_4) + getValScore(n.adm_5) + getValScore(n.adm_6)) / 6;
            let kurScore = (getValScore(n.kur_1) + getValScore(n.kur_2) + getValScore(n.kur_3) + getValScore(n.kur_4)) / 4;
            let loyScore = (getValScore(n.loy_1) + getValScore(n.loy_2) + getValScore(n.loy_3) + getValScore(n.loy_4)) / 4;
            let avgTotal = (admScore + kurScore + loyScore) / 3;

            madrasahScores.push({
                nama: item.madrasah,
                fullname: item.madrasah, 
                score: avgTotal
            });

            totalAdmGlobal += admScore;
            totalKurGlobal += kurScore;
            totalLoyGlobal += loyScore;
        });

        madrasahScores.sort((a, b) => b.score - a.score);

        let containerId = targetApp === 'admin' ? 'top3-container' : 'top3-container-spv';
        let top3Container = document.getElementById(containerId);
        
        if (top3Container) {
            if (madrasahScores.length === 0) {
                top3Container.innerHTML = `<div style="grid-column: span 3; text-align: center; color: var(--text-muted); font-size: 13px; padding: 20px; background: #fff; border-radius: 20px; border: 1px dashed #ccc;">Belum ada hasil supervisi disetor pada periode ini.</div>`;
            } else {
                let html = '';
                let ranks = ['r1', 'r2', 'r3'];
                let icons = ['ph-trophy', 'ph-medal', 'ph-medal'];
                
                for(let i = 0; i < 3; i++) {
                    if(madrasahScores[i]) {
                        html += `
                        <div class="rank-card ${ranks[i]}" onclick="bukaDetailRekap('${madrasahScores[i].fullname}')">
                            <div class="rank-badge-box"><i class="ph-fill ${icons[i]}"></i> Rank ${i+1}</div>
                            <div class="rank-score">${madrasahScores[i].score.toFixed(1)}</div>
                            <div class="rank-name">${madrasahScores[i].nama}</div>
                        </div>`;
                    } else {
                        html += `
                        <div class="rank-card" style="background:#e0e0e0;">
                            <div class="rank-badge-box" style="color:#999;">-</div>
                            <div class="rank-score" style="color:#999;">-</div>
                            <div class="rank-name" style="color:#999;">-</div>
                        </div>`;
                    }
                }
                top3Container.innerHTML = html;
            }
        }

        let count = riwayat.length || 1;
        let avgAdm = totalAdmGlobal / count;
        let avgKur = totalKurGlobal / count;
        let avgLoy = totalLoyGlobal / count;
        let avgGlobalTotal = (avgAdm + avgKur + avgLoy) / 3;

        if (riwayat.length === 0) {
            avgAdm = 0; avgKur = 0; avgLoy = 0; avgGlobalTotal = 0;
        }

        let suffix = targetApp === 'admin' ? '' : '-spv';
        let elAdm = document.getElementById('avg-adm' + suffix);
        let elKur = document.getElementById('avg-kur' + suffix);
        let elLoy = document.getElementById('avg-loy' + suffix);
        let elTot = document.getElementById('avg-total' + suffix);
        let chartEl = document.getElementById('donut-chart' + suffix);

        if(elAdm) elAdm.innerText = avgAdm.toFixed(1);
        if(elKur) elKur.innerText = avgKur.toFixed(1);
        if(elLoy) elLoy.innerText = avgLoy.toFixed(1);
        if(elTot) elTot.innerText = avgGlobalTotal.toFixed(1);

        if(chartEl) {
            let totalAvgSum = avgAdm + avgKur + avgLoy;
            if(totalAvgSum === 0) {
                chartEl.style.background = `conic-gradient(#e0e0e0 0% 100%)`;
            } else {
                let pAdm = (avgAdm / totalAvgSum) * 100;
                let pKur = (avgKur / totalAvgSum) * 100;
                chartEl.style.background = `conic-gradient(#f6d365 0% ${pAdm}%, #4facfe ${pAdm}% ${pAdm + pKur}%, #43e97b ${pAdm + pKur}% 100%)`;
            }
        }
    }

    function bukaSemuaRataRataItem() {
        let riwayatAll = getRiwayatSemua();
        let riwayatPeriode = riwayatAll.filter(r => (r.periode || '1447-1448 H') === globalActivePeriode);
        // --- LOGIKA BARU: Ambil data paling baru saja untuk tiap madrasah di Dashboard ---
let mapUnik = {};
riwayatPeriode.forEach(item => {
    if (!mapUnik[item.madrasah]) {
        mapUnik[item.madrasah] = item;
    }
});
let riwayat = Object.values(mapUnik);
// ---------------------------------------------------------------------------------
        let totalAdmGlobal = 0, totalKurGlobal = 0, totalLoyGlobal = 0;

        riwayat.forEach(item => {
            let n = item.nilai || {};
            let admScore = (getValScore(n.adm_1) + getValScore(n.adm_2) + getValScore(n.adm_3) + getValScore(n.adm_4) + getValScore(n.adm_5) + getValScore(n.adm_6)) / 6;
            let kurScore = (getValScore(n.kur_1) + getValScore(n.kur_2) + getValScore(n.kur_3) + getValScore(n.kur_4)) / 4;
            let loyScore = (getValScore(n.loy_1) + getValScore(n.loy_2) + getValScore(n.loy_3) + getValScore(n.loy_4)) / 4;

            totalAdmGlobal += admScore;
            totalKurGlobal += kurScore;
            totalLoyGlobal += loyScore;
        });

        let count = riwayat.length || 1;
        let avgAdm = riwayat.length > 0 ? (totalAdmGlobal / count) : 0;
        let avgKur = riwayat.length > 0 ? (totalKurGlobal / count) : 0;
        let avgLoy = riwayat.length > 0 ? (totalLoyGlobal / count) : 0;

        document.getElementById('detail-avg-adm-val').innerText = avgAdm.toFixed(2);
        document.getElementById('detail-avg-kur-val').innerText = avgKur.toFixed(2);
        document.getElementById('detail-avg-loy-val').innerText = avgLoy.toFixed(2);

        document.getElementById('modal-detail-item-avg').style.display = 'flex';
    }

    function bukaDetailSubItemAvg(kategori) {
        let riwayatAll = getRiwayatSemua();
let riwayatPeriode = riwayatAll.filter(r => (r.periode || '1447-1448 H') === globalActivePeriode);

let mapUnik = {};
riwayatPeriode.forEach(item => {
    if (!mapUnik[item.madrasah]) {
        mapUnik[item.madrasah] = item;
    }
});
let riwayat = Object.values(mapUnik);
        let count = riwayat.length || 1;

        let titleKat = "Administrasi";
        if(kategori === 'Pendataan') titleKat = "Pendataan Digital";
        if(kategori === 'KBM') titleKat = "KBM & Laporan";

        document.getElementById('subitem-avg-title').innerText = "Rincian " + titleKat;
        let container = document.getElementById('list-subitem-avg');
        let html = '';
        let subItems = daftarPoinSupervisi.filter(i => i.kategori === kategori);

        subItems.forEach(item => {
            let totalScore = 0;
            riwayat.forEach(r => {
                let n = r.nilai || {};
                totalScore += getValScore(n[item.id]);
            });
            let avg = riwayat.length > 0 ? (totalScore / count) : 0;
            
            html += `
                <div style="display:flex; justify-content:space-between; align-items:center; padding: 12px 10px; border-bottom: 1px dashed #eee;">
                    <div style="flex:1;">
                        <div style="font-size: 13px; font-weight:600; color:var(--text-main);">${item.nama}</div>
                    </div>
                    <strong style="font-size:16px; color:var(--text-main);">${avg.toFixed(2)}</strong>
                </div>
            `;
        });
        container.innerHTML = html;
        document.getElementById('modal-detail-subitem-avg').style.display = 'flex';
    }

    function renderListRanking(filterKeyword = "") {
        let container = document.getElementById('list-semua-ranking');
        container.innerHTML = '';
        let filtered = masterListRanking.filter(m => m.nama.toLowerCase().includes(filterKeyword.toLowerCase()));

        if(filtered.length === 0) {
            container.innerHTML = `<p style="text-align:center; color:var(--text-muted); font-size:13px; padding:15px;">Data peringkat tidak ditemukan.</p>`;
            return;
        }

        filtered.forEach((m) => {
            container.innerHTML += `
                <div class="export-item" onclick="bukaDetailRekap('${m.fullname}')">
                    <div style="display:flex; justify-content: space-between; align-items:flex-start; gap: 10px;">
                        <strong style="flex:1; line-height: 1.3;"><i class="ph-duotone ph-medal"></i> Rank ${m.rank}: ${m.nama}</strong>
                        <span style="font-size: 16px; font-weight:bold; color:var(--text-main); white-space: nowrap;">${m.score.toFixed(1)}</span>
                    </div>
                    <span style="color:var(--primary); margin-top:5px;">Lihat Riwayat Madrasah ></span>
                </div>
            `;
        });
    }

    function filterModalRanking() {
        let keyword = document.getElementById('search-input-ranking').value;
        renderListRanking(keyword);
    }

    function bukaSemuaRanking() {
        let riwayatAll = getRiwayatSemua();
        let riwayatPeriode = riwayatAll.filter(r => (r.periode || '1447-1448 H') === globalActivePeriode);
        // --- LOGIKA BARU: Ambil data paling baru saja untuk tiap madrasah di Dashboard ---
let mapUnik = {};
riwayatPeriode.forEach(item => {
    if (!mapUnik[item.madrasah]) {
        mapUnik[item.madrasah] = item;
    }
});
let riwayat = Object.values(mapUnik);
// ---------------------------------------------------------------------------------
        if (riwayat.length === 0) return tampilkanNotifInfo("Belum ada data supervisi disetor pada periode aktif.", "Informasi", "warning");

        masterListRanking = [];
        let tempData = [];

        riwayat.forEach(item => {
            let n = item.nilai || {};
            let admScore = (getValScore(n.adm_1) + getValScore(n.adm_2) + getValScore(n.adm_3) + getValScore(n.adm_4) + getValScore(n.adm_5) + getValScore(n.adm_6)) / 6;
            let kurScore = (getValScore(n.kur_1) + getValScore(n.kur_2) + getValScore(n.kur_3) + getValScore(n.kur_4)) / 4;
            let loyScore = (getValScore(n.loy_1) + getValScore(n.loy_2) + getValScore(n.loy_3) + getValScore(n.loy_4)) / 4;
            let avgTotal = (admScore + kurScore + loyScore) / 3;
            
            tempData.push({ nama: item.madrasah, fullname: item.madrasah, score: avgTotal });
        });
        
        tempData.sort((a, b) => b.score - a.score);
        tempData.forEach((m, idx) => {
            masterListRanking.push({ ...m, rank: idx + 1 });
        });

        document.getElementById('search-input-ranking').value = '';
        renderListRanking('');
        document.getElementById('modal-semua-ranking').style.display = 'flex';
    }

    function bukaDetailRekap(fullname) {
        let riwayatSemua = getRiwayatSemua();
        let dataHistori = riwayatSemua.filter(r => r.madrasah === fullname);
        
        if (dataHistori.length === 0) return tampilkanNotifInfo("Data riwayat tidak ditemukan.", "Peringatan", "warning");

       // Urutkan berdasarkan periode, lalu berdasarkan waktu terbaru agar kunjungan bulan ini dan bulan lalu urut
dataHistori.sort((a, b) => {
    if (b.periode !== a.periode) return (b.periode || '').localeCompare(a.periode || '');
    return new Date(b.waktu) - new Date(a.waktu);
});

        document.getElementById('detail-rekap-title').innerText = fullname;
        let container = document.getElementById('list-detail-rekap');
        let html = '';

        dataHistori.forEach((data, index) => {
            let n = data.nilai || {};
            let prd = data.periode || '1447-1448 H';
            let bgHeader = index === 0 ? 'var(--primary-gradient)' : '#6b7280';
            
            let admScore = (getValScore(n.adm_1) + getValScore(n.adm_2) + getValScore(n.adm_3) + getValScore(n.adm_4) + getValScore(n.adm_5) + getValScore(n.adm_6)) / 6;
            let kurScore = (getValScore(n.kur_1) + getValScore(n.kur_2) + getValScore(n.kur_3) + getValScore(n.kur_4)) / 4;
            let loyScore = (getValScore(n.loy_1) + getValScore(n.loy_2) + getValScore(n.loy_3) + getValScore(n.loy_4)) / 4;
            let avgTotal = (admScore + kurScore + loyScore) / 3;

            html += `
            <div style="flex-shrink: 0; border: 2px solid ${index === 0 ? 'var(--primary)' : '#e5e7eb'}; border-radius: 16px; margin-bottom: 15px; overflow: hidden; background: #fff;">
               <div style="background: ${bgHeader}; color: white; padding: 12px 15px; display:flex; justify-content:space-between; align-items:center;">
                   <div>
                       <span style="font-size: 10px; opacity: 0.9;">Tahun Ajaran</span>
                       <div style="font-size: 13px; font-weight: 700;">${prd}</div>
                   </div>
                   <div style="text-align: right;">
                       <span style="font-size: 10px; opacity: 0.9;">Nilai Akhir</span>
                       <div style="font-size: 20px; font-weight: bold;">${avgTotal.toFixed(2)}</div>
                   </div>
               </div>
               
               <div style="padding: 15px;">
                   <div style="display: flex; gap: 8px; margin-bottom: 15px;">
                       <div style="flex: 1; background: #f0fdf4; border: 1px solid #bbf7d0; padding: 8px 4px; border-radius: 8px; text-align: center;">
                           <div style="font-size: 9px; color: #16a34a; font-weight: 700;">MANAJEMEN</div>
                           <div style="font-size: 14px; font-weight: bold; color: #15803d;">${admScore.toFixed(1)}</div>
                       </div>
                       <div style="flex: 1; background: #e0f2fe; border: 1px solid #bae6fd; padding: 8px 4px; border-radius: 8px; text-align: center;">
                           <div style="font-size: 9px; color: #0284c7; font-weight: 700;">PENDATAAN</div>
                           <div style="font-size: 14px; font-weight: bold; color: #0369a1;">${kurScore.toFixed(1)}</div>
                       </div>
                       <div style="flex: 1; background: #fefce8; border: 1px solid #fef08a; padding: 8px 4px; border-radius: 8px; text-align: center;">
                           <div style="font-size: 9px; color: #ca8a04; font-weight: 700;">AGENDA</div>
                           <div style="font-size: 14px; font-weight: bold; color: #a16207;">${loyScore.toFixed(1)}</div>
                       </div>
                   </div>
                   
                   <button class="export-btn" style="width:100%; margin-bottom:10px; background: #ffe5ec; color: var(--primary);" onclick="bukaModalRincianItem('${fullname}', '${prd}')">
                       <i class="ph-duotone ph-list-checks"></i> Lihat Detail Nilai Semua Item
                   </button>
               </div>
            </div>`;
        });
        
        container.innerHTML = html;
        document.getElementById('modal-detail-rekap').style.display = 'flex';
    }

    function bukaModalRincianItem(fullname, periode) {
        let riwayatSemua = getRiwayatSemua();
        let targetData = riwayatSemua.find(r => r.madrasah === fullname && (r.periode || '1447-1448 H') === periode);
        if(!targetData) return tampilkanNotifInfo("Data rincian tidak ditemukan.", "Peringatan", "warning");

        let n = targetData.nilai || {};
        let html = `
            <div class="modal-overlay" id="modal-rincian-item" style="display:flex; z-index:300;">
               <div class="modal-card" style="max-height: 85vh;">
                   <h3>Rincian Semua Item</h3>
                   <p style="margin-bottom: 10px;"><b>${fullname}</b> (${periode})</p>
                   <div class="radio-group" style="flex:1; padding-right:5px; max-height: 350px;">
        `;

        daftarPoinSupervisi.forEach(item => {
            let status = n[item.id] || 'Belum Dinilai';
            if(status === 'Belum') status = 'Belum Dinilai';
            let b = "badge-belum"; 
            if (status === 'Baik') b = "badge-baik"; 
            else if (status === 'Sedang') b = "badge-sedang"; 
            else if (status === 'Buruk') b = "badge-buruk";

            let cat = (targetData.catatan && targetData.catatan[item.id]) ? targetData.catatan[item.id] : '';

            html += `
               <div style="display:flex; justify-content:space-between; align-items:flex-start; padding: 10px 0; border-bottom: 1px dashed #eee; gap:10px;">
                   <div style="flex:1;">
                       <div style="font-size: 13px; font-weight:600; color:var(--text-main);">${item.nama}</div>
                       ${cat ? `<div style="font-size:11px; color:var(--text-muted); margin-top:2px;">Catatan: "${cat}"</div>` : ''}
                   </div>
                   <span class="${b}" style="font-size:10px; padding:4px 8px; white-space:nowrap;">${status}</span>
               </div>
            `;
        });

        html += `
                   </div>
                   <div class="modal-actions" style="margin-top: 10px;">
                       <button class="btn-modal-cancel" style="width:100%; flex:none;" onclick="document.getElementById('modal-rincian-item').remove()">Tutup</button>
                   </div>
               </div>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', html);
    }

    function resetDataAdmin(jenis) {
        if(!confirm('Apakah Anda yakin ingin menghapus data ini dari server?')) return;
        
        showLoading("Menghapus data...");
        fetch(WEB_APP_URL + "?action=delete_data", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ jenis: jenis })
        })
        .then(res => res.json())
        .then(result => {
            hideLoading();
            if(result.success) {
                tampilkanNotifInfo("Data berhasil dihapus dari server.", "Sukses", "success");
                unduhDataDariServer();
                loadMasterMadrasah();
            } else {
                tampilkanNotifInfo("Gagal menghapus data: " + result.message, "Gagal", "error");
            }
        })
        .catch(err => {
            hideLoading();
            tampilkanNotifInfo("Terjadi kesalahan koneksi.", "Error", "error");
        });
    }

    function bukaModalTambahSupervisor() {
        document.getElementById('add-spv-user').value = '';
        document.getElementById('add-spv-pass').value = '';
        document.getElementById('add-spv-name').value = '';
        document.getElementById('add-spv-wilayah').value = '';
        document.getElementById('modal-tambah-spv').style.display = 'flex';
    }

    function simpanAkunSupervisorManual() {
        let user = document.getElementById('add-spv-user').value.trim();
        let pass = document.getElementById('add-spv-pass').value.trim();
        let name = document.getElementById('add-spv-name').value.trim();
        let wil = document.getElementById('add-spv-wilayah').value.trim();

        if(!user || !pass || !name) {
            return alert("Username, Password, dan Nama Supervisor wajib diisi!");
        }

        showLoading("Menyimpan akun supervisor...");
        fetch(WEB_APP_URL + "?action=add_supervisor", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username: user, password: pass, nama_supervisor: name, wilayah_tugas: wil || "Pusat" })
        })
        .then(res => res.json())
        .then(result => {
            hideLoading();
            if(result.success) {
                document.getElementById('modal-tambah-spv').style.display = 'none';
                tampilkanNotifInfo(`Akun supervisor atas nama "${name}" berhasil ditambahkan ke server!`, "Sukses", "success");
            } else {
                tampilkanNotifInfo(result.message || "Gagal menambah supervisor", "Gagal", "error");
            }
        })
        .catch(err => {
            hideLoading();
            tampilkanNotifInfo("Koneksi gagal.", "Error", "error");
        });
    }

    function downloadTemplate(event, jenis) {
        event.stopPropagation();
        let data = [];
        let filename = "";
        if (jenis === 'madrasah') {
            data = [{"Nama_Madrasah": "MI Al-Hidayah", "Wilayah": "Surabaya"}];
            filename = "Template_Import_Madrasah.xlsx";
        } else if (jenis === 'supervisor') {
            data = [{"Username": "spv1", "Password": "123", "Nama_Supervisor": "Ahmad", "Wilayah_Tugas": "Surabaya"}];
            filename = "Template_Akun_Supervisor.xlsx";
        }
        let worksheet = XLSX.utils.json_to_sheet(data);
        let workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, "Template");
        XLSX.writeFile(workbook, filename);
    }

    function triggerExcelImport(jenis) {
        let input = document.createElement('input');
        input.type = 'file';
        input.accept = '.xlsx, .xls';
        input.onchange = e => {
            let file = e.target.files[0];
            if (!file) return;
            showLoading("Mengimpor data Excel ke server...");
            let reader = new FileReader();
            reader.onload = function(e) {
                let data = new Uint8Array(e.target.result);
                let workbook = XLSX.read(data, {type: 'array'});
                let worksheet = workbook.Sheets[workbook.SheetNames[0]];
                let jsonData = XLSX.utils.sheet_to_json(worksheet);

                let actionName = jenis === 'madrasah' ? 'import_madrasah' : 'import_supervisor';

                fetch(WEB_APP_URL + "?action=" + actionName, {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ dataToImport: jsonData })
                })
                .then(res => res.json())
                .then(result => {
                    hideLoading();
                    if(result.success) {
                        tampilkanNotifInfo(`SUKSES! ${result.count || jsonData.length} data berhasil diimpor ke server.`, "Sukses", "success");
                        if(jenis === 'madrasah') loadMasterMadrasah();
                    } else {
                        tampilkanNotifInfo("Gagal impor: " + (result.message || ''), "Gagal", "error");
                    }
                })
                .catch(err => {
                    hideLoading();
                    tampilkanNotifInfo("Koneksi gagal saat mengimpor.", "Error", "error");
                });
            };
            reader.readAsArrayBuffer(file);
        };
        input.click();
    }

    function renderListExport(filterKeyword = "") {
        let container = document.getElementById('list-hasil-supervisi');
        container.innerHTML = '';
        let filtered = masterListExport.filter(item => 
            item.madrasah.toLowerCase().includes(filterKeyword.toLowerCase()) || 
            item.supervisor_nama.toLowerCase().includes(filterKeyword.toLowerCase())
        );
        if(filtered.length === 0) {
            container.innerHTML = `<p style="text-align:center; color:var(--text-muted); font-size:13px; padding:15px;">Hasil supervisi pada periode ini tidak ditemukan.</p>`;
            return;
        }

        filtered.forEach((item) => {
            container.innerHTML += `
                <div class="export-item">
                    <strong style="line-height:1.3;"><i class="ph-duotone ph-buildings"></i> ${item.madrasah}</strong>
                    <span><i class="ph-duotone ph-user"></i> Spv: ${item.supervisor_nama}</span>
                    <span><i class="ph-duotone ph-calendar"></i> Prd: ${item.periode || '1447-1448 H'}</span>
                    <button class="export-btn" onclick="exportKeExcel(${item.actualIndex})"><i class="ph-duotone ph-download-simple"></i> Unduh File Excel</button>
                </div>
            `;
        });
    }

    function filterModalExport() {
        let keyword = document.getElementById('search-input-export').value;
        renderListExport(keyword);
    }

    function bukaModalRiwayatAdmin() {
        let riwayatAll = getRiwayatSemua();
        masterListExport = [];

        riwayatAll.slice().reverse().forEach((item, originalIndex) => {
            let actualIndex = riwayatAll.length - 1 - originalIndex;
            if((item.periode || '1447-1448 H') === globalActivePeriode) {
                masterListExport.push({ ...item, actualIndex: actualIndex });
            }
        });

        document.getElementById('search-input-export').value = '';
        renderListExport('');
        document.getElementById('modal-export-admin').style.display = 'flex';
    }

    function exportKeExcel(indexRiwayat) {
        showLoading("Menyiapkan berkas Excel...");
        setTimeout(() => {
            let riwayat = getRiwayatSemua();
            let savedData = riwayat[indexRiwayat];
            if (!savedData) {
                hideLoading();
                return alert("Data tidak ditemukan!");
            }

            let n = savedData.nilai || {};
            let admScore = (getValScore(n.adm_1) + getValScore(n.adm_2) + getValScore(n.adm_3) + getValScore(n.adm_4) + getValScore(n.adm_5) + getValScore(n.adm_6)) / 6;
            let kurScore = (getValScore(n.kur_1) + getValScore(n.kur_2) + getValScore(n.kur_3) + getValScore(n.kur_4)) / 4;
            let loyScore = (getValScore(n.loy_1) + getValScore(n.loy_2) + getValScore(n.loy_3) + getValScore(n.loy_4)) / 4;
            let nilaiAkhir = (admScore + kurScore + loyScore) / 3;

            let ws_data = [
                ["REKAPITULASI HASIL SUPERVISI MADRASAH BINAAN"],
                [],
                ["Lembaga / Target", ": " + savedData.madrasah],
                ["Tahun Ajaran", ": " + (savedData.periode || '1447-1448 H')],
                ["Nama Supervisor", ": " + savedData.supervisor_nama],
                ["Waktu Penyetoran", ": " + savedData.waktu],
                [],
                ["No", "Kategori", "Materi Pokok", "Status Penilaian", "Catatan Supervisor"]
            ];

            daftarPoinSupervisi.forEach((item, i) => {
                let status = (savedData.nilai && savedData.nilai[item.id]) ? savedData.nilai[item.id] : 'Belum Dinilai';
                if(status === 'Belum') status = 'Belum Dinilai';
                let catatan = (savedData.catatan && savedData.catatan[item.id]) ? savedData.catatan[item.id] : '-';
                ws_data.push([i + 1, item.kategori, item.nama, status, catatan]);
            });

            ws_data.push([]);
            ws_data.push(["KESIMPULAN (RATA-RATA KATEGORI POKOK)"]);
            ws_data.push(["Administrasi", admScore.toFixed(2)]);
            ws_data.push(["Pendataan Digital", kurScore.toFixed(2)]);
            ws_data.push(["KBM & Laporan", loyScore.toFixed(2)]);
            ws_data.push([]);
            ws_data.push(["Nilai Akhir", nilaiAkhir.toFixed(2)]);
            
            let worksheet = XLSX.utils.aoa_to_sheet(ws_data);
            let workbook = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(workbook, worksheet, "Hasil Supervisi");
            
            let cleanFileName = savedData.madrasah.replace(/[^a-zA-Z0-9\s-]/g, '_').substring(0, 50);
            XLSX.writeFile(workbook, `Hasil_Supervisi_${cleanFileName}_${savedData.periode || '1447-1448_H'}.xlsx`);
            hideLoading();
            tampilkanNotifInfo("File Excel berhasil diunduh!", "Sukses", "success");
        }, 500);
    }

    function updateVisualMenuTugas() {
        daftarPoinSupervisi.forEach(item => {
            let cardElement = document.getElementById('card-' + item.id);
            let nilai = hasilNilaiSupervisi[item.id];
            
            if (cardElement) {
                cardElement.classList.remove('task-baik', 'task-sedang', 'task-buruk');
                if (nilai === 'Baik') cardElement.classList.add('task-baik');
                else if (nilai === 'Sedang') cardElement.classList.add('task-sedang');
                else if (nilai === 'Buruk') cardElement.classList.add('task-buruk');
            }
        });

        let tAdm = 0, tKur = 0, tLoy = 0;
        daftarPoinSupervisi.forEach(item => {
            let score = getValScore(hasilNilaiSupervisi[item.id]);
            if(item.kategori === 'Administrasi') tAdm += score;
            else if(item.kategori === 'Pendataan') tKur += score;
            else if(item.kategori === 'KBM') tLoy += score;
        });

        let avgAdm = tAdm / 6;
        let avgKur = tKur / 4;
        let avgLoy = tLoy / 4;
        let avgTotal = (avgAdm + avgKur + avgLoy) / 3;

        let elAdm = document.getElementById('avg-adm-task');
        let elKur = document.getElementById('avg-kur-task');
        let elLoy = document.getElementById('avg-loy-task');
        let elTot = document.getElementById('avg-total-task');
        let chartEl = document.getElementById('donut-chart-task');

        if(elAdm) elAdm.innerText = avgAdm.toFixed(1);
        if(elKur) elKur.innerText = avgKur.toFixed(1);
        if(elLoy) elLoy.innerText = avgLoy.toFixed(1);
        if(elTot) elTot.innerText = avgTotal.toFixed(1);

        if(chartEl) {
            let totalSum = avgAdm + avgKur + avgLoy;
            if(totalSum === 0) {
                chartEl.style.background = `conic-gradient(#e0e0e0 0% 100%)`;
            } else {
                let pAdm = (avgAdm / totalSum) * 100;
                let pKur = (avgKur / totalSum) * 100;
                chartEl.style.background = `conic-gradient(#f6d365 0% ${pAdm}%, #4facfe ${pAdm}% ${pAdm + pKur}%, #43e97b ${pAdm + pKur}% 100%)`;
            }
        }
    }

    function switchTabAdmin(tabId, element) {
        document.querySelectorAll('#admin-app .screen-content').forEach(s => { s.classList.remove('active'); });
        document.getElementById(tabId).classList.add('active');
        
        document.querySelectorAll('#admin-app .nav-item').forEach(item => {
            item.classList.remove('admin-active');
        });
        element.classList.add('admin-active');
        if(tabId === 'tab-dashboard-admin') unduhDataDariServer();
    }

    function switchTab(tabId, element) {
        resetTugasView();
        const screens = document.querySelectorAll('#main-app .screen-content');
        screens.forEach(s => { s.classList.remove('active'); s.scrollTop = 0; });
        document.getElementById(tabId).classList.add('active');
        
        if(tabId === 'tab-nilai') renderRekapNilai();
        if(tabId === 'tab-tugas') updateVisualMenuTugas();
        if(tabId === 'tab-beranda') {
            unduhDataDariServer();
            updateSupervisorDashboard();
        }

        document.querySelectorAll('#main-app .nav-item').forEach(item => {
            item.classList.remove('active');
        });
        element.classList.add('active');
    }

    function openSubMenu(kategori) {
        document.getElementById('view-kategori-tugas').style.display = 'none';
        document.getElementById('view-administrasi').style.display = 'none';
        document.getElementById('view-pendataan').style.display = 'none';
        document.getElementById('view-kbm').style.display = 'none';
        document.getElementById('view-' + kategori).style.display = 'flex';
        document.getElementById('btn-back-tugas').style.display = 'flex';
        
        let t = "";
        if(kategori === 'administrasi') t = "Manajemen & Administrasi";
        if(kategori === 'pendataan') t = "Pendataan & Validasi Digital";
        if(kategori === 'kbm') t = "KBM, Agenda & Laporan";
        document.getElementById('tugas-title').innerText = t;
        updateVisualMenuTugas();
    }

    function resetTugasView() {
        document.getElementById('view-kategori-tugas').style.display = 'flex';
        document.getElementById('view-administrasi').style.display = 'none';
        document.getElementById('view-pendataan').style.display = 'none';
        document.getElementById('view-kbm').style.display = 'none';
        document.getElementById('btn-back-tugas').style.display = 'none';
        document.getElementById('tugas-title').innerText = "Pokok Supervisi";
        updateVisualMenuTugas();
    }

    function bukaFormPenilaian(namaMateri, poinId) {
        const madrasahTerpilih = document.getElementById('label-madrasah-terpilih-header').innerText;
        if (!madrasahTerpilih || madrasahTerpilih === 'Pilih Madrasah') {
            tampilkanNotifInfo("Silakan pilih Madrasah Binaan terlebih dahulu lewat badge biru di bagian atas layar sebelum melakukan penilaian!", "Perhatian", "warning");
            return;
        }
        
        activePoinId = poinId;
        document.getElementById('modal-materi-title').innerText = namaMateri;
        document.getElementById('modal-madrasah-target').innerText = "Madrasah: " + madrasahTerpilih;
        
        let nilaiSaatIni = hasilNilaiSupervisi[poinId];
        document.getElementsByName('pilihan-nilai').forEach(r => {
            r.checked = (r.value === nilaiSaatIni);
        });

        let catatanSaatIni = hasilCatatanSupervisi[poinId] || "";
        document.getElementById('modal-catatan').value = catatanSaatIni;

        document.getElementById('modal-penilaian').style.display = 'flex';
    }

    function simpanNilaiSementara() {
        let val = null;
        document.getElementsByName('pilihan-nilai').forEach(r => { if (r.checked) val = r.value; });
        if (!val) return alert("Silakan pilih status penilaian!");
        
        if (val === 'Belum') {
            delete hasilNilaiSupervisi[activePoinId];
            delete hasilCatatanSupervisi[activePoinId];
            val = 'Belum Dinilai';
        } else {
            hasilNilaiSupervisi[activePoinId] = val;
            hasilCatatanSupervisi[activePoinId] = document.getElementById('modal-catatan').value.trim();
        }

        document.getElementById('modal-penilaian').style.display = 'none';
        updateVisualMenuTugas();

        let materiTitle = document.getElementById('modal-materi-title').innerText;
        showToast("Berhasil Disimpan", `Status materi ${materiTitle} disimpan sebagai ${val}.`, "success");
    }

    function renderRekapNilai() {
        const c = document.getElementById('rekap-nilai-container');
        let countDinilai = 0;
        for (let key in hasilNilaiSupervisi) {
            if (hasilNilaiSupervisi[key] && hasilNilaiSupervisi[key] !== 'Belum') countDinilai++;
        }

        let html = `
            <div class="summary-card animate-item">
               <p>PROGRES PENILAIAN</p>
               <h3>${countDinilai} / ${daftarPoinSupervisi.length}</h3>
               <p>Supervisi Tahun Ajaran ${globalActivePeriode}</p>
            </div>
        `;
        
        let kategoriMap = {
            'Administrasi': 'Manajemen & Administrasi',
            'Pendataan': 'Pendataan & Validasi Digital',
            'KBM': 'KBM, Agenda & Laporan'
        };

        ['Administrasi', 'Pendataan', 'KBM'].forEach(katKey => {
            html += `<div class="cat-header animate-item">${kategoriMap[katKey]}</div>`;
            daftarPoinSupervisi.filter(i => i.kategori === katKey).forEach((item) => {
                let nilai = hasilNilaiSupervisi[item.id];
                let b = "badge-belum"; let s = "Belum Dinilai";
                if (nilai === 'Baik') { b = "badge-baik"; s = "<i class='ph-fill ph-check-circle'></i> Baik"; }
                else if (nilai === 'Sedang') { b = "badge-sedang"; s = "<i class='ph-fill ph-warning-circle'></i> Sedang"; }
                else if (nilai === 'Buruk') { b = "badge-buruk"; s = "<i class='ph-fill ph-x-circle'></i> Buruk"; }
                
                html += `
                    <div class="item-card animate-item" style="padding: 15px 20px; flex-direction: column; align-items: flex-start;">
                        <div style="display: flex; width: 100%; align-items: center; justify-content: space-between;">
                            <div class="item-text"><h4 style="font-size: 14px; margin:0;">${item.nama}</h4></div>
                            <div class="${b}" style="margin-left: 0;">${s}</div>
                        </div>
                        ${(hasilCatatanSupervisi[item.id]) ? `<div style="margin-top: 10px; font-size: 12px; color: var(--text-muted); background: var(--bg-color); padding: 8px 12px; border-radius: 8px; width: 100%; box-sizing: border-box;"><strong>Catatan:</strong> ${hasilCatatanSupervisi[item.id]}</div>` : ''}
                    </div>`;
            });
        });
        html += `<button class="btn-sync animate-item" style="margin-bottom: 10px;" onclick="sinkronisasiDataPermanen()">Simpan & Setor ke Admin</button>`;
        html += `<button class="btn-sync animate-item" style="background: #25D366; margin-top: 0; margin-bottom: 25px;" onclick="kirimWhatsApp()"><i class="ph-duotone ph-whatsapp-logo"></i> Kirim Laporan via WhatsApp</button>`;
        c.innerHTML = html;
    }

    function kirimWhatsApp() {
        let madrasah = document.getElementById('label-madrasah-terpilih-header').innerText;
        if (!madrasah || madrasah === 'Pilih Madrasah') {
            tampilkanNotifInfo("Silakan pilih Madrasah target terlebih dahulu di menu Tugas!", "Perhatian", "warning");
            return;
        }
        
        let namaSpv = sessionStorage.getItem('activeSupervisorName') || 'Supervisor';
        let waktu = new Date().toLocaleString('id-ID');

        let admScore = (getValScore(hasilNilaiSupervisi.adm_1) + getValScore(hasilNilaiSupervisi.adm_2) + getValScore(hasilNilaiSupervisi.adm_3) + getValScore(hasilNilaiSupervisi.adm_4) + getValScore(hasilNilaiSupervisi.adm_5) + getValScore(hasilNilaiSupervisi.adm_6)) / 6;
        let kurScore = (getValScore(hasilNilaiSupervisi.kur_1) + getValScore(hasilNilaiSupervisi.kur_2) + getValScore(hasilNilaiSupervisi.kur_3) + getValScore(hasilNilaiSupervisi.kur_4)) / 4;
        let loyScore = (getValScore(hasilNilaiSupervisi.loy_1) + getValScore(hasilNilaiSupervisi.loy_2) + getValScore(hasilNilaiSupervisi.loy_3) + getValScore(hasilNilaiSupervisi.loy_4)) / 4;
        let nilaiAkhir = (admScore + kurScore + loyScore) / 3;

        let msg = `*Laporan Supervisi Mabin IASS*\n`;
        msg += `Madrasah: ${madrasah}\n`;
        msg += `Tahun Ajaran: ${globalActivePeriode}\n`;
        msg += `Supervisor: ${namaSpv}\n`;
        msg += `Waktu: ${waktu}\n\n`;

        let kategoriMap = {
            'Administrasi': 'Manajemen & Administrasi',
            'Pendataan': 'Pendataan & Validasi Digital',
            'KBM': 'KBM, Agenda & Laporan'
        };

        ['Administrasi', 'Pendataan', 'KBM'].forEach(katKey => {
            msg += `*${kategoriMap[katKey]}*\n`;
            daftarPoinSupervisi.filter(i => i.kategori === katKey).forEach((item) => {
                let status = hasilNilaiSupervisi[item.id] || 'Belum Dinilai';
                if(status === 'Belum') status = 'Belum Dinilai';
                let catatan = hasilCatatanSupervisi[item.id] ? ` (Catatan: ${hasilCatatanSupervisi[item.id]})` : '';
                msg += `- ${item.nama}: ${status}${catatan}\n`;
            });
            msg += `\n`;
        });

        msg += `*Kesimpulan:*\n`;
        msg += `Administrasi: ${admScore.toFixed(2)}\n`;
        msg += `Pendataan Digital: ${kurScore.toFixed(2)}\n`;
        msg += `KBM & Laporan: ${loyScore.toFixed(2)}\n\n`;
        msg += `Nilai Akhir : ${nilaiAkhir.toFixed(2)}`;

        let waUrl = `https://api.whatsapp.com/send?text=${encodeURIComponent(msg)}`;
        window.open(waUrl, '_blank');
    }

    // ================= FUNGSI MENGIRIM DATA KE SERVER ================= //
    function sinkronisasiDataPermanen() {
        const selectedMadrasah = document.getElementById('label-madrasah-terpilih-header').innerText;
        if(!selectedMadrasah || selectedMadrasah === 'Pilih Madrasah') {
            tampilkanNotifInfo("Silakan pilih Madrasah target terlebih dahulu di menu Tugas!", "Perhatian", "warning");
            return;
        }

        let namaSpv = sessionStorage.getItem('activeSupervisorName') || 'Supervisor';
        let spvId = sessionStorage.getItem('activeSupervisorId') || 1;
        
        let dataBaru = {
            madrasah: selectedMadrasah,
            supervisor_nama: namaSpv,
            supervisor_id: spvId, 
            periode: globalActivePeriode,
            nilai: hasilNilaiSupervisi,
            catatan: hasilCatatanSupervisi
        };

        showLoading("Menyetor data ke server pusat...");

        fetch(WEB_APP_URL + "?action=submit_supervisi", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(dataBaru)
        })
        .then(async (response) => {
            const text = await response.text();
            try {
                return JSON.parse(text); 
            } catch (err) {
                console.error("Respons server bukan JSON mentah:", text);
                throw new Error("Server Error: " + text.substring(0, 100));
            }
        })
        .then(result => {
            hideLoading();
            if(result.success) {
                tampilkanNotifInfo("Data berhasil disetor ke Admin dan tersimpan di database pusat.", "Sukses", "success");
                unduhDataDariServer();
            } else {
                tampilkanNotifInfo("Ditolak Server: " + result.message, "Gagal", "error");
            }
            updateSupervisorDashboard();
        })
        .catch((error) => {
            console.error("Error Fetch:", error);
            hideLoading();
            tampilkanNotifInfo(error.message, "Error Server", "error");
            updateSupervisorDashboard();
        });
    }
</script>

</body>
</html>

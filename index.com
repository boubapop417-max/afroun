<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>العفرون اون لاين | El Affroun Online</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;600;700;800&display=swap" rel="stylesheet">

    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        brand: {
                            primary: '#e63946',
                            dark: '#1d3557',
                            light: '#f1faee',
                            gold: '#FFD700',
                            goldDark: '#DAA520'
                        }
                    },
                    fontFamily: {
                        sans: ['Cairo', 'sans-serif'],
                    },
                    boxShadow: {
                        'card': '0 10px 30px -10px rgba(0,0,0,0.1)',
                        'floating': '0 15px 35px rgba(0,0,0,0.2)'
                    }
                }
            }
        }
    </script>

    <style>
        body { background-color: #F3F4F6; -webkit-tap-highlight-color: transparent; padding-bottom: 90px; }
        
        /* Hide Scrollbar */
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }

        /* Category Images */
        .cat-item { flex: 0 0 auto; width: 80px; display: flex; flex-direction: column; align-items: center; cursor: pointer; transition: transform 0.2s; }
        .cat-item:active { transform: scale(0.95); }
        .cat-img-container {
            width: 70px; height: 70px; border-radius: 50%; overflow: hidden;
            border: 2px solid white; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: all 0.3s; position: relative;
        }
        .cat-img-container img { width: 100%; height: 100%; object-fit: cover; }
        .cat-item.active .cat-img-container { border-color: #e63946; transform: scale(1.1); box-shadow: 0 0 0 4px rgba(230, 57, 70, 0.2); }

        /* Professional Card */
        .ad-card {
            background: white; border-radius: 20px; overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: transform 0.2s;
            border: 1px solid #f0f0f0; position: relative;
        }
        .ad-card:active { transform: scale(0.98); }
        
        /* Featured Card */
        .ad-card.featured {
            border: 2px solid #FFD700;
            background: linear-gradient(to bottom right, #fffff0, #ffffff);
        }
        .featured-badge {
            position: absolute; top: 10px; right: 10px;
            background: linear-gradient(45deg, #FFD700, #DAA520);
            color: black; font-weight: bold; font-size: 0.7rem;
            padding: 4px 10px; border-radius: 20px; z-index: 10;
            box-shadow: 0 4px 10px rgba(255, 215, 0, 0.4);
            display: flex; align-items: center; gap: 4px;
        }

        /* Chat Styles */
        .chat-container { display: flex; flex-direction: column; height: 100%; }
        .chat-messages { flex: 1; overflow-y: auto; padding: 15px; display: flex; flex-direction: column; gap: 10px; }
        .chat-bubble { max-width: 80%; padding: 10px 15px; border-radius: 18px; font-size: 14px; position: relative; word-wrap: break-word; }
        .chat-me { background: #1d3557; color: white; border-bottom-left-radius: 4px; align-self: flex-end; }
        .chat-other { background: #e5e7eb; color: #333; border-bottom-right-radius: 4px; align-self: flex-start; }

        /* Modals */
        .modal { opacity: 0; pointer-events: none; position: fixed; inset: 0; z-index: 100; display: flex; align-items: center; justify-content: center; background: rgba(0,0,0,0.6); backdrop-filter: blur(5px); transition: opacity 0.3s; }
        .modal.active { opacity: 1; pointer-events: auto; }
        .modal-box { background: white; width: 100%; max-width: 480px; max-height: 90vh; border-radius: 24px; overflow: hidden; transform: translateY(20px); transition: transform 0.3s; display: flex; flex-direction: column; }
        .modal.active .modal-box { transform: translateY(0); }

        /* FAB */
        .fab-btn { width: 56px; height: 56px; border-radius: 50%; color: white; display: flex; align-items: center; justify-content: center; font-size: 22px; box-shadow: 0 10px 25px rgba(230, 57, 70, 0.4); cursor: pointer; transition: transform 0.2s; }
        .fab-btn:active { transform: scale(0.9); }
    </style>
</head>
<body class="text-gray-800">

    <!-- Navbar -->
    <nav class="bg-white/95 backdrop-blur-sm sticky top-0 z-50 border-b border-gray-100">
        <div class="container mx-auto px-4 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2 cursor-pointer" onclick="window.location.reload()">
                <div class="w-10 h-10 bg-brand-primary text-white rounded-xl flex items-center justify-center text-xl shadow-lg">
                    <i class="fas fa-store"></i>
                </div>
                <h1 class="font-bold text-lg text-brand-dark">العفرون <span class="text-brand-primary">اون لاين</span></h1>
            </div>
            
            <div class="flex items-center gap-3">
                <button onclick="toggleLang()" class="bg-gray-100 px-3 py-1 rounded-full text-xs font-bold text-gray-600">Fr</button>
                <button onclick="openInbox()" class="relative text-gray-600 hover:text-brand-primary transition p-2">
                    <i class="fas fa-comment-alt text-xl"></i>
                    <span id="msgBadge" class="hidden absolute top-0 right-0 w-3 h-3 bg-red-500 rounded-full border-2 border-white"></span>
                </button>
                <button id="authBtn" onclick="openModal('loginModal')" class="bg-brand-dark text-white px-5 py-2 rounded-xl text-sm font-bold shadow hover:bg-gray-800 transition">دخول</button>
                <div id="userAvatar" class="hidden w-10 h-10 rounded-full bg-brand-primary text-white flex items-center justify-center font-bold border-2 border-white shadow cursor-pointer" onclick="logout()">U</div>
            </div>
        </div>
    </nav>

    <!-- Banner Slider -->
    <div class="container mx-auto px-4 mt-4">
        <div id="bannerSlider" class="w-full h-44 md:h-60 rounded-2xl overflow-hidden shadow-lg bg-gray-200 relative">
            <!-- Images will be injected here -->
        </div>
    </div>

    <!-- Categories (Real Images) -->
    <div class="container mx-auto px-4 mt-6">
        <h3 class="font-bold text-gray-800 mb-3 px-2">تصفح حسب الفئة</h3>
        <div class="category-scroll no-scrollbar" id="catContainer">
            <!-- Categories injected here -->
        </div>
    </div>

    <!-- Ads Grid -->
    <div class="container mx-auto px-4 mt-8">
        <div class="flex justify-between items-center mb-4 px-2">
            <h2 class="text-xl font-bold text-brand-dark">أحدث الإعلانات</h2>
            <div class="bg-white px-3 py-1 rounded-full shadow-sm text-sm text-gray-500 border" id="adsCounter">0 إعلان</div>
        </div>

        <div id="adsGrid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5 pb-10">
            <div class="col-span-full text-center py-20 text-gray-400">
                <i class="fas fa-circle-notch fa-spin text-3xl"></i>
                <p class="mt-2">جاري تحميل المنتجات...</p>
            </div>
        </div>
    </div>

    <!-- Floating Filter Button -->
    <div class="fixed bottom-24 right-5 z-40">
        <button onclick="openModal('searchModal')" class="w-12 h-12 bg-brand-dark text-white rounded-full shadow-lg flex items-center justify-center hover:bg-gray-800 transition">
            <i class="fas fa-filter"></i>
        </button>
    </div>

    <!-- Floating Add Button -->
    <div class="fixed bottom-6 right-5 z-40 flex flex-col gap-4">
        <button id="adminBtn" onclick="openModal('adminModal')" class="hidden w-12 h-12 bg-brand-gold text-black rounded-full shadow-lg flex items-center justify-center">
            <i class="fas fa-crown"></i>
        </button>
        <button onclick="checkAuthAndOpenAddAd()" class="fab-btn bg-brand-primary hover:bg-red-700">
            <i class="fas fa-plus"></i>
        </button>
    </div>

    <!-- ================= MODALS ================= -->

    <!-- 1. Add Ad Modal -->
    <div id="addAdModal" class="modal">
        <div class="modal-box">
            <div class="bg-brand-primary text-white p-4 flex justify-between items-center">
                <h3 class="font-bold">إضافة إعلان جديد</h3>
                <button onclick="closeModal('addAdModal')"><i class="fas fa-times"></i></button>
            </div>
            <form onsubmit="handleAddAd(event)" class="p-5 overflow-y-auto flex-1 space-y-4">
                <input type="text" id="adTitle" placeholder="عنوان المنتج (مثال: هاتف آيفون 13)" class="w-full p-3 bg-gray-50 rounded-xl border focus:border-brand-primary outline-none" required>
                <div class="grid grid-cols-2 gap-3">
                    <select id="adCategory" class="p-3 bg-gray-50 rounded-xl border outline-none" required></select>
                    <select id="adCity" class="p-3 bg-gray-50 rounded-xl border outline-none" required></select>
                </div>
                <div class="grid grid-cols-2 gap-3">
                    <input type="number" id="adPrice" placeholder="السعر (DA)" class="p-3 bg-gray-50 rounded-xl border outline-none" required>
                    <input type="tel" id="adPhone" placeholder="رقم الهاتف" class="p-3 bg-gray-50 rounded-xl border outline-none" required>
                </div>
                <textarea id="adDesc" rows="3" placeholder="وصف تفصيلي للمنتج..." class="w-full p-3 bg-gray-50 rounded-xl border outline-none" required></textarea>
                
                <div class="relative h-32 border-2 border-dashed border-gray-300 rounded-xl flex flex-col items-center justify-center text-gray-400 cursor-pointer hover:bg-gray-50 hover:border-brand-primary transition overflow-hidden">
                    <i class="fas fa-cloud-upload-alt text-3xl mb-1"></i>
                    <span class="text-xs">اضغط لرفع صورة</span>
                    <input type="file" id="adImage" accept="image/*" class="absolute inset-0 opacity-0 cursor-pointer" required onchange="previewImage(this)">
                    <img id="imgPreview" class="absolute inset-0 w-full h-full object-cover hidden">
                </div>
                <button type="submit" id="pubBtn" class="w-full py-3 bg-brand-dark text-white font-bold rounded-xl shadow-lg mt-2">نشر الإعلان</button>
            </form>
        </div>
    </div>

    <!-- 2. Details Modal -->
    <div id="detailsModal" class="modal">
        <div class="modal-box h-full">
            <div class="relative h-64 bg-gray-200">
                <img id="dtImage" class="w-full h-full object-cover">
                <button onclick="closeModal('detailsModal')" class="absolute top-3 left-3 w-8 h-8 bg-white/80 rounded-full flex items-center justify-center shadow"><i class="fas fa-times"></i></button>
                <div class="absolute bottom-3 right-3 bg-brand-primary text-white px-4 py-1 rounded-full font-bold shadow-lg" id="dtPrice"></div>
            </div>
            <div class="p-5 flex-1 overflow-y-auto">
                <h2 id="dtTitle" class="text-2xl font-bold text-gray-800 mb-2"></h2>
                <div class="flex gap-2 mb-4 text-xs font-bold text-gray-500">
                    <span class="bg-gray-100 px-3 py-1 rounded-full"><i class="fas fa-map-marker-alt text-brand-primary"></i> <span id="dtCity"></span></span>
                    <span class="bg-gray-100 px-3 py-1 rounded-full"><i class="fas fa-tag text-brand-dark"></i> <span id="dtCat"></span></span>
                </div>
                <p id="dtDesc" class="text-gray-600 text-sm leading-relaxed mb-6 bg-gray-50 p-4 rounded-xl border"></p>
                
                <div class="grid grid-cols-2 gap-3 mt-auto">
                    <a id="dtPhoneBtn" href="#" class="bg-green-500 text-white py-3 rounded-xl font-bold flex items-center justify-center gap-2 shadow hover:bg-green-600">
                        <i class="fas fa-phone-alt"></i> اتصل
                    </a>
                    <button onclick="startChatFromDetails()" class="bg-brand-dark text-white py-3 rounded-xl font-bold flex items-center justify-center gap-2 shadow hover:bg-gray-800">
                        <i class="fas fa-comment-dots"></i> دردشة
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 3. Chat Modal (Real-time) -->
    <div id="chatModal" class="modal">
        <div class="modal-box h-[85vh]">
            <div class="bg-brand-dark text-white p-3 flex justify-between items-center shadow-md z-10">
                <div class="flex items-center gap-3">
                    <button id="chatBackBtn" onclick="showInboxView()" class="hidden"><i class="fas fa-arrow-right"></i></button>
                    <div>
                        <h3 id="chatHeaderTitle" class="font-bold">الرسائل</h3>
                        <span id="chatSubTitle" class="text-xs text-gray-300 hidden">متصل الآن</span>
                    </div>
                </div>
                <button onclick="closeModal('chatModal')"><i class="fas fa-times"></i></button>
            </div>

            <!-- 3.1 Inbox View -->
            <div id="inboxView" class="flex-1 overflow-y-auto p-2 bg-gray-50">
                <!-- Chat List injected here -->
                <div class="text-center text-gray-400 mt-10">جاري تحميل المحادثات...</div>
            </div>

            <!-- 3.2 Conversation View -->
            <div id="conversationView" class="hidden flex-1 flex flex-col h-full bg-gray-100 relative">
                <div id="messagesContainer" class="chat-messages">
                    <!-- Messages injected here -->
                </div>
                <div class="p-3 bg-white border-t flex gap-2 items-center">
                    <input type="text" id="msgInput" placeholder="اكتب رسالتك..." class="flex-1 bg-gray-100 border-none rounded-full px-4 py-3 outline-none focus:ring-2 focus:ring-brand-primary">
                    <button onclick="sendMessage()" class="w-11 h-11 bg-brand-primary text-white rounded-full flex items-center justify-center shadow hover:bg-red-600 transition transform active:scale-95">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 4. Login Modal -->
    <div id="loginModal" class="modal">
        <div class="modal-box p-6 max-w-sm">
            <h2 class="text-2xl font-bold text-center mb-6 text-brand-dark">تسجيل الدخول</h2>
            <form onsubmit="handleLogin(event)" class="space-y-4">
                <input type="text" id="logEmail" placeholder="البريد الإلكتروني / admin" class="w-full p-3 bg-gray-50 rounded-xl border outline-none">
                <input type="password" id="logPass" placeholder="كلمة المرور" class="w-full p-3 bg-gray-50 rounded-xl border outline-none">
                <button class="w-full py-3 bg-brand-primary text-white font-bold rounded-xl shadow-lg">دخول</button>
            </form>
            <p id="logError" class="text-red-500 text-xs text-center mt-3 hidden"></p>
        </div>
    </div>

    <!-- 5. Search Modal -->
    <div id="searchModal" class="modal">
        <div class="modal-box p-6 max-w-sm">
            <h3 class="font-bold mb-4">بحث متقدم</h3>
            <input type="text" id="searchKeyword" placeholder="ماذا تبحث؟" class="w-full p-3 mb-3 border rounded-xl bg-gray-50">
            <div class="flex gap-2 mb-4">
                <select id="filterCat" class="w-1/2 p-3 border rounded-xl bg-gray-50"></select>
                <select id="filterCity" class="w-1/2 p-3 border rounded-xl bg-gray-50"></select>
            </div>
            <button onclick="applyFilter()" class="w-full bg-brand-dark text-white py-3 rounded-xl font-bold">عرض النتائج</button>
            <button onclick="closeModal('searchModal')" class="w-full mt-3 text-gray-500">إلغاء</button>
        </div>
    </div>

    <!-- 6. Admin Modal -->
    <div id="adminModal" class="modal">
        <div class="modal-box p-6 max-w-sm">
            <h3 class="font-bold mb-4">رفع بانر إعلاني</h3>
            <input type="file" id="bannerFile" class="w-full border p-2 mb-4 rounded-lg">
            <button onclick="uploadBanner()" class="w-full bg-brand-gold text-black font-bold py-2 rounded-xl">رفع</button>
            <button onclick="closeModal('adminModal')" class="mt-3 text-gray-500 w-full">إغلاق</button>
        </div>
    </div>

    <!-- ================= LOGIC ================= -->
    <script type="module">
        import { initializeApp } from "https://www.gstatic.com/firebasejs/9.22.0/firebase-app.js";
        import { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, onAuthStateChanged, signOut } from "https://www.gstatic.com/firebasejs/9.22.0/firebase-auth.js";
        import { getFirestore, collection, addDoc, getDocs, deleteDoc, doc, updateDoc, query, orderBy, where, serverTimestamp, onSnapshot, getDoc } from "https://www.gstatic.com/firebasejs/9.22.0/firebase-firestore.js";
        import { getStorage, ref, uploadBytes, getDownloadURL } from "https://www.gstatic.com/firebasejs/9.22.0/firebase-storage.js";

        const firebaseConfig = {
            apiKey: "AIzaSyAaXp-gUOQ_G2s-kM8JhaqW8TJcJ4Nqcuo",
            authDomain: "comondi-fae4b.firebaseapp.com",
            projectId: "comondi-fae4b",
            storageBucket: "comondi-fae4b.firebasestorage.app",
            messagingSenderId: "932777870241",
            appId: "1:932777870241:web:78b0cf3a3cf14046be01e0"
        };

        const app = initializeApp(firebaseConfig);
        const auth = getAuth(app);
        const db = getFirestore(app);
        const storage = getStorage(app);

        // State
        let currentUser = null;
        let isAdmin = false;
        let allAds = [];
        let currentAd = null;
        let activeChatId = null;
        let messagesUnsubscribe = null;

        // Data with Real Images (Unsplash Keywords)
        const categories = [
            { id: "سيارات و مركبات", img: "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=150&q=80" },
            { id: "عقارات", img: "https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=150&q=80" },
            { id: "هواتف و إلكترونيات", img: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=150&q=80" },
            { id: "وظائف", img: "https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&w=150&q=80" },
            { id: "ألبسة و موضة", img: "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?auto=format&fit=crop&w=150&q=80" },
            { id: "حلويات", img: "https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=150&q=80" },
            { id: "خدمات", img: "https://images.unsplash.com/photo-1581092921461-eab62e97a782?auto=format&fit=crop&w=150&q=80" },
            { id: "أجهزة كهرومنزلية", img: "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=150&q=80" },
            { id: "معدات مهنية", img: "https://images.unsplash.com/photo-1530124566582-a618bc2615dc?auto=format&fit=crop&w=150&q=80" },
            { id: "أخرى", img: "https://images.unsplash.com/photo-1511988617509-a57c8a288659?auto=format&fit=crop&w=150&q=80" }
        ];
        const cities = ["العفرون", "موزاية", "شفة", "واد جر", "احمر العين", "البليدة"];

        // Initialization
        window.onload = () => {
            renderCategories();
            populateSelects();
            getAds();
            loadBanners();
            setupBannerRotator();
        };

        function renderCategories() {
            const container = document.getElementById('catContainer');
            container.innerHTML = '';
            categories.forEach(cat => {
                container.innerHTML += `
                    <div class="cat-item group" onclick="document.getElementById('searchKeyword').value='${cat.id}'; applyFilter()">
                        <div class="cat-img-container">
                            <img src="${cat.img}" alt="${cat.id}">
                        </div>
                        <span class="text-xs font-bold text-gray-700 mt-2 text-center leading-tight group-hover:text-brand-primary">${cat.id}</span>
                    </div>`;
            });
        }

        function populateSelects() {
            const selects = ['adCategory', 'adCity', 'filterCat', 'filterCity'];
            selects.forEach(id => {
                const el = document.getElementById(id);
                el.innerHTML = `<option value="">${id.includes('City') ? 'كل المدن' : 'كل الفئات'}</option>`;
                const list = id.includes('City') ? cities : categories.map(c => c.id);
                list.forEach(item => el.innerHTML += `<option value="${item}">${item}</option>`);
            });
        }

        // --- Ad Logic ---
        window.handleAddAd = async (e) => {
            e.preventDefault();
            const btn = document.getElementById('pubBtn');
            btn.innerText = "جاري النشر..."; btn.disabled = true;

            try {
                const file = document.getElementById('adImage').files[0];
                const imageRef = ref(storage, `ads/${Date.now()}`);
                const url = await getDownloadURL((await uploadBytes(imageRef, file)).ref);

                await addDoc(collection(db, "ads"), {
                    title: document.getElementById('adTitle').value,
                    category: document.getElementById('adCategory').value,
                    city: document.getElementById('adCity').value,
                    price: parseFloat(document.getElementById('adPrice').value),
                    phone: document.getElementById('adPhone').value,
                    desc: document.getElementById('adDesc').value,
                    imageUrl: url,
                    uid: currentUser.uid,
                    createdAt: serverTimestamp(),
                    isFeatured: false
                });

                closeModal('addAdModal');
                alert("تم النشر بنجاح!");
                getAds();
            } catch (err) { alert("حدث خطأ"); }
            btn.innerText = "نشر الإعلان"; btn.disabled = false;
        };

        window.getAds = async () => {
            const q = query(collection(db, "ads"), orderBy("createdAt", "desc"));
            const snap = await getDocs(q);
            allAds = [];
            snap.forEach(d => allAds.push({ id: d.id, ...d.data() }));
            renderAds(allAds);
        };

        window.renderAds = (list) => {
            const grid = document.getElementById('adsGrid');
            grid.innerHTML = '';
            document.getElementById('adsCounter').innerText = list.length + ' إعلان';

            if(list.length === 0) { grid.innerHTML = '<div class="col-span-full text-center py-10">لا توجد إعلانات</div>'; return; }

            list.forEach(ad => {
                // Professional Card Design
                const isFeatured = ad.isFeatured;
                const featuredClass = isFeatured ? 'featured' : '';
                const featuredBadge = isFeatured ? `<div class="featured-badge"><i class="fas fa-star"></i> مميز</div>` : '';
                const delBtn = isAdmin ? `<button onclick="event.stopPropagation(); deleteAd('${ad.id}')" class="absolute top-2 left-2 bg-red-600 text-white w-6 h-6 rounded z-30 flex items-center justify-center shadow">X</button>` : '';

                grid.innerHTML += `
                    <div onclick="showDetails('${ad.id}')" class="ad-card ${featuredClass} group cursor-pointer flex flex-col h-full">
                        ${featuredBadge} ${delBtn}
                        <div class="h-48 relative bg-gray-200 overflow-hidden">
                            <img src="${ad.imageUrl}" class="w-full h-full object-cover transition duration-700 group-hover:scale-110">
                            <div class="absolute bottom-0 inset-x-0 bg-gradient-to-t from-black/60 to-transparent p-3">
                                <span class="text-white font-bold text-lg">${ad.price} DA</span>
                            </div>
                        </div>
                        <div class="p-4 flex flex-col flex-1">
                            <h3 class="font-bold text-gray-800 mb-1 line-clamp-2 leading-snug">${ad.title}</h3>
                            <div class="flex justify-between items-center mt-auto pt-3 border-t border-gray-100 text-xs text-gray-500 font-bold">
                                <span class="flex items-center gap-1"><i class="fas fa-map-marker-alt text-brand-primary"></i> ${ad.city}</span>
                                <span class="bg-gray-100 px-2 py-1 rounded-md text-brand-dark">${ad.category}</span>
                            </div>
                        </div>
                    </div>`;
            });
        };

        window.showDetails = (id) => {
            const ad = allAds.find(a => a.id === id);
            currentAd = ad;

            document.getElementById('dtImage').src = ad.imageUrl;
            document.getElementById('dtTitle').innerText = ad.title;
            document.getElementById('dtPrice').innerText = ad.price + ' DA';
            document.getElementById('dtDesc').innerText = ad.desc;
            document.getElementById('dtCity').innerText = ad.city;
            document.getElementById('dtCat').innerText = ad.category;
            
            // Fix Phone Button
            const pBtn = document.getElementById('dtPhoneBtn');
            if(currentUser) {
                pBtn.href = `tel:${ad.phone}`;
                pBtn.onclick = null;
            } else {
                pBtn.href = "#";
                pBtn.onclick = () => { closeModal('detailsModal'); openModal('loginModal'); };
            }

            openModal('detailsModal');
        };

        // --- Chat System (Fixed) ---
        
        // 1. Start Chat from Details
        window.startChatFromDetails = async () => {
            if(!currentUser) { closeModal('detailsModal'); openModal('loginModal'); return; }
            if(currentAd.uid === currentUser.uid) { alert("هذا إعلانك!"); return; }

            // Check for existing chat
            const q = query(collection(db, "chats"), 
                where("adId", "==", currentAd.id),
                where("participants", "array-contains", currentUser.uid)
            );
            const snap = await getDocs(q);

            if(!snap.empty) {
                activeChatId = snap.docs[0].id;
            } else {
                // Create New
                const ref = await addDoc(collection(db, "chats"), {
                    participants: [currentUser.uid, currentAd.uid],
                    adId: currentAd.id,
                    adTitle: currentAd.title,
                    lastMessage: "بدء المحادثة...",
                    lastUpdated: serverTimestamp()
                });
                activeChatId = ref.id;
            }
            
            closeModal('detailsModal');
            openChatModal(true); // Open directly to conversation
        };

        // 2. Open Inbox
        window.openInbox = () => {
            if(!currentUser) { openModal('loginModal'); return; }
            openChatModal(false);
        };

        // 3. Main Modal Logic
        function openChatModal(showConversation) {
            document.getElementById('chatModal').classList.add('active');
            if(showConversation) {
                loadConversationView();
            } else {
                showInboxView();
            }
        }

        // 4. Show Inbox
        window.showInboxView = () => {
            document.getElementById('inboxView').classList.remove('hidden');
            document.getElementById('conversationView').classList.add('hidden');
            document.getElementById('chatBackBtn').classList.add('hidden');
            document.getElementById('chatHeaderTitle').innerText = "الرسائل";
            
            // Listen to chats
            const q = query(collection(db, "chats"), where("participants", "array-contains", currentUser.uid), orderBy("lastUpdated", "desc"));
            onSnapshot(q, (snap) => {
                const list = document.getElementById('inboxView');
                list.innerHTML = '';
                if(snap.empty) { list.innerHTML = '<p class="text-center text-gray-400 mt-10">لا توجد رسائل</p>'; return; }
                
                snap.forEach(d => {
                    const chat = d.data();
                    list.innerHTML += `
                        <div onclick="activeChatId='${d.id}'; loadConversationView('${chat.adTitle}')" class="bg-white p-3 rounded-xl mb-2 shadow-sm flex items-center justify-between cursor-pointer hover:bg-gray-50 border border-gray-100">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-brand-light rounded-full flex items-center justify-center text-brand-dark font-bold"><i class="fas fa-user"></i></div>
                                <div>
                                    <h4 class="font-bold text-sm text-gray-800">${chat.adTitle}</h4>
                                    <p class="text-xs text-gray-500 truncate w-40">${chat.lastMessage}</p>
                                </div>
                            </div>
                            <i class="fas fa-chevron-left text-gray-300 text-xs"></i>
                        </div>`;
                });
            });
        };

        // 5. Load Conversation
        window.loadConversationView = (title) => {
            document.getElementById('inboxView').classList.add('hidden');
            document.getElementById('conversationView').classList.remove('hidden');
            document.getElementById('chatBackBtn').classList.remove('hidden');
            if(title) document.getElementById('chatHeaderTitle').innerText = title;

            if(messagesUnsubscribe) messagesUnsubscribe();

            const q = query(collection(db, `chats/${activeChatId}/messages`), orderBy("createdAt", "asc"));
            messagesUnsubscribe = onSnapshot(q, (snap) => {
                const container = document.getElementById('messagesContainer');
                container.innerHTML = '';
                snap.forEach(d => {
                    const msg = d.data();
                    const isMe = msg.senderId === currentUser.uid;
                    container.innerHTML += `<div class="chat-bubble ${isMe ? 'chat-me' : 'chat-other'} shadow-sm">${msg.text}</div>`;
                });
                container.scrollTop = container.scrollHeight;
            });
        };

        // 6. Send Message
        window.sendMessage = async () => {
            const input = document.getElementById('msgInput');
            const txt = input.value.trim();
            if(!txt || !activeChatId) return;

            await addDoc(collection(db, `chats/${activeChatId}/messages`), {
                text: txt, senderId: currentUser.uid, createdAt: serverTimestamp()
            });
            await updateDoc(doc(db, "chats", activeChatId), {
                lastMessage: txt, lastUpdated: serverTimestamp()
            });
            input.value = '';
        };

        // --- Auth & Admin ---
        window.handleLogin = async (e) => {
            e.preventDefault();
            let email = document.getElementById('logEmail').value.trim();
            const pass = document.getElementById('logPass').value;
            if(email.toLowerCase() === 'admin') email = 'admin@elaffroun.online';

            try {
                await signInWithEmailAndPassword(auth, email, pass);
                closeModal('loginModal');
            } catch (err) {
                // Auto create admin for demo
                if(err.code === 'auth/user-not-found' && email === 'admin@elaffroun.online') {
                    try { await createUserWithEmailAndPassword(auth, email, pass); closeModal('loginModal'); }
                    catch { document.getElementById('logError').classList.remove('hidden'); }
                } else { document.getElementById('logError').classList.remove('hidden'); }
            }
        };

        onAuthStateChanged(auth, (user) => {
            currentUser = user;
            if(user) {
                document.getElementById('authBtn').classList.add('hidden');
                document.getElementById('userAvatar').classList.remove('hidden');
                isAdmin = (user.email === 'admin@elaffroun.online');
                if(isAdmin) document.getElementById('adminBtn').classList.remove('hidden');
                
                // Badge Logic
                const q = query(collection(db, "chats"), where("participants", "array-contains", user.uid));
                onSnapshot(q, (snap) => { if(!snap.empty) document.getElementById('msgBadge').classList.remove('hidden'); });
            } else {
                document.getElementById('authBtn').classList.remove('hidden');
                document.getElementById('userAvatar').classList.add('hidden');
                document.getElementById('adminBtn').classList.add('hidden');
            }
        });

        window.logout = () => signOut(auth);

        // --- Helpers ---
        window.openModal = (id) => document.getElementById(id).classList.add('active');
        window.closeModal = (id) => document.getElementById(id).classList.remove('active');
        window.previewImage = (i) => { const e=document.getElementById('imgPreview'); e.src=URL.createObjectURL(i.files[0]); e.classList.remove('hidden'); };
        window.checkAuthAndOpenAddAd = () => currentUser ? openModal('addAdModal') : openModal('loginModal');
        window.deleteAd = async (id) => { if(confirm("حذف؟")) await deleteDoc(doc(db, "ads", id)); getAds(); };
        window.applyFilter = () => {
            const k = document.getElementById('searchKeyword').value.toLowerCase();
            const c = document.getElementById('filterCat').value;
            const city = document.getElementById('filterCity').value;
            const res = allAds.filter(a => (a.title.toLowerCase().includes(k)||a.category.includes(k)) && (!c||a.category===c) && (!city||a.city===city));
            renderAds(res); closeModal('searchModal');
        };

        // Banner
        window.loadBanners = async () => {
            const c = document.getElementById('bannerSlider');
            const s = await getDocs(collection(db, "admin_ads"));
            c.innerHTML = '';
            s.forEach(d => c.innerHTML += `<div class="banner-slide absolute inset-0 bg-cover bg-center transition-opacity duration-1000 opacity-0" style="background-image: url('${d.data().imageUrl}')"></div>`);
            if(c.children.length > 0) c.children[0].classList.remove('opacity-0');
        };

        function setupBannerRotator() {
            setInterval(() => {
                const slides = document.querySelectorAll('.banner-slide');
                if(slides.length < 2) return;
                let activeIndex = -1;
                slides.forEach((s, i) => { if(!s.classList.contains('opacity-0')) activeIndex = i; s.classList.add('opacity-0'); });
                const nextIndex = (activeIndex + 1) % slides.length;
                slides[nextIndex].classList.remove('opacity-0');
            }, 3000);
        }

        window.uploadBanner = async () => {
            const f = document.getElementById('bannerFile').files[0];
            const url = await getDownloadURL((await uploadBytes(ref(storage, `banners/${Date.now()}`), f)).ref);
            await addDoc(collection(db, "admin_ads"), { imageUrl: url });
            closeModal('adminModal'); loadBanners();
        };

    </script>
</body>
</html>

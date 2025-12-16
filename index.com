<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>New Year Cosmetics Catch</title>
    <style>
        :root {
            --bg1: #071a3a;
            --bg2: #0b3d91;
            --ice: #eaf6ff;
            --stroke: rgba(255, 255, 255, .22);
        }

        * {
            box-sizing: border-box;
        }

        html,
        body {
            margin: 0;
            height: 100%;
            font-family: system-ui, -apple-system, Segoe UI, Roboto;
            color: var(--ice);
        }

        body {
            background: linear-gradient(180deg, var(--bg1), var(--bg2));
            overflow: hidden;
        }

        /* ❄️ Snow */
        .snow {
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 1;
        }

        .flake {
            position: absolute;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: white;
            opacity: .7;
            animation: fall linear infinite
        }

        @keyframes fall {
            to {
                transform: translateY(120vh)
            }
        }

        /* Layout */
        .app {
            position: relative;
            height: 100%;
            padding: 14px;
            z-index: 2;
            display: flex;
            flex-direction: column;
            gap: 12px;
            overflow-y: auto;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px;
            border-radius: 18px;
            border: 1px solid var(--stroke);
            background: rgba(255, 255, 255, .12);
        }

        .title h1 {
            margin: 0;
            font-size: 16px;
        }

        .title p {
            margin: 0;
            font-size: 12px;
            opacity: .8;
        }

        .ghostbtn {
            display: none;
            padding: 8px 12px;
            border-radius: 999px;
            border: 1px solid var(--stroke);
            background: rgba(255, 255, 255, .1);
            color: #fff;
        }

        .ghostbtn.show {
            display: block;
        }

        .pill {
            padding: 8px 12px;
            border-radius: 999px;
            border: 1px solid var(--stroke);
            font-size: 12px;
        }

        /* Tabs */
        .tabs {
            flex: 1;
            min-height: 0;
            overflow-y: auto;
        }

        .tab {
            display: none;
            height: 100%;
        }

        .tab.active {
            display: flex;
            flex-direction: column;
        }

        /* 🧴 Brands */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 16px;
            overflow-y: auto;
            padding-bottom: 20px;
        }

        .brand-card {
            border-radius: 22px;
            border: 1px solid var(--stroke);
            background: rgba(255, 255, 255, .14);
            overflow: hidden;
            cursor: pointer;
        }

        .thumb {
            aspect-ratio: 1/1;
            overflow: hidden;
        }

        .thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .brand-meta {
            text-align: center;
            padding: 12px;
        }

        .name {
            margin: 0;
            font-weight: 900;
        }

        .hint {
            margin: 4px 0 0;
            font-size: 12px;
            opacity: .8;
        }

        /* 🎮 Game */
        .stage {
            position: relative;
            flex: 1;
            border-radius: 22px;
            border: 1px solid var(--stroke);
            background: rgba(255, 255, 255, .08);
            overflow: hidden;
        }

        .basket {
            position: absolute;
            bottom: 16px;
            left: 50%;
            transform: translateX(-50%);
            width: 160px;
            height: 64px;
            border-radius: 20px;
            background: rgba(255, 255, 255, .22);
            border: 1px solid var(--stroke);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .item {
            position: absolute;
            width: 90px;
            height: 90px;
            border-radius: 18px;
            background: rgba(255, 255, 255, .15); /* Легко прозорий фон */
            border: 1px solid rgba(255, 255, 255, .4); /* Тонкий бордер для кращого вигляду */
            box-shadow: 0 4px 10px rgba(255, 255, 255, 0.3); /* Легка тінь для ефекту піднесеності */
        }

        .item img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            border-radius: 18px; /* Округлені кути */
        }

        /* Overlay */
        .overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, .7);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 50;
        }

        .overlay.show {
            display: flex;
        }

        .bigbtn {
            padding: 20px 28px;
            font-size: 20px;
            font-weight: 900;
            border: none;
            border-radius: 22px;
            background: linear-gradient(180deg, #eaf6ff, #66c7ff);
        }

        /* ✅ Success */
        .success {
            position: fixed;
            inset: 0;
            background: rgba(7, 26, 58, .96);
            display: none;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            z-index: 60;
        }

        .success.show {
            display: flex;
        }

        .check {
            font-size: 96px;
        }
    </style>
</head>

<body>
    <div class="snow" id="snow"></div>
    <div class="app">
        <header>
            <div class="title">
                <h1>🎄 New Year Cosmetics 🎄</h1>
            </div>
            <button class="ghostbtn" id="backBtn">⬅️</button> <!-- Залишили тільки стрілку -->
            <div class="pill" id="pill">Pick a box</div> <!-- Замінили "Pick a brand" на "Pick a box" -->
        </header>

        <div class="tabs">
            <section class="tab active" id="tabBrands">
                <div class="grid" id="brands">
                    <!-- Maybelline -->
                    <div class="brand-card" data-brand="Maybelline">
                        <div class="thumb">
                            <img src="https://i.pinimg.com/1200x/7d/0f/88/7d0f881fed7961cf6fcecb66e2845271.jpg" alt="Maybelline Cosmetics">
                        </div>
                        <div class="brand-meta">
                            <p class="name">Cosmetics Box</p>
                            <p class="hint">Next</p> <!-- Замінили "Tap to start" на "Next" -->
                        </div>
                    </div>

                    <!-- Louis Vuitton -->
                    <div class="brand-card" data-brand="Louis Vuitton">
                        <div class="thumb">
                            <img src="https://i.pinimg.com/736x/c7/6f/0a/c76f0a837a90487268355410123cee76.jpg" alt="Louis Vuitton Cosmetics Box">
                        </div>
                        <div class="brand-meta">
                            <p class="name">Louis Vuitton Cosmetics Box</p> <!-- Переклали "Луї Вітон" на англійську -->
                            <p class="hint">Next</p> <!-- Замінили "Tap to start" на "Next" -->
                        </div>
                    </div>

                    <!-- Dior -->
                    <div class="brand-card" data-brand="Dior">
                        <div class="thumb">
                            <img src="https://i.pinimg.com/1200x/2b/b4/3f/2bb43f61e035547b114e81f508f36dc1.jpg" alt="Dior Cosmetics Box">
                        </div>
                        <div class="brand-meta">
                            <p class="name">Dior Cosmetics Box</p> <!-- Переклали "Діор" на англійську -->
                            <p class="hint">Next</p> <!-- Замінили "Tap to start" на "Next" -->
                        </div>
                    </div>

                    <!-- Cosmetics Box 2 -->
                    <div class="brand-card" data-brand="Cosmetics Box 2">
                        <div class="thumb">
                            <img src="https://i.pinimg.com/1200x/97/8a/b9/978ab9a5aaad877fb4a919bc4357237d.jpg" alt="Cosmetics Box 2">
                        </div>
                        <div class="brand-meta">
                            <p class="name">Cosmetics Box 2</p>
                            <p class="hint">Next</p> <!-- Замінили "Tap to start" на "Next" -->
                        </div>
                    </div>
                </div>
            </section>

            <section class="tab" id="tabGame">
                <div class="stage" id="stage">
                    <div class="basket" id="basket">🧺</div>
                </div>
            </section>
        </div>
    </div>

    <div class="overlay" id="overlay">
        <button class="bigbtn" id="insightsBtn">Get insights</button>
    </div>

    <div class="success" id="success">
        <div class="check">✅</div>
        <h2>Success!</h2>
    </div>

    <script>
        /* ❄️ Snow */
        const snow = document.getElementById('snow');
        for (let i = 0; i < 30; i++) {
            const f = document.createElement('div');
            f.className = 'flake';
            f.style.left = Math.random() * 100 + 'vw';
            f.style.animationDuration = 5 + Math.random() * 7 + 's';
            snow.appendChild(f);
        }

        /* Tabs */
        const tabBrands = document.getElementById('tabBrands');
        const tabGame = document.getElementById('tabGame');
        const backBtn = document.getElementById('backBtn');
        const overlay = document.getElementById('overlay');
        const success = document.getElementById('success');
        const pill = document.getElementById('pill');

        function goGame(brand) {
            pill.textContent = '🎄 New Year Cosmetics 🎄'; // Під час гри тільки цей текст
            tabBrands.classList.remove('active');
            tabGame.classList.add('active');
            backBtn.classList.add('show');
            startGame();
        }

        backBtn.onclick = () => {
            pill.textContent = ''; // Під час гри не відображати підпис
            tabGame.classList.remove('active');
            tabBrands.classList.add('active');
            backBtn.classList.remove('show');
        }

        /* 🎮 Game */
        const stage = document.getElementById('stage');
        const basket = document.getElementById('basket');

        let caught = 0;
        let items = [];
        let basketX = 0;

        const imgs = [
            "https://i.pinimg.com/736x/ea/a0/7c/eaa07cc9a05ca64e1205dce42d72323b.jpg",
            "https://i.pinimg.com/736x/c2/9c/64/c29c64b678fde7c35196395e37604728.jpg",
            "https://i.pinimg.com/736x/aa/4f/fc/aa4ffc11967486ed636af3a85633167e.jpg",
            "https://i.pinimg.com/736x/69/a2/9a/69a29ae8053fcebe4b6ae610675cc42e.jpg",
            "https://i.pinimg.com/736x/7e/01/4a/7e014a0392118b6322f24e3309c209a5.jpg"
        ];

        function startGame() {
            caught = 0;
            items.forEach(i => i.el.remove());
            items = [];
            overlay.classList.remove('show');
            success.classList.remove('show');
            setInterval(spawnItem, 1200);
        }

        function spawnItem() {
            if (caught >= 5) return;
            const el = document.createElement('div');
            el.className = 'item';
            el.style.background = 'transparent'; // прозорий фон
            const img = document.createElement('img');
            img.src = imgs[Math.random() * imgs.length | 0];
            img.style.borderRadius = "18px"; // додаємо округлість
            img.style.objectFit = "contain"; // обов'язково для правильного масштабу
            img.style.width = '100%'; // повний розмір елементу
            img.style.height = '100%';
            el.appendChild(img);

            // Створення сніжинок для кожного предмету
            const snowflake = document.createElement('div');
            snowflake.className = 'flake';
            snowflake.style.animationDuration = (5 + Math.random() * 7) + 's';
            snowflake.style.left = Math.random() * 100 + 'vw';
            snowflake.style.animationTimingFunction = 'ease-in-out';
            el.appendChild(snowflake);

            stage.appendChild(el);

            items.push({
                el,
                x: Math.random() * (stage.clientWidth - 90),
                y: -100
            });
        }

        function loop() {
            items.forEach((it, i) => {
                it.y += 2.5;
                it.el.style.transform = `translate(${it.x}px,${it.y}px)`;

                const a = it.el.getBoundingClientRect();
                const b = basket.getBoundingClientRect();

                if (!(a.right < b.left || a.left > b.right || a.bottom < b.top || a.top > b.bottom)) {
                    it.el.remove();
                    items.splice(i, 1);
                    caught++;
                    if (caught >= 5) overlay.classList.add('show');
                }
            });
            requestAnimationFrame(loop);
        }
        loop();

        /* Controls */
        stage.addEventListener('mousemove', e => {
            basketX = e.clientX - stage.getBoundingClientRect().left - 80;
            basket.style.left = basketX + 'px';
        });

        stage.addEventListener('touchmove', e => {
            basketX = e.touches[0].clientX - stage.getBoundingClientRect().left - 80;
            basket.style.left = basketX + 'px';
        });

        /* Brand click */
        document.getElementById('brands').onclick = e => {
            const card = e.target.closest('.brand-card');
            if (card) goGame(card.dataset.brand);
        };

        document.getElementById('insightsBtn').onclick = () => {
            overlay.classList.remove('show');
            success.classList.add('show');
        };
    </script>
</body>

</html>

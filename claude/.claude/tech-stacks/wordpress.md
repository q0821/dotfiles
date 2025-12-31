# WordPress 開發指導

## WordPress 核心原則

### 基本規範

- **遵循 WordPress Coding Standards**
- **Child Theme > 直接修改主題** - 永遠使用子主題
- **Plugin > functions.php** - 功能性代碼優先做成外掛
- **Hook System** - 使用 actions 和 filters，不要直接修改核心

### 開發環境流程

```
本地開發 → Staging 測試 → Production 上線
```

- 本地環境測試完成才推到 staging
- Staging 客戶驗收通過才上 production
- 保持三個環境的資料庫結構同步

## 專案結構

### Child Theme 結構

```
wp-content/themes/parent-theme-child/
├── style.css           # 必要，定義主題資訊
├── functions.php       # 主要功能入口
├── assets/
│   ├── css/
│   ├── js/
│   └── images/
├── template-parts/     # 可重用的模板片段
├── inc/                # 功能模組化
│   ├── customizer.php
│   ├── custom-post-types.php
│   └── enqueue-scripts.php
└── languages/          # 多語言檔案
```

### Custom Plugin 結構

```
wp-content/plugins/custom-plugin/
├── custom-plugin.php   # 主檔案
├── includes/           # 核心功能
├── admin/              # 後台介面
├── public/             # 前台功能
└── languages/
```

## 常見開發模式

### 1. 註冊 Custom Post Type

```php
// inc/custom-post-types.php
function register_project_post_type() {
    $args = array(
        'public' => true,
        'label'  => '專案',
        'supports' => array('title', 'editor', 'thumbnail'),
        'has_archive' => true,
        'rewrite' => array('slug' => 'projects'),
    );
    register_post_type('project', $args);
}
add_action('init', 'register_project_post_type');
```

### 2. 安全地載入 Scripts/Styles

```php
// inc/enqueue-scripts.php
function theme_enqueue_scripts() {
    // CSS
    wp_enqueue_style(
        'theme-style',
        get_stylesheet_directory_uri() . '/assets/css/main.css',
        array(),
        filemtime(get_stylesheet_directory() . '/assets/css/main.css')
    );
    
    // JS
    wp_enqueue_script(
        'theme-script',
        get_stylesheet_directory_uri() . '/assets/js/main.js',
        array('jquery'),
        filemtime(get_stylesheet_directory() . '/assets/js/main.js'),
        true
    );
}
add_action('wp_enqueue_scripts', 'theme_enqueue_scripts');
```

### 3. 使用 Hooks 而非修改檔案

```php
// ❌ 不好：直接修改 WooCommerce 模板
// ✅ 好：使用 filter
function custom_woocommerce_price($price, $product) {
    // 自訂價格顯示邏輯
    return $price;
}
add_filter('woocommerce_get_price_html', 'custom_woocommerce_price', 10, 2);
```

## 效能優化

### 資料庫查詢

```php
// ❌ 避免在迴圈中查詢
foreach ($posts as $post) {
    $meta = get_post_meta($post->ID, 'key', true); // 每次都查詢
}

// ✅ 使用 WP_Query 預先載入
$query = new WP_Query(array(
    'post_type' => 'post',
    'meta_key' => 'key',  // 一次載入所有 meta
));
```

### 快取策略

```php
// 使用 Transients API
function get_expensive_data() {
    $cache_key = 'expensive_data';
    $data = get_transient($cache_key);
    
    if (false === $data) {
        // 執行耗時操作
        $data = expensive_operation();
        set_transient($cache_key, $data, HOUR_IN_SECONDS);
    }
    
    return $data;
}
```

## 安全性檢查清單

### 輸入驗證與輸出轉義

```php
// 輸入驗證
$user_input = sanitize_text_field($_POST['field']);
$email = sanitize_email($_POST['email']);
$url = esc_url_raw($_POST['url']);

// 輸出轉義
echo esc_html($user_input);
echo esc_attr($attribute);
echo esc_url($url);
```

### Nonce 驗證

```php
// 表單中加入 nonce
wp_nonce_field('my_action', 'my_nonce');

// 處理時驗證
if (!wp_verify_nonce($_POST['my_nonce'], 'my_action')) {
    wp_die('Security check failed');
}
```

### 權限檢查

```php
if (!current_user_can('edit_posts')) {
    wp_die('You do not have permission');
}
```

## 多語言處理

### WPML 專案

```php
// 取得當前語言
$current_lang = apply_filters('wpml_current_language', NULL);

// 取得翻譯後的文章 ID
$translated_id = apply_filters(
    'wpml_object_id',
    $post_id,
    'post',
    true,
    $target_lang
);
```

### Polylang 專案

```php
// 取得當前語言
$current_lang = pll_current_language();

// 取得翻譯
$translated_id = pll_get_post($post_id, $target_lang);
```

## 除錯技巧

### 開啟除錯模式

```php
// wp-config.php
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);      // 寫入 wp-content/debug.log
define('WP_DEBUG_DISPLAY', false); // 前台不顯示錯誤
define('SCRIPT_DEBUG', true);      // 使用未壓縮的 JS/CSS
```

### 使用 Query Monitor

- 安裝 Query Monitor 外掛
- 檢查慢查詢
- 追蹤 hook 執行順序
- 查看 HTTP 請求

## 常見問題與解法

### 1. 白屏（White Screen of Death）

**檢查步驟**：
1. 檢查 `wp-content/debug.log`
2. 停用所有外掛
3. 切換到預設主題
4. 檢查 PHP 錯誤日誌

### 2. 500 Internal Server Error

**可能原因**：
- `.htaccess` 損毀 → 重新儲存固定網址設定
- PHP 記憶體不足 → 增加 `WP_MEMORY_LIMIT`
- 外掛衝突 → 逐一停用測試

### 3. 圖片上傳失敗

**檢查**：
- 資料夾權限（uploads 應為 755）
- PHP upload_max_filesize
- PHP post_max_size
- 磁碟空間

## 客戶交付清單

### 上線前確認

- [ ] 刪除測試內容
- [ ] 檢查所有連結正常
- [ ] 測試表單送出
- [ ] 驗證聯絡資訊正確
- [ ] 設定 SEO meta（Yoast/Rank Math）
- [ ] 設定 Google Analytics
- [ ] 提交 Sitemap 到 Search Console
- [ ] SSL 憑證安裝並強制 HTTPS
- [ ] 設定自動備份
- [ ] 關閉除錯模式
- [ ] 變更預設管理員帳號
- [ ] 停用不需要的外掛

### 效能檢查

- [ ] 圖片已優化（WebP 格式）
- [ ] 啟用快取外掛（WP Rocket/W3 Total Cache）
- [ ] 設定 CDN（Cloudflare）
- [ ] 壓縮 CSS/JS
- [ ] Lazy loading 圖片
- [ ] GTmetrix/PageSpeed 分數 > 85

## 維護合約規範

### 定期維護項目

**每月**：
- 更新 WordPress 核心
- 更新外掛和主題
- 檢查備份正常
- 安全性掃描

**每季**：
- 資料庫優化
- 清理垃圾留言
- 檢查斷鏈
- 效能測試

### 緊急支援 SLA

- P1（網站無法訪問）：2 小時內回應
- P2（功能異常）：4 小時內回應
- P3（小問題）：24 小時內回應

## 工具推薦

### 必備外掛

- **安全性**：Wordfence / iThemes Security
- **備份**：UpdraftPlus / BackWPup
- **快取**：WP Rocket / W3 Total Cache
- **SEO**：Yoast SEO / Rank Math
- **表單**：Contact Form 7 / Gravity Forms

### 開發工具

- **本地環境**：Local by Flywheel / MAMP
- **除錯**：Query Monitor
- **代碼品質**：PHP_CodeSniffer（WordPress Coding Standards）
- **部署**：WP-CLI / Git

---

## 參考資源

- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [Theme Handbook](https://developer.wordpress.org/themes/)
- [Plugin Handbook](https://developer.wordpress.org/plugins/)

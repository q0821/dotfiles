# 網站安全性指導

## Content Security Policy (CSP)

### CSP 實作流程

#### 階段 1：評估與規劃

**檢查現有資源**：
```bash
# 使用瀏覽器開發者工具
# 1. 開啟 Console
# 2. 檢查是否有載入外部資源
# 3. 列出所有網域
```

**常見資源來源**：
- Google Fonts
- Google Analytics / Tag Manager
- Facebook Pixel
- CDN（jQuery, Bootstrap）
- 支付閘道（綠界、藍新）
- 第三方 Widget

#### 階段 2：建立初始 CSP

**保守的起始設定**（適合大部分 WordPress 網站）：

```apache
# .htaccess
<IfModule mod_headers.c>
Header set Content-Security-Policy "\
    default-src 'self'; \
    script-src 'self' 'unsafe-inline' 'unsafe-eval' \
        https://www.googletagmanager.com \
        https://www.google-analytics.com; \
    style-src 'self' 'unsafe-inline' \
        https://fonts.googleapis.com; \
    font-src 'self' \
        https://fonts.gstatic.com; \
    img-src 'self' data: https:; \
    connect-src 'self' \
        https://www.google-analytics.com; \
    frame-src 'self' \
        https://www.youtube.com \
        https://www.facebook.com; \
    object-src 'none'; \
    base-uri 'self'; \
    form-action 'self'"
</IfModule>
```

#### 階段 3：逐步移除 unsafe-inline

**目標**：達到 A+ 評級

**步驟**：
1. 辨識所有 inline scripts/styles
2. 將 inline code 移到外部檔案
3. 使用 nonce 或 hash（必要時）
4. 測試並移除 'unsafe-inline'

**使用 Nonce 範例**（WordPress）：

```php
// functions.php
function add_csp_nonce() {
    $nonce = base64_encode(random_bytes(16));
    
    // 設定 CSP header with nonce
    header("Content-Security-Policy: script-src 'self' 'nonce-{$nonce}'");
    
    // 將 nonce 存起來供後續使用
    define('CSP_NONCE', $nonce);
}
add_action('send_headers', 'add_csp_nonce');

// 在 script tag 使用
function enqueue_script_with_nonce() {
    wp_enqueue_script('my-script', get_template_directory_uri() . '/js/script.js');
}

// 在輸出時加入 nonce
function add_nonce_to_scripts($tag, $handle) {
    if (defined('CSP_NONCE')) {
        $tag = str_replace('<script', '<script nonce="' . CSP_NONCE . '"', $tag);
    }
    return $tag;
}
add_filter('script_loader_tag', 'add_nonce_to_scripts', 10, 2);
```

### CSP 常見問題排除

#### 問題 1：Google Fonts 載入失敗

**症狀**：字型未顯示，Console 有 CSP 錯誤

**解法**：
```apache
style-src 'self' https://fonts.googleapis.com;
font-src 'self' https://fonts.gstatic.com;
```

#### 問題 2：Google Tag Manager 無法運作

**症狀**：GA 沒有資料，GTM 錯誤

**解法**：
```apache
script-src 'self' 'unsafe-inline' 
    https://www.googletagmanager.com 
    https://www.google-analytics.com 
    https://ssl.google-analytics.com;
connect-src 'self' 
    https://www.google-analytics.com;
img-src 'self' data: 
    https://www.google-analytics.com 
    https://www.googletagmanager.com;
```

**注意**：GTM 很難完全移除 'unsafe-inline'，可接受此妥協

#### 問題 3：Facebook Pixel 被阻擋

**症狀**：FB 事件未追蹤

**解法**：
```apache
script-src 'self' https://connect.facebook.net;
img-src 'self' data: https://www.facebook.com;
connect-src 'self' https://www.facebook.com;
```

#### 問題 4：YouTube 嵌入影片無法顯示

**解法**：
```apache
frame-src 'self' https://www.youtube.com https://www.youtube-nocookie.com;
```

### CSP 測試工具

**線上測試**：
- [SecurityHeaders.com](https://securityheaders.com/) - 評級檢測
- [CSP Evaluator](https://csp-evaluator.withgoogle.com/) - Google 官方工具

**瀏覽器開發者工具**：
- Chrome DevTools > Console > 查看 CSP 違規
- Network > 檢查被阻擋的請求

## Web Application Firewall (WAF)

### Cloudflare WAF 設定

#### 基本防護規則

**1. 阻擋已知惡意機器人**：
```
Rule: Challenge
When: Known Bots
Action: Managed Challenge
```

**2. 限制 wp-admin 存取**：
```
Field: URI Path
Operator: contains
Value: /wp-admin
AND
Field: IP Address
Operator: is not in
Value: [您的辦公室 IP]
Action: Block
```

**3. 阻擋特定 User-Agent**：
```
Field: User Agent
Operator: contains
Value: "BadBot"
Action: Block
```

#### 進階規則範例

**阻擋 SQL Injection 嘗試**：
```
Field: URI Query String
Operator: contains
Value: "union select"
OR Value: "' or '1'='1"
Action: Block
```

**限制 POST 請求速率**：
```
Field: HTTP Method
Operator: equals
Value: POST
AND
Rate Limiting: 10 requests per minute
Action: Challenge
```

### WordPress 特定 WAF 外掛

**Wordfence**：

**推薦設定**：
- ✅ 啟用防火牆（Extended Protection）
- ✅ 啟用 Brute Force Protection
- ✅ 阻擋假的 Google Crawlers
- ✅ 限制登入嘗試（3 次失敗鎖定 20 分鐘）
- ✅ 啟用 2FA（雙因素認證）

**效能優化**：
- 排除已知的信任 IP
- 排除特定 User-Agent（如監控工具）

## SSL/TLS 設定

### 強制 HTTPS

**WordPress wp-config.php**：
```php
define('FORCE_SSL_ADMIN', true);

// 如果網站在 proxy 後面
if ($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
    $_SERVER['HTTPS'] = 'on';
}
```

**.htaccess 重新導向**：
```apache
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</IfModule>
```

### SSL Labs 檢測

**目標**：A+ 評級

**必要設定**：
- TLS 1.2+ （停用 TLS 1.0/1.1）
- 強加密套件
- HSTS（HTTP Strict Transport Security）

**Cloudflare SSL/TLS 設定**：
```
Mode: Full (Strict)
Always Use HTTPS: On
Minimum TLS Version: 1.2
TLS 1.3: Enabled
HSTS: Enabled
  - Max Age: 6 months
  - Include Subdomains: Yes
  - Preload: Yes
```

## 登入安全性

### 強化 WordPress 登入

**1. 變更登入網址**（使用外掛或手動）：
```
預設：yoursite.com/wp-admin
改為：yoursite.com/secret-login
```

**外掛建議**：WPS Hide Login

**2. 限制登入嘗試**：

使用 Limit Login Attempts Reloaded：
- 最多失敗次數：3 次
- 鎖定時間：20 分鐘
- 白名單 IP：您的辦公室 IP

**3. 雙因素認證（2FA）**：

使用 Two Factor Authentication 外掛：
- 管理員帳號強制啟用
- 支援 Google Authenticator
- 備用碼保存

**4. 強密碼政策**：
```php
// functions.php
function enforce_strong_password($errors, $user_login, $user_email) {
    if (isset($_POST['pass1']) && strlen($_POST['pass1']) < 12) {
        $errors->add('password_length', '密碼至少需要 12 個字元');
    }
    return $errors;
}
add_action('user_profile_update_errors', 'enforce_strong_password', 10, 3);
```

## 資料庫安全

### 變更資料庫前綴

**預設**：`wp_`
**建議改為**：隨機字串，例如 `xj7k_`

**安裝時設定**（wp-config.php）：
```php
$table_prefix = 'xj7k_';
```

**已存在的網站變更**：
1. 備份資料庫
2. 使用外掛：Change Table Prefix
3. 或手動執行 SQL（風險較高）

### 定期資料庫優化

```sql
-- 清理修訂版本（保留最近 5 個）
DELETE FROM wp_posts 
WHERE post_type = 'revision' 
AND post_modified < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- 清理垃圾留言
DELETE FROM wp_comments WHERE comment_approved = 'spam';

-- 清理暫存資料
DELETE FROM wp_options WHERE option_name LIKE '_transient_%';

-- 優化資料表
OPTIMIZE TABLE wp_posts, wp_postmeta, wp_comments;
```

**注意**：使用 WP-Optimize 外掛更安全

## 檔案與目錄權限

### 正確權限設定

```bash
# 資料夾
find /path/to/wordpress -type d -exec chmod 755 {} \;

# 檔案
find /path/to/wordpress -type f -exec chmod 644 {} \;

# wp-config.php（特別保護）
chmod 440 wp-config.php
chown www-data:www-data wp-config.php
```

### wp-config.php 安全加固

```php
// 停用檔案編輯
define('DISALLOW_FILE_EDIT', true);

// 停用自動更新（手動控制）
define('AUTOMATIC_UPDATER_DISABLED', true);

// 限制修訂版本數量
define('WP_POST_REVISIONS', 5);

// 設定安全金鑰（必須是唯一隨機值）
// 產生網址：https://api.wordpress.org/secret-key/1.1/salt/
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
// ... 其他金鑰
```

### 保護重要檔案

**.htaccess 保護 wp-config.php**：
```apache
<files wp-config.php>
order allow,deny
deny from all
</files>
```

**阻擋目錄瀏覽**：
```apache
Options -Indexes
```

## 備份策略

### 自動備份設定

**推薦外掛**：UpdraftPlus

**備份頻率**：
- 資料庫：每日
- 檔案：每週
- 保留份數：30 天

**儲存位置**（至少 2 個）：
- 遠端雲端（Google Drive / Dropbox）
- 本地伺服器（不同磁碟）

### 手動備份腳本

```bash
#!/bin/bash
# WordPress 備份腳本

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"
WP_DIR="/var/www/html"
DB_NAME="wordpress_db"
DB_USER="db_user"
DB_PASS="db_password"

# 備份資料庫
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/db_$DATE.sql

# 備份檔案
tar -czf $BACKUP_DIR/files_$DATE.tar.gz $WP_DIR

# 刪除 30 天前的備份
find $BACKUP_DIR -type f -mtime +30 -delete

echo "Backup completed: $DATE"
```

## 安全性檢查清單

### 新站上線前（必做）

- [ ] SSL 憑證安裝並強制 HTTPS
- [ ] 變更預設管理員帳號（不使用 admin）
- [ ] 設定強密碼（12+ 字元）
- [ ] 安裝安全性外掛（Wordfence）
- [ ] 設定自動備份
- [ ] 變更資料庫前綴
- [ ] 停用檔案編輯（DISALLOW_FILE_EDIT）
- [ ] 限制登入嘗試
- [ ] 設定 WAF 規則（Cloudflare）
- [ ] 實作基本 CSP
- [ ] 移除不使用的外掛和主題
- [ ] 關閉 XML-RPC（如不需要）
- [ ] 停用目錄瀏覽
- [ ] 檔案權限設定正確

### 每月維護（定期）

- [ ] 更新 WordPress 核心
- [ ] 更新所有外掛和主題
- [ ] 檢查安全性掃描報告
- [ ] 檢視登入日誌（失敗嘗試）
- [ ] 檢查備份是否正常
- [ ] 測試備份還原（每季一次）
- [ ] 檢視 WAF 阻擋日誌
- [ ] 資料庫優化

### 安全事件處理

**網站被入侵時**：

1. **立即行動**：
   - 啟動維護模式
   - 變更所有密碼
   - 備份目前狀態（證據）

2. **清理**：
   - 掃描惡意檔案（Wordfence）
   - 檢查資料庫中的可疑內容
   - 還原到乾淨的備份

3. **加固**：
   - 更新所有軟體
   - 檢視存取日誌找出入侵點
   - 加強安全措施
   - 考慮變更主機

## 安全性評級目標

### SecurityHeaders.com

**目標**：A+

**必要 Headers**：
```apache
# .htaccess
<IfModule mod_headers.c>
    # CSP
    Header set Content-Security-Policy "..."
    
    # HSTS
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
    
    # X-Frame-Options
    Header always set X-Frame-Options "SAMEORIGIN"
    
    # X-Content-Type-Options
    Header always set X-Content-Type-Options "nosniff"
    
    # Referrer Policy
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    
    # Permissions Policy
    Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"
</IfModule>
```

### SSL Labs

**目標**：A+

**關鍵設定**：
- TLS 1.3 啟用
- HSTS preload
- 強加密套件
- 憑證鏈完整

---

## 參考資源

- [OWASP WordPress Security](https://owasp.org/www-project-wordpress-security/)
- [WordPress Hardening Guide](https://wordpress.org/support/article/hardening-wordpress/)
- [CSP Reference](https://content-security-policy.com/)
- [SecurityHeaders.com](https://securityheaders.com/)
- [SSL Labs](https://www.ssllabs.com/ssltest/)

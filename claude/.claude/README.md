# Claude Guidelines - 使用說明

這是 JackieYeh 的個人開發指導文件集，用於與 Claude 協作時提供專案相關的最佳實踐和標準。

## 📁 檔案結構

```
~/claude-guidelines/
├── README.md                        # 本檔案
├── claude.md                        # 核心開發原則（必讀）
├── tech-stacks/                     # 技術棧特定指導
│   └── wordpress.md                 # WordPress 開發規範
├── project-types/                   # 專案類型指導
│   └── client-projects.md           # 客戶專案管理流程
└── specialized/                     # 專業領域指導
    └── security.md                  # 安全性實作檢查清單
```

## 🚀 快速開始

### 基本使用方式

在與 Claude 對話開始時，告訴 Claude 讀取相關的指導檔案：

```
這是一個 WordPress 客戶專案，請讀取：
~/claude-guidelines/claude.md
~/claude-guidelines/tech-stacks/wordpress.md
~/claude-guidelines/project-types/client-projects.md
```

### 簡化方式

也可以簡短描述專案類型，讓 Claude 判斷要讀取哪些檔案：

```
「WordPress 客戶專案 + 安全性實作」
```

## 📖 檔案用途說明

### claude.md（核心原則）
**適用**：所有專案
**內容**：
- 漸進式開發方法
- 3 次嘗試規則
- 測試驅動開發
- IMPLEMENTATION_PLAN.md 方法
- 代碼品質標準

**何時讀取**：每次對話都建議讀取

---

### tech-stacks/wordpress.md（WordPress 開發）
**適用**：WordPress 專案
**內容**：
- WordPress Coding Standards
- Child Theme 和 Plugin 架構
- 常見開發模式（Custom Post Types, Hooks）
- 效能優化技巧
- 多語言處理（WPML, Polylang）
- 除錯技巧
- 客戶交付清單

**何時讀取**：
- 開發 WordPress 網站
- 修改 WordPress 主題/外掛
- WordPress 效能優化
- WordPress 問題排除

---

### project-types/client-projects.md（客戶專案管理）
**適用**：所有客戶委託專案
**內容**：
- 完整專案流程（需求 → 驗收 → 上線）
- 報價與合約範本
- 溝通技巧和 Email 範本
- 驗收清單
- 風險管理
- 困難客戶處理

**何時讀取**：
- 準備報價單
- 撰寫客戶溝通文件
- 專案進度管理
- 處理客戶需求變更

---

### specialized/security.md（安全性實作）
**適用**：需要安全性強化的專案
**內容**：
- CSP (Content Security Policy) 完整實作
- WAF (Web Application Firewall) 設定
- SSL/TLS 配置
- WordPress 登入安全
- 資料庫安全
- 備份策略
- 安全性評級目標（A+ 評級）

**何時讀取**：
- 實作 CSP 政策
- 設定 Cloudflare WAF
- 安全性檢測優化
- 處理安全性問題
- 新站上線前檢查

## 💡 使用場景範例

### 場景 1：新的 WordPress 客戶網站
```
讀取檔案：
- claude.md（核心原則）
- tech-stacks/wordpress.md
- project-types/client-projects.md

用途：從需求確認、報價、開發到交付的完整流程
```

### 場景 2：WordPress 網站 CSP 安全性優化
```
讀取檔案：
- claude.md（核心原則）
- tech-stacks/wordpress.md
- specialized/security.md

用途：實作 CSP 並達到 A+ 評級
```

### 場景 3：客戶提案文件撰寫
```
讀取檔案：
- project-types/client-projects.md

用途：使用報價範本和溝通技巧
```

### 場景 4：WordPress 外掛開發
```
讀取檔案：
- claude.md（核心原則）
- tech-stacks/wordpress.md

用途：遵循 WordPress 開發規範和測試標準
```

## 🔄 維護與更新

### 何時更新檔案？

**立即更新**：
- 發現更好的做法或模式
- 遇到新的問題和解決方案
- 學習到新技術或工具
- 專案流程改進

**定期檢視**：
- 每月檢視一次是否需要補充
- 每季檢視是否有過時內容

### 如何更新？

```bash
# 編輯相關檔案
vi ~/claude-guidelines/tech-stacks/wordpress.md

# 或使用你喜歡的編輯器
code ~/claude-guidelines/
```

## 📝 專案層級覆寫（進階）

對於有特殊需求的專案，可在專案目錄建立 `.claude/project.md`：

```
~/projects/special-client/
└── .claude/
    └── project.md       # 僅記錄此專案的特殊需求
```

**優先順序**：
```
專案層級 (.claude/project.md) > 家目錄 (~/claude-guidelines/)
```

**範例使用時機**：
- 政府標案特殊規範
- 客戶特定代碼風格
- 特殊技術限制

## 🎯 最佳實踐

### ✅ 建議做法

1. **每次對話開始時明確告知要讀取的檔案**
2. **遇到新問題時，事後補充到相關檔案**
3. **保持檔案簡潔實用，避免過度理論化**
4. **用實際範例說明，而非抽象概念**

### ❌ 避免做法

1. 不要讓檔案過於冗長（每個檔案控制在 300 行內）
2. 不要重複內容（例：安全性只在 security.md）
3. 不要寫太多「應該」，多寫「如何做」
4. 不要忘記更新（好的做法要記錄下來）

## 🚧 未來擴充計劃

待建立的檔案（視需要）：

```
tech-stacks/
  ├── joomla.md              # Joomla 開發（如果常做）
  └── frontend.md            # 純前端專案

project-types/
  └── government-contracts.md # 政府標案規範（如果常接）

specialized/
  ├── multilingual.md        # 多語言專案處理
  ├── documentation.md       # 文件撰寫規範
  └── performance.md         # 效能優化專門指導

communication/
  ├── client-communication.md # 客戶溝通深入版
  └── proposals.md           # 提案文件範本
```

## 📚 相關資源

- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [OWASP Security Guidelines](https://owasp.org/)
- [CSP Reference](https://content-security-policy.com/)

---

**版本**：1.0  
**最後更新**：2025-01-01  
**維護者**：JackieYeh

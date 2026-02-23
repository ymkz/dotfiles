# Frontend QA (フロントエンドQA)

**対象:** フロントエンドコードを変更する場合

## プロセス

実装したフロントエンドコードをブラウザで視覚的に検証します。

## ステップ

### 1. 開発サーバーの起動

```bash
npm run dev
```

### 2. Agent-BrowserでのQA

`agent-browser` skillを使用して自動化されたQAを実行：

```typescript
// ページに移動
await page.goto("http://localhost:3000/new-feature");

// スナップショット取得
const snapshot = await page.accessibility.snapshot();

// 視覚的要素の検証
await page.screenshot({ path: "qa/before.png" });

// インタラクション
await page.click("[data-testid='submit-button']");

// 結果の検証
await page.waitForSelector("[data-testid='success-message']");
await page.screenshot({ path: "qa/after.png" });
```

### 3. チェックリスト

- [ ] レスポンシブデザイン（モバイル、タブレット、デスクトップ）
- [ ] アクセシビリティ（ARIA属性、キーボードナビゲーション）
- [ ] ローディング状態
- [ ] エラーハンドリング
- [ ] エッジケース（空の状態、最大値など）

### 4. 回帰テスト

既存機能が壊れていないことを確認：
- 主要なユーザーフロー
- ナビゲーション
- フォーム送信

## ベネフィット

- 手動QAの時間を節約
- 視覚的回帰を検出しやすい
- CI/CDパイプラインに統合可能
- 一貫したQAプロセス

## 使用タイミング

すべてのフロントエンド変更：
- コンポーネント修正
- スタイル調整
- インタラクション追加

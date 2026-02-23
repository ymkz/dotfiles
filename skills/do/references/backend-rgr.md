# Backend RGR Approach (バックエンドRGRアプローチ)

**対象:** バックエンドの実装作業

## プロセス

Red-Green-Refactor（RGR）サイクルを使用して、バックエンドコードを開発します。

## ステップ

### 1. Red: 失敗するテストを書く

```typescript
// 例: ユーザー認証
test("should authenticate user with valid credentials", async () => {
  const result = await authenticateUser("user@example.com", "password");
  expect(result).toBeDefined();
  expect(result.token).toBeTruthy();
});
```

**この時点でテストは失敗することを確認**

### 2. Green: 最小限の実装でテストをパス

```typescript
async function authenticateUser(email: string, password: string) {
  // 最小限の実装 - テストをパスすることだけを目的
  if (email === "user@example.com" && password === "password") {
    return { token: "fake-token" };
  }
  throw new Error("Invalid credentials");
}
```

**テストがパスすることを確認**

### 3. Refactor: コードを改善

```typescript
async function authenticateUser(email: string, password: string) {
  const user = await db.users.findByEmail(email);
  if (!user) {
    throw new AuthenticationError("User not found");
  }

  const isValid = await bcrypt.compare(password, user.hashedPassword);
  if (!isValid) {
    throw new AuthenticationError("Invalid credentials");
  }

  return {
    token: generateJWT(user),
    user: sanitizeUser(user),
  };
}
```

**テストがまだパスしていることを確認**

## ベネフィット

- テスト可能なコードが自然と書ける
- 実装の範囲が明確（テストがガイドになる）
- リファクタリングが安全（テストが回帰を検知）
- 小さなサイクルで進捗を得られる

## 使用タイミング

APIエンドポイント、ビジネスロジックの実装：
- 認証システム
- データ処理パイプライン
- サービスレイヤーの実装

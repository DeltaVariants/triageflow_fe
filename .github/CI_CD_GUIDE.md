# CI/CD Setup Guide

## 📋 Overview

Dự án này được cấu hình với **GitHub Actions** cho CI/CD. Có 3 workflows chính:

### 1. **Build & Test** (`build-test.yml`)
- ✅ Chạy trên push và pull requests
- ✅ Test với Node.js 18.x và 20.x
- ✅ Cài đặt dependencies
- ✅ Chạy linter
- ✅ Build project
- ✅ Upload build artifacts

### 2. **Code Quality** (`code-quality.yml`)
- ✅ ESLint checking
- ✅ TypeScript type checking
- ✅ Build validation

### 3. **Deploy to Vercel** (`deploy-vercel.yml`)
- ✅ Auto deploy trên push đến main/master
- ✅ Preview deployments cho pull requests
- ✅ Production deployment

---

## 🚀 Cách Setup

### **Step 1: Tạo GitHub Secrets**

Đi tới **Settings → Secrets and variables → Actions** trong repository:

#### Cho Vercel deployment:
```
VERCEL_TOKEN         # Lấy từ Vercel account settings
VERCEL_ORG_ID        # Organization ID từ Vercel
VERCEL_PROJECT_ID    # Project ID từ Vercel
```

**Cách lấy Vercel credentials:**
1. Đi tới [Vercel Dashboard](https://vercel.com/dashboard)
2. Tạo account nếu chưa có
3. Import project từ GitHub
4. Lấy tokens từ **Settings → Tokens**

### **Step 2: Cấu hình Vercel (Optional)**

Tạo `vercel.json` trong root:

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "framework": "nextjs",
  "nodeVersion": "20.x"
}
```

---

## 📁 File Structure

```
.github/
├── workflows/
│   ├── build-test.yml      # Build & Test workflow
│   ├── code-quality.yml    # Code quality checks
│   └── deploy-vercel.yml   # Deploy to Vercel
```

---

## 🔍 Workflow Details

### **Build & Test Workflow**

Trigger:
- Push đến `main`, `master`, `develop`
- Pull requests đến branches này

Steps:
1. Checkout code
2. Setup Node.js
3. Install dependencies (`npm ci`)
4. Run linter
5. Build project
6. Upload artifacts

```yaml
Logs: Actions → Build & Test → [chọn run]
```

### **Code Quality Workflow**

Checks:
- ESLint
- TypeScript compilation
- Next.js build

### **Deploy Workflow**

- **Main branch** → Production deploy
- **PR** → Preview deployment

---

## 📊 Monitoring

### Xem CI/CD Status:
1. Vào **GitHub Repository → Actions**
2. Xem workflow runs
3. Click vào run để xem logs

### Branch Protection:
Để bắt buộc CI/CD pass trước merge:
1. **Settings → Branch protection rules**
2. Chọn branch (main/master)
3. Bật **Require status checks to pass**
4. Chọn workflows: `Build & Test`, `Code Quality`

---

## 💡 Tips & Best Practices

### 1. **Develop Workflow**
```bash
# Local development
npm run dev

# Trước commit
npm run lint
npm run build

# Git
git add .
git commit -m "feat: description"
git push
```

### 2. **Scripts bổ sung** (thêm vào package.json)

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint . --ext .ts,.tsx",
    "lint:fix": "eslint . --ext .ts,.tsx --fix",
    "type-check": "tsc --noEmit",
    "test": "jest",
    "ci": "npm run lint && npm run type-check && npm run build"
  }
}
```

### 3. **Cấu hình Deploy**

**Vercel:**
- Auto-linked với GitHub
- Zero-config deployment
- Automatic preview URLs

**Alternative Options:**
- Netlify
- Firebase Hosting
- AWS Amplify
- Docker + CI/CD

---

## 🔐 Security Best Practices

1. ✅ Sử dụng GitHub Secrets cho sensitive data
2. ✅ Không commit `.env` files
3. ✅ Branch protection cho main
4. ✅ Require CI/CD pass trước merge
5. ✅ Regular dependency updates

### `.env` Example:
```
# .env.local (không commit)
NEXT_PUBLIC_API_URL=http://localhost:3000
API_SECRET=your_secret_here
```

### `.gitignore` update:
```
.env
.env.local
.env.*.local
.next
node_modules
```

---

## 🚨 Troubleshooting

### Build fails locally nhưng pass CI?
```bash
# Clear cache
rm -rf .next node_modules
npm ci
npm run build
```

### Node version incompatibility?
Cập nhật `node-version` trong workflows

### Vercel deployment fails?
- Check `VERCEL_TOKEN` secrets
- Xem logs trong Vercel dashboard
- Verify `vercel.json` config

---

## 📚 Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Next.js CI/CD Guide](https://nextjs.org/docs/guides/ci-cd)
- [Vercel Deployment](https://vercel.com/docs/deployments)
- [ESLint Configuration](https://eslint.org/docs/rules/)

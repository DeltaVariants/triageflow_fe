# Deployment Options Guide

## 🚀 Deployment Options

### 1. **Vercel (Recommended for Next.js)**

**Pros:**
- Zero-config deployment
- Automatic git integration
- Free tier with preview deployments
- Optimized for Next.js

**Setup:**
```bash
# Option 1: Via GitHub Actions (configured)
# Already set up in .github/workflows/deploy-vercel.yml

# Option 2: Vercel CLI
npm i -g vercel
vercel
```

**GitHub Secrets needed:**
- `VERCEL_TOKEN` - from Vercel account settings
- `VERCEL_ORG_ID` - organization ID
- `VERCEL_PROJECT_ID` - project ID

---

### 2. **Netlify**

**Setup:**
```yaml
name: Deploy to Netlify

on:
  push:
    branches: [main, master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20.x'
          cache: 'npm'
      - run: npm ci
      - run: npm run build
      - uses: netlify/actions/cli@master
        with:
          args: deploy --prod
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

**Get tokens:**
1. Go to [Netlify](https://netlify.com)
2. User settings → Applications → Auth tokens
3. Site settings → API ID

---

### 3. **Firebase Hosting**

**Setup:**
```yaml
name: Deploy to Firebase

on:
  push:
    branches: [main, master]

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20.x'
          cache: 'npm'
      - run: npm ci
      - run: npm run build
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: ${{ secrets.GITHUB_TOKEN }}
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          channelId: live
          projectId: your-project-id
```

---

### 4. **Docker + GitHub Container Registry**

**Dockerfile:**
```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
```

**GitHub Actions Workflow:**
```yaml
name: Build and Push Docker Image

on:
  push:
    branches: [main, master]
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:latest
```

---

### 5. **AWS Amplify**

**Setup:**
```yaml
name: Deploy to AWS Amplify

on:
  push:
    branches: [main, master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Deploy to Amplify
        run: |
          npm ci
          npm run build
          aws amplify deploy --app-id ${{ secrets.AMPLIFY_APP_ID }} --branch-name main
```

---

## 📋 Environment Variables by Platform

### **Vercel**
```
NEXT_PUBLIC_API_URL=https://api.example.com
NEXT_PUBLIC_ANALYTICS_ID=xxx
DATABASE_URL=postgresql://...
```

### **Netlify / Firebase**
```
REACT_APP_API_URL=https://api.example.com
REACT_APP_ENV=production
```

### **Docker**
```
NODE_ENV=production
API_URL=https://api.example.com
```

---

## 🔄 Git Workflow with CI/CD

### **Feature Development**
```bash
# 1. Create branch
git checkout -b feature/my-feature

# 2. Make changes
# ... code ...

# 3. Run local CI checks
./scripts/ci.sh  # or ci.bat on Windows

# 4. Commit
git add .
git commit -m "feat: add my feature"

# 5. Push (triggers CI/CD)
git push origin feature/my-feature

# 6. Create PR on GitHub
```

### **PR Checks Performed**
- ✅ Build test
- ✅ Code quality (ESLint, TypeScript)
- ✅ Preview deployment on Vercel

### **Merge to Main**
```bash
# When PR is approved and CI passes:
git checkout main
git pull origin main
git merge --squash feature/my-feature
git push origin main  # Triggers production deployment
```

---

## 🚨 Rollback Strategy

### **Vercel Rollback**
```bash
# Via CLI
vercel rollback

# Or via dashboard: Deployments → select previous → Promote to production
```

### **Manual Rollback**
```bash
# Revert specific commit
git revert abc123def
git push origin main

# Or reset to previous version
git reset --hard HEAD~1
git push origin main --force
```

---

## 📊 Monitoring & Alerts

### **GitHub Actions Monitoring**
- Go to **Actions** tab
- Check workflow runs
- Set up notifications in Settings

### **Deployment Monitoring**
- **Vercel**: Dashboard shows real-time logs
- **Netlify**: Deploy logs and analytics
- **Firebase**: Cloud Firestore/Realtime DB logs

### **Error Notifications**
Add to workflow:
```yaml
- name: Send Slack notification on failure
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "❌ Deployment failed: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
      }
```

---

## 🎯 Best Practices

1. ✅ Always run local CI before pushing
2. ✅ Use branch protection rules
3. ✅ Require CI checks to pass before merge
4. ✅ Use semantic versioning for releases
5. ✅ Keep deployment logs for audit
6. ✅ Monitor deployment performance
7. ✅ Set up rollback procedures
8. ✅ Use environment-specific configs
9. ✅ Automate testing as much as possible
10. ✅ Document deployment procedures

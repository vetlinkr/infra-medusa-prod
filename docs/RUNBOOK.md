# RUNBOOK - Medusa on DO

## 구성
- Cloudflare: DNS/Proxy/WAF
- DO Droplet: Nginx(80) → medusa_server(9000)
- Containers: medusa_server, medusa_worker, redis
- DB/Auth: Supabase (외부)
- Images: R2 (외부)

---

## 1. 서버 최초 1회 세팅

### 1) 레포 받기
```bash
git clone https://github.com/vetlinkr/infra-medusa-prod.git
cd infra-medusa-prod
```

### 2) .env 만들기
```bash
cp env/.env.example .env
# 편집해서 실제 값 채우기
```

### 3) GHCR pull-only 로그인
```bash
echo "$GHCR_TOKEN" | docker login ghcr.io -u <GITHUB_USERNAME> --password-stdin
```

---

## 2. 배포

### 기본 (prod 태그)
```bash
./scripts/deploy.sh
```

### 특정 태그로 배포 (롤백용)
```bash
IMAGE_TAG=sha-xxxxxxx ./scripts/deploy.sh
```

---

## 3. 점검

### 컨테이너 상태
```bash
docker compose -f compose.prod.yml ps
```

### 로그
```bash
docker compose -f compose.prod.yml logs -n 200 nginx
docker compose -f compose.prod.yml logs -n 200 medusa_server
docker compose -f compose.prod.yml logs -n 200 medusa_worker
docker compose -f compose.prod.yml logs -n 200 redis
```

---

## 4. 롤백

```bash
IMAGE_TAG=sha-이전태그 ./scripts/deploy.sh
```

---

## 5. Tunnel 전환 (나중)

```bash
# .env에 TUNNEL_TOKEN 채운 뒤
USE_TUNNEL=1 ./scripts/deploy.sh
```

Cloudflare에서 Public Hostname:
- api.vetlinkr.com → http://nginx:80

---
layout: default
title: API‑проекта
nav_order: 6
---

**База:** `/api/v1`

- `POST /auth/register`, `POST /auth/login`, `POST /auth/refresh`
- `GET /restaurants`, `GET /restaurants/{id}/menu`, `GET /dishes`
- `GET /cart`, `POST /cart/items`, `POST /orders`, `GET /orders/{id}`, `GET /orders/{id}/tracking`
- `POST /orders/{id}/pay`, `POST /payments/webhook`
- `GET/POST /restaurants/{id}/reviews`
- `POST /promocodes/verify`

Ответы в JSON, ошибки — RFC 7807; Swagger: `/api/docs`.

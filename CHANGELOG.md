# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.3.9](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.3.8...v0.3.9) (2026-07-07)


### 🐛 Fixes

* migrate MCAF module sources ([#2](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/issues/2)) ([8444323](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/8444323ff39e6c3b9e33640f500cb1f3dd58dd4c))

## [0.3.8](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.3.7...v0.3.8) (2026-06-26)

## [0.3.7](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.3.6...v0.3.7) (2026-03-09)


### 🐛 Fixes

* trigger lambda artifact update flows ([#13](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/13)) ([98bb9f2](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/98bb9f22034ff695fd5b36acb1b0e9fdf6cfd1c3))

## [0.3.6](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.3.5...v0.3.6) (2026-03-09)


### 🐛 Fixes

* remove pip from lambda artifact ([#12](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/12)) ([1448f6f](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/1448f6fad8f4821334031653182f1291ae142c37))
* remove pip from lambda artifact ([#12](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/12)) ([1448f6f](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/1448f6fad8f4821334031653182f1291ae142c37))

## [0.3.5](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.3.4...v0.3.5) (2025-10-01)


### 🐛 Fixes

* Adding exponential backoff for Terraform rate limit errors with max retry ([#11](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/11)) ([530d145](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/530d145163c7133234acac7f7c3488039fe84ece))

## [0.3.4](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.3.3...v0.3.4) (2025-09-15)


### 🐛 Fixes

* Adding code to handle rate limit HTTP 429 errors from Terraform API ([#10](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/10)) ([5b4704d](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/5b4704d62d79a316cacf71b66fd3a0c659345b81))

## [0.3.3](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.3.2...v0.3.3) (2025-09-05)


### 🐛 Fixes

* bug: Removing old packages before packaging ([#9](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/9)) ([82c7634](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/82c763475a264e5f4901a518a88354c2bf8975fb))

## [0.3.2](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.3.1...v0.3.2) (2025-09-05)


### 🐛 Fixes

* bug: Adding source_hash to trigger s3 object upload on code changes ([#8](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/8)) ([e04c0c8](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/e04c0c85e58f89ce896a50c96bc3435bbf09f824))

## [0.3.1](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.3.0...v0.3.1) (2025-08-29)


### 🐛 Fixes

* security: Upgrading requests to fix CVE-2025-50182 and CVE-2024-47081 ([#7](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/7)) ([088b22d](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/088b22d99a560a224e2b586ec351e65d682bd5d9))

## [0.3.0](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.2.1...v0.3.0) (2025-07-08)

## [0.2.1](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.2.0...v0.2.1) (2025-06-24)


### 🐛 Fixes

* allowing for aws provider version higher than 6 ([#5](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/5)) ([361bba2](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/361bba2d5346872250eed1f472865996a031e3a1))

## [0.2.0](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.1.1...v0.2.0) (2025-02-14)


### 🐛 Fixes

* Set the lambda runtime to 3.13 per default and updated the lambda libraries to latest versions ([#4](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/4)) ([db50fce](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/db50fce51f64bc029fe72f15a66729edddb8e46c))

## [0.1.1](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/compare/v0.1.0...v0.1.1) (2024-08-14)


### 🐛 Fixes

* Deploy lambdas using pre-built packages ([#2](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/2)) ([0ed384c](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/0ed384c49770113a9471381f80904a60cd046d5c))

## 0.1.0 (2024-08-12)


### 🚀 Features

* First version ([#1](https://github.com/schubergphilis/terraform-aws-mcaf-saas-audit-logs/pull/1)) ([9c74daf](https://github.com/schubergphilis-ep/terraform-aws-mcaf-saas-audit-logs/commit/9c74daff485980568177d0d8c15ae5c2cc132c73))

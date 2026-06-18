# TaskLink


![CI / RSpec](https://github.com/katsu-ya/tasklink/actions/workflows/ci.yml/badge.svg)


Rails + Turbo Streamで構築した、チーム向けリアルタイムタスク管理アプリです。

Rails標準技術である Turbo Stream を活用し、SPA化せずに快適なユーザー体験を実現しました。

また、認可・テスト・CI/CD・AWSデプロイまで含め、実務を意識した開発を行いました。

## URL

### Production（AWS EC2）

https://tasklink-app.com

### Demo（Render）

https://tasklink-1iv9.onrender.com

### GitHub

https://github.com/katsu-ya/tasklink



---



## 使用技術

| Category       | Tech                             |
| -------------- | -------------------------------- |
| Backend        | Ruby 3.3 / Rails 8               |
| Frontend       | Turbo / Stimulus / Tailwind CSS  |
| Database       | PostgreSQL                       |
| Authentication | Devise                           |
| Authorization  | Pundit                           |
| Testing        | RSpec                            |
| CI/CD          | GitHub Actions                   |
| Infrastructure | AWS EC2 / Nginx / Puma / systemd |
| Development    | Docker / Docker Compose          |

---



## アプリ概要

TaskLinkは個人・チームで利用できるタスク管理アプリです。

既存のToDoアプリで感じていた、

* ページ更新が多い
* チーム利用を想定していない
* 進捗状況が分かりにくい

といった課題を解決するために開発しました。

---



## 📷 画面イメージ

### タスク一覧画面

![タスク一覧画面](images/index.png)

### タスク作成モーダル

![タスク作成モーダル](images/new.png)

### 検索結果画面（キーワード）

![検索結果画面（キーワード）](images/search1.png)

### 検索結果画面（完了タスク）

![検索結果画面（完了タスク）](images/search2.png)

### スマホ表示

![スマホ表示](images/smartphone.png)

---



## 主な機能

### タスク管理

* タスク作成・編集・削除
* ステータス管理（Todo / Doing / Done）
* 期限管理
* 達成率表示

### 検索・フィルター

* キーワード検索
* ステータス別フィルター
* 件数のリアルタイム更新

### UI / UX

* Turbo Streamによるリアルタイム更新
* Turbo Frameを利用したモーダルUI
* SortableJSによるドラッグ＆ドロップ並び替え
* レスポンシブ対応

### セキュリティ

* Deviseによる認証
* Punditによるチーム単位の認可
* 他チームのタスクへのアクセス制御

---



## 工夫した点

### 1. Turbo Streamによるリアルタイム更新

タスクの作成・更新・削除時に、

* タスク一覧
* 達成率バー
* フィルター件数

をページリロードなしで更新しています。

SPAを導入せずにユーザー体験を向上させることを意識しました。

### 2. Punditによる認可

認証だけではURL直接アクセスを防げないため、Punditを導入しました。

* policy_scopeによる取得制御
* TaskPolicyによる閲覧・編集・削除制御

を実装し、チーム単位で安全にデータを管理できるようにしています。

### 3. 実運用を意識したインフラ構築

本番環境をAWS EC2上に構築しました。

* Nginx
* Puma
* systemd
* PostgreSQL

を利用し、HTTPS化および独自ドメイン運用に対応しています。

---



## ER Diagram

将来的なチーム共有機能・コメント機能まで見据えて設計しています。

![ER Diagram](images/er_diagram.png)


---

## インフラ構成

GitHub Actions

↓

AWS EC2

↓

Nginx

↓

Puma

↓

Rails

↓

PostgreSQL

### 構成ポイント

* GitHub Actionsによる自動デプロイ
* systemdによるPumaプロセス管理
* Let's EncryptによるHTTPS対応
* Elastic IPによる固定IP運用

---

## CI/CD

GitHub Actionsを利用し、mainブランチへのPush時に以下を自動実行しています。

### CI

* RSpec
* RuboCop
* bundler-audit

### CD

* bundle install
* rails db:migrate
* assets:precompile
* Puma restart



---

## テスト

RSpecを用いてテストを実装しています。

### テスト対象

* Model Spec
* Request Spec
* 認証
* 認可
* CRUD処理
* 検索・フィルター

### Coverage

約75%



---

## 開発環境

Docker Composeを利用し、RailsとPostgreSQLの開発環境を構築しています。

### 起動

```bash
docker compose build
docker compose up
```

### DB作成

```bash
docker compose run web rails db:create
docker compose run web rails db:migrate
```

---

## 苦労した点

チーム機能追加時に、本番環境の既存データに team_id が存在しない問題が発生しました。

Rails consoleを利用して原因を特定し、

* マイグレーション修正
* データ移行

を行うことで解決しました。

データベース変更時の既存データへの影響について学ぶことができました。



---



# 監視・ログ管理

TaskLinkでは AWS CloudWatch Agent、CloudWatch Metrics、CloudWatch Logs、CloudWatch Alarm、Amazon SNS を利用し、本番環境の監視・ログ管理・障害通知を実装しています。

## システム構成

```text
EC2 (Rails / Puma / PostgreSQL)
            ↓
     CloudWatch Agent
            ↓
 ┌───────────────┬────────────────┐
 ↓                                ↓
CloudWatch Metrics        CloudWatch Logs
 ↓                                ↓
CloudWatch Alarm      Metric Filter
 ↓                                ↓
Amazon SNS         Custom Metric
 ↓                                ↓
Email Notification   CloudWatch Alarm
                               ↓
                         Amazon SNS
                               ↓
                       Email Notification
```

## 監視目的

* ディスク容量不足による障害の予防
* メモリ不足によるアプリケーション停止の予防
* CPU高負荷によるレスポンス低下の早期検知
* Pumaプロセス停止の即時検知
* 本番環境ログの集中管理
* Railsアプリケーションエラーの早期発見
* 障害発生時の迅速な原因調査

---

## CloudWatch Metrics監視

### 監視アラーム

| アラーム名                    | 監視内容       | 条件             |
| ------------------------ | ---------- | -------------- |
| tasklink-disk-usage-80   | ディスク使用率    | 80%以上          |
| tasklink-memory-usage-80 | メモリ使用率     | 80%以上          |
| tasklink-cpu-usage-90    | CPU使用率     | CPU Idle ≤ 10% |
| tasklink-puma-down       | Pumaプロセス停止 | pid_count < 1  |

### 収集メトリクス

| メトリクス                     | 用途       |
| ------------------------- | -------- |
| disk_used_percent         | ディスク監視   |
| mem_used_percent          | メモリ監視    |
| cpu_usage_idle            | CPU監視    |
| procstat_lookup_pid_count | Puma死活監視 |

CloudWatch Alarm発生時は Amazon SNS を経由してメール通知を送信し、異常をリアルタイムで検知できる構成としています。

---

## CloudWatch Logs

Rails本番環境ではSTDOUTへ出力されたログをsystemd経由でsyslogへ集約し、CloudWatch Logsへ転送しています。

### ログ収集フロー

```text
Rails / Puma
     ↓
systemd journal
     ↓
/var/log/syslog
     ↓
CloudWatch Agent
     ↓
CloudWatch Logs
```

### ロググループ

```text
/tasklink/syslog
```

### 収集対象

* Railsアクセスログ
* Railsエラーログ
* Puma起動ログ
* systemdログ

---

## Rails 500エラー監視

CloudWatch LogsのMetric Filterを利用し、Railsアプリケーションで発生したHTTP 500エラーを監視しています。

### 監視構成

```text
CloudWatch Logs
      ↓
Metric Filter (Completed 500)
      ↓
Custom Metric (rails_500_errors)
      ↓
CloudWatch Alarm
      ↓
Amazon SNS
      ↓
Email Notification
```

### アラーム

| アラーム名                           | 条件             |
| ------------------------------- | -------------- |
| tasklink-rails-500-errors-alarm | HTTP 500エラー発生時 |

### 導入効果

* 本番障害の早期検知
* エラー発生時の即時通知
* MTTR（平均復旧時間）の短縮

---

## CloudWatch Dashboard

CloudWatch Dashboardを作成し、サーバーおよびアプリケーションの状態を一画面で可視化しています。

### 可視化項目

* Disk Usage (%)
* Memory Usage (%)
* CPU Idle (%)
* Rails 500 Errors

### 活用方法

障害発生時にはDashboardを確認することで、

* サーバーリソース状況の把握
* エラー発生状況の確認
* 異常発生箇所の切り分け

を迅速に実施できる構成としています。

---

## CloudWatch Logs Insights

CloudWatch Logs Insightsを利用し、本番環境ログの分析基盤を構築しています。

### 主な分析内容

* Rails 500エラー分析
* アクセスログ分析
* 不正アクセス検知
* IPアドレス別アクセス集計
* 障害発生時の原因調査

### 活用例

#### 500エラー分析

```sql
fields @timestamp, @message
| filter @message like /Completed 500/
| sort @timestamp desc
```

#### 不正アクセス分析

```sql
fields @timestamp, @message
| filter @message like /wp-admin/
```

#### アクセス元IP分析

```sql
fields @message
| parse @message /for (?<ip>[0-9\.]+) at/
| stats count() as requests by ip
```

---

## 運用上の工夫

運用中に発生したディスク容量不足の障害をきっかけに監視体制を整備しました。

CloudWatch Metricsによるリソース監視とCloudWatch Logsによるログ管理を組み合わせることで、

* 障害の早期発見
* 原因調査の迅速化
* サーバー状態の可視化

を実現しています。

また、ログをCloudWatch Logsへ集約することで、EC2へSSH接続せずにAWSコンソール上からログ確認が可能な構成としています。

---

## SRE / 運用改善

本プロジェクトでは以下の運用改善を実施しました。

* CloudWatch Agent導入
* CloudWatch Logs集約
* SNS通知構築
* Rails 500エラー監視
* Puma死活監視
* CloudWatch Dashboard作成
* Runbook整備
* CloudWatch Logs Insightsによるログ分析基盤構築

---

### Application Load Balancer

AWS Application Load Balancer（ALB）を導入し、
インターネットからのリクエストをEC2へルーティングしています。

#### 構成

Internet
↓
Application Load Balancer
↓
EC2 (Nginx)
↓
Puma
↓
Rails

#### 導入目的

- 可用性向上
- HTTPS終端への対応
- 将来的なAuto Scaling対応
- インフラ構成の本番運用化

#### 実装内容

- Target Group作成
- Health Check設定
- EC2登録
- Security Group設定
- ALB経由でRailsアプリへ接続

---


## 今後の改善予定

* CloudWatch Logs Insightsを活用したログ分析強化
* Runbook（障害対応手順書）の整備
* アプリケーション監視の高度化
* 監視ダッシュボードの継続改善



---



## 今後の追加機能予定

### 優先度高

* コメント機能
* 通知機能

### 優先度中

* カレンダー表示

### 優先度低

* ダークモード

---

## 作者

新城 克哉

GitHub
https://github.com/katsu-ya

Qiita
https://qiita.com/katsu-ya


---






















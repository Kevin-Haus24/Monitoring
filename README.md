# Monitoring
Проект для развертывания и наблюдения за распределённым приложением в Docker Swarm. В репозитории собраны конфигурации для запуска сервисов, сбора метрик, централизованного логирования, дашбордов и оповещений.
## 📋 Обзор
Инфраструктура поднимается на трёх виртуальных машинах через Vagrant:
- `manager01` — управляющий узел Swarm, на котором запускаются сервисы мониторинга
- `worker01` — рабочий узел с прикладными сервисами
- `worker02` — рабочий узел с прикладными сервисами
Проект демонстрирует полный цикл наблюдаемости:
- 📈 метрики через Prometheus и exporters
- 📊 графики и дашборды через Grafana
- 🪵 логи через Loki и Promtail
- 🚨 алерты через Alertmanager
- 🔎 проверки доступности через Blackbox Exporter
- 🧩 управление стеком через Portainer
## 🏗️ Архитектура
### 🧱 Прикладной стек
Файл [src/docker-compose.yml](src/docker-compose.yml) описывает набор сервисов, которые разворачиваются в Docker Swarm:
- `database` — PostgreSQL с инициализацией из [src/services/database/init.sql](src/services/database/init.sql)
- `rabbitmq` — очередь сообщений с web-интерфейсом управления
- `session-service` — сервис авторизации и сессий
- `hotel-service` — сервис отелей
- `booking-service` — сервис бронирований
- `payment-service` — сервис платежей
- `loyalty-service` — сервис баллов и лояльности
- `report-service` — сервис статистики и отчётов
- `gateway-service` — API gateway для маршрутизации запросов
- `nginx-proxy` — reverse proxy с конфигурацией из [src/services/nginx/default.conf](src/services/nginx/default.conf)
Сервисы используют внешнюю overlay-сеть `monitoring`, чтобы Prometheus, Loki и другие компоненты могли собирать метрики и логи.
### 🛰️ Мониторинговый стек
Файл [src/monitoring/stack.yml](src/monitoring/stack.yml) поднимает:
- `prometheus` — сбор и хранение метрик
- `loki` — хранение логов
- `promtail` — доставка контейнерных логов в Loki
- `node-exporter` — метрики хостов Swarm
- `cadvisor` — метрики контейнеров
- `blackbox-exporter` — проверки HTTP-доступности
- `grafana` — визуализация и дашборды
- `alertmanager` — маршрутизация оповещений
### ⚙️ Конфигурация мониторинга
- [src/monitoring/prometheus.yml](src/monitoring/prometheus.yml) — scrape jobs, включая Spring Boot приложения, node-exporter, cAdvisor и blackbox
- [src/monitoring/alert_rules.yml](src/monitoring/alert_rules.yml) — правила для памяти, RAM и CPU
- [src/monitoring/blackbox.yml](src/monitoring/blackbox.yml) — HTTP-модуль для проверок доступности
- [src/monitoring/loki-config.yml](src/monitoring/loki-config.yml) — конфигурация Loki
- [src/monitoring/promtail-config.yml](src/monitoring/promtail-config.yml) — сбор Docker-логов
- [src/monitoring/alertmanager.yml](src/monitoring/alertmanager.yml) — настройки email и Telegram-оповещений
## 🛠️ Скрипты и вспомогательные файлы
- [src/Vagrantfile](src/Vagrantfile) — создание трёх VM и подключение provisioning-скриптов
- [src/scripts/install-docker.sh](src/scripts/install-docker.sh) — установка Docker и Docker Compose plugin
- [src/scripts/manager-init.sh](src/scripts/manager-init.sh) — инициализация Swarm на manager-узле
- [src/scripts/worker-join.sh](src/scripts/worker-join.sh) — подключение worker-узлов к Swarm
- [src/services/portainer/stack.yml](src/services/portainer/stack.yml) — стек Portainer для управления кластером
- [src/REPORT.MD](src/REPORT.MD) — подробный отчёт с задачами и скриншотами
## 📡 Что отслеживается
Проект нацелен на наблюдаемость прикладного кластера и включает:
- 📈 метрики по сервисам Spring Boot через `/actuator/prometheus`
- 🖥️ состояние узлов и контейнеров через node-exporter и cAdvisor
- 🌐 проверку доступности API и внешнего ресурса через blackbox-exporter
- 🧾 централизованные логи контейнеров через Loki
- 🚨 алерты по низкой доступной памяти, высокой загрузке RAM и превышению CPU у сервисов
## 🚀 Быстрый старт
### 1. 🚀 Поднять инфраструктуру
Из каталога `src` выполните:
```bash
vagrant up
```
После завершения provisioning кластеры Swarm уже инициализированы: `manager01` становится manager-узлом, а `worker01` и `worker02` присоединяются к нему.
### 2. 🌐 Создать внешнюю сеть для мониторинга
На manager-узле создайте overlay-сеть, если она ещё не существует:
```bash
docker network create -d overlay --attachable monitoring
```
### 3. 📡 Развернуть мониторинг
```bash
docker stack deploy -c monitoring/stack.yml monitoring
```
### 4. 🧩 Развернуть прикладной стек
```bash
docker stack deploy -c docker-compose.yml app
```
### 5. 🛠️ При необходимости развернуть Portainer
```bash
docker stack deploy -c services/portainer/stack.yml portainer
```
## 🔗 Полезные адреса
После запуска сервисы доступны по следующим адресам:
- Prometheus — http://192.168.56.10:9090
- Grafana — http://192.168.56.10:3000
- Loki — http://192.168.56.10:3100
- Alertmanager — http://192.168.56.10:9093
- Blackbox Exporter — http://192.168.56.10:9115
- RabbitMQ Management — http://192.168.56.10:15672
- Nginx proxy для gateway — http://192.168.56.10:8087
- Nginx proxy для session-service — http://192.168.56.10:8081
- Hotel service — http://192.168.56.10:8082
- Portainer — http://192.168.56.10:9000
### 👤 Учётные данные Grafana по умолчанию:
- login: `admin`
- password: `admin`
## 🚦 Проверки и алерты
В [src/monitoring/prometheus.yml](src/monitoring/prometheus.yml) настроены проверки:
- Prometheus itself
- node-exporter на всех узлах
- cAdvisor на всех узлах
- Spring Boot сервисы по endpoint `/actuator/prometheus`
- HTTP-healthcheck через blackbox-exporter
В [src/monitoring/alert_rules.yml](src/monitoring/alert_rules.yml) описаны критические события:
- 💾 доступная память меньше 100 МБ
- 🧠 занятая RAM больше 1 ГБ
- ⚡ использование CPU сервисом выше 10%
## 📁 Структура проекта
```text
Monitoring/
├── README.md
├── misc/
│   └── images/
└── src/
	├── docker-compose.yml
	├── REPORT.MD
	├── Vagrantfile
	├── application_tests.postman_collection.json
	├── monitoring/
	│   ├── alert_rules.yml
	│   ├── alertmanager.yml
	│   ├── blackbox.yml
	│   ├── loki-config.yml
	│   ├── prometheus.yml
	│   ├── promtail-config.yml
	│   └── stack.yml
	├── scripts/
	│   ├── install-docker.sh
	│   ├── manager-init.sh
	│   └── worker-join.sh
	└── services/
	├── database/
	│   └── init.sql
	├── nginx/
	│   └── default.conf
	└── portainer/
			└── stack.yml
```
## 📝 Примечания

- Проект рассчитан на запуск в среде с поддержкой VirtualBox и Vagrant.
- Образы сервисов уже указаны в compose-файле и берутся из Docker Hub.
- Для отправки уведомлений через Alertmanager в [src/monitoring/alertmanager.yml](src/monitoring/alertmanager.yml) нужно заменить плейсхолдеры на реальные SMTP и Telegram-данные.

## 📄 Лицензия

Проект создан в учебных целях.
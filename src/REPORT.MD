## Part 1

### Task 1

- Использовать Docker Swarm из первого проекта.
  - ![](../misc/images/1.png)

### Task 2

- Написать при помощи библиотеки Micrometer сборщики следующих метрик приложения:
  - количество отправленных сообщений в rabbitmq;
  - количество обработанных сообщений в rabbitmq;
  - количество бронирований;
  - количество полученных запросов на gateway;
  - количество полученных запросов на авторизацию пользователей.
    - Для сервисов booking-service, gateway-service, report-service, session-service:
    - pom.xml:
    - ![](../misc/images/2.png)
    - application.properties:
    - ![](../misc/images/3.png)

### Task 3

- Добавить логи приложения с помощью Loki.
  - src/monitoring/loki-config.yml:
  - ![](../misc/images/4.png)
  - src/monitoring/promtail-config.yml:
  - ![](../misc/images/5.png)

### Task 4

- Создать новый стек для Docker Swarm из сервисов с Prometheus Server, Loki, node_exporter, blackbox_exporter, cAdvisor. Проверить получение метрик на порту 9090 через браузер.
  - src/monitoring/prometheus.yml:
  - ![](../misc/images/6.png)
  - src/monitoring/loki-config.yml:
  - ![](../misc/images/7.png)
  - src/monitoring/blackbox.yml:
  - ![](../misc/images/8.png)
  - src/monitoring/stack.yml:
  - ![](../misc/images/9.png)

  - Prometheus `http://192.168.56.10:9090`:
  - ![](../misc/images/10.png)
  - Prometheus проверка метрик:
  - ![](../misc/images/11.png)
  - ![](../misc/images/12.png)
  - ![](../misc/images/13.png)

## Part 2

### Task 1

- Развернуть grafana как новый сервис в стеке мониторинга.
  - ![](../misc/images/14.png)

### Task 2

- Добавить в Grafana дашборд со следующими метриками:
  - количество нод;
  - количество контейнеров;
  - количество стеков;
  - использование CPU по сервисам;
  - использование CPU по ядрам и узлам;
  - затраченная RAM;
  - доступная и занятая память;
  - количество CPU;
  - доступность google.com;
  - количество отправленных сообщений в rabbitmq;
  - количество обработанных сообщений в rabbitmq;
  - количество бронирований;
  - количество полученных запросов на gateway;
  - количество полученных запросов на авторизацию пользователей;
  - логи приложения.
    - ![](../misc/images/15.png)
    - ![](../misc/images/16.png)

## Part 3

### Task 1

- Развернуть Alert Manager как новый сервис в стеке монтиторинга.
  - ![](../misc/images/18.png)
  - ![](../misc/images/19.png)

### Task 2

- Добавить следующие критические события:
  - доступная память меньше 100 Мб;
  - затраченная RAM больше 1 Гб;
  - использование CPU по сервису превышает 10%.
    - ![](../misc/images/17.png)

### Task 3

- Настроить получение оповещений через личные email и Телеграм.
  - ![](../misc/images/20.png)
  - ![](../misc/images/21.png)

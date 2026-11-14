# OpenTitan — теория и лабораторные работы

Учебный репозиторий по архитектуре **OpenTitan** и разработке приложений для него с использованием **Zephyr RTOS** и **FreeRTOS**.

**Темы:** OpenTitan · RISC-V · Embedded Systems · Zephyr RTOS · FreeRTOS · RTL-моделирование

## Разделы проекта

| Раздел | Содержание | Статус |
| --- | --- | --- |
| [OpenTitan + Zephyr RTOS](opentitan-zephyr/) | 4 лабораторные работы, исходный код и результаты тестирования | Выполнены |
| [OpenTitan + FreeRTOS](opentitan-freertos/) | Будущие лабораторные работы | Планируется |
| [Общая теория OpenTitan](opentitan-theory/) | Архитектура, RISC-V, периферия, безопасность и моделирование | Учебные материалы |

## Лабораторные по Zephyr RTOS

| № | Тема | Результат |
| --- | --- | --- |
| [01](opentitan-zephyr/labs/01-environment/) | Настройка окружения и запуск Zephyr | UART smoke test, Hello World |
| [02](opentitan-zephyr/labs/02-uart-echo/) | UART echo-сервис | Проверка обмена данными и EXIT |
| [03](opentitan-zephyr/labs/03-keygen-service/) | Сервис генерации ключевого материала | Командный протокол, тестовые данные |
| [04](opentitan-zephyr/labs/04-uart-status/) | UART-сервис состояния | STATUS, BOGUS, EXIT и heartbeat |

Подробные версии инструментов, результаты и ограничения экспериментов сохранены в [README раздела Zephyr](opentitan-zephyr/README.md).

## О проекте

Лабораторные Zephyr выполнялись на RTL-модели **OpenTitan Earlgrey** с помощью **Verilator**. Это не означает, что любые приложения под FreeRTOS уже собраны или протестированы: раздел FreeRTOS пока намеренно пуст.

> **Примечание:** OpenTitan — аппаратная платформа с ориентированными на безопасность блоками. Возможность применения определённой RTOS и конкретных драйверов зависит от целевой конфигурации и поддержки платформы.

## Документация

- [Официальная документация OpenTitan](https://opentitan.org/book/)
- [Документация Zephyr](https://docs.zephyrproject.org/)
- [Документация FreeRTOS](https://www.freertos.org/)

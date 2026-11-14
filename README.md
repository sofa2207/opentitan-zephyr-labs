# OpenTitan — теория и лабораторные работы

Учебный репозиторий по архитектуре **OpenTitan** и разработке программного обеспечения на платформе **Earlgrey**. Практические работы выполнялись с **Zephyr** и RTL-моделью в **Verilator**. Отдельный раздел для **FreeRTOS** оставлен для будущих работ.

**OpenTitan** · **RISC-V** · **Earlgrey** · **Zephyr** · **FreeRTOS** · **Verilator**

## Разделы

| Направление | Содержание | Состояние |
|---|---|---|
| [OpenTitan + Zephyr](opentitan-zephyr/README.md) | Шесть лабораторных работ с ходом выполнения и результатами | 6 работ |
| [OpenTitan + FreeRTOS](opentitan-freertos/) | Отдельное направление для следующих лабораторных | Пока без работ |
| [Общая теория OpenTitan](opentitan-theory/README.md) | Архитектура, RISC-V, память, периферия, безопасность, симуляция | Справочные материалы |

## Лабораторные OpenTitan + Zephyr

| № | Тема | Результат |
|:--:|---|---|
| [01](opentitan-zephyr/labs/01-environment/README.md) | Настройка окружения | Запуск Zephyr, UART smoke test |
| [02](opentitan-zephyr/labs/02-uart-echo/README.md) | UART Echo | Обмен данными, `EXIT` |
| [03](opentitan-zephyr/labs/03-keygen-service/README.md) | Генерация ключевого материала | Тестовый RNG и командный протокол |
| [04](opentitan-zephyr/labs/04-uart-status/README.md) | UART Status | `STATUS`, `BOGUS`, `EXIT`, heartbeat |
| [05](opentitan-zephyr/labs/05-mp2fa/README.md) | MP2FA — менеджер паролей и 2FA | `REGISTER → GET + OTP → EXPORT` |
| [06](opentitan-zephyr/labs/06-synchronization/README.md) | Синхронизация OpenTitan и Zephyr | CDC, REQ/ACK, `k_sem`, диагностика |

## Технический контекст

- **Earlgrey** — конфигурация OpenTitan, применённая в учебных материалах.
- **Zephyr 3.7** — операционная система лабораторного стенда.
- **Verilator** — RTL-симуляция; результаты на модели не равнозначны испытаниям физического чипа.
- **FreeRTOS** — отдельная папка для будущих работ; готовая реализация не заявляется.



## Справочная документация

- [Теоретические материалы проекта](opentitan-theory/README.md)
- [Официальная документация OpenTitan](https://opentitan.org/book/)
- [Документация Zephyr](https://docs.zephyrproject.org/)
- [Документация FreeRTOS](https://www.freertos.org/)

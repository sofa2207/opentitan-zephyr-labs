# OpenTitan + Zephyr — лабораторные работы

[← Главная страница](../README.md) · [Общая теория OpenTitan](../opentitan-theory/README.md)

В этом разделе собраны **шесть лабораторных работ** по разработке и исследованию программного обеспечения для учебной модели OpenTitan Earlgrey с Zephyr. Каждая работа открывается по номеру в таблице.

## Навигация

| № | Лабораторная работа | Основной результат |
|:--:|---|---|
| [01](labs/01-environment/README.md) | Подготовка окружения и запуск Zephyr | UART smoke test и Hello World |
| [02](labs/02-uart-echo/README.md) | UART echo-сервис | Проверка обмена данными и `EXIT` |
| [03](labs/03-keygen-service/README.md) | Сервис генерации ключевого материала | Командный протокол, выдача тестовых данных |
| [04](labs/04-uart-status/README.md) | UART-сервис состояния | `STATUS`, `BOGUS`, `EXIT` и heartbeat |
| [05](labs/05-mp2fa/README.md) | MP2FA — менеджер паролей с двухфакторной аутентификацией | Архитектура, UART-протокол, регистрация, `GET + OTP`, `EXPORT`, девять скриншотов практики |
| [06](labs/06-synchronization/README.md) | Синхронизация в OpenTitan и Zephyr | Анализ CDC, `prim_flop_2sync`, REQ/ACK и `k_sem` |

## Используемое окружение

| Компонент | Версия / конфигурация |
|---|---|
| Ubuntu (лабораторный стенд) | 24.04 |
| OpenTitan | `earlgrey_1.0.0` |
| Verilator | 4.210 |
| Zephyr | 3.7.0 |
| Zephyr SDK | 0.16.8 |
| Целевая плата Zephyr | `opentitan_earlgrey` |

Конфигурации окружения приведены для лабораторных №1–4. В лабораторной №5 использованы Zephyr 3.7 и модель Earlgrey в Verilator.

## Результаты и ограничения

**01–04.** Показаны запуск Zephyr, UART-сервисы и командный протокол. В лабораторной №3 после результата PSA Crypto `-148` использован тестовый RNG; полученные данные нельзя считать криптографически стойкими без дополнительной проверки.

**05.** Продемонстрирован учебный MP2FA с OTP, хранением записей в RAM симуляции и экспортом шифротекста. На странице работы приведены оригинальные скриншоты практики. Это не готовое защищённое хранилище.

**06.** Рассмотрены аппаратные и программные механизмы синхронизации и методы анализа RTL, UART-журналов и временных диаграмм; экспериментальные осциллограммы не приложены.

## Полезная теория

- [Архитектура OpenTitan](../opentitan-theory/02-architecture.md)
- [RISC-V](../opentitan-theory/03-riscv.md)
- [Память](../opentitan-theory/04-memory-map.md)
- [Периферия](../opentitan-theory/05-peripherals.md)
- [Безопасность](../opentitan-theory/06-security.md)
- [Моделирование](../opentitan-theory/07-simulation.md)

## Источники

- [OpenTitan Documentation](https://opentitan.org/book/)
- [Zephyr Documentation](https://docs.zephyrproject.org/)

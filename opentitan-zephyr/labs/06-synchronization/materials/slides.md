---
marp: true
size: 16:9
paginate: true
theme: default
style: |
  section {
    font-family: 'DejaVu Sans', 'Noto Sans', 'Liberation Sans', sans-serif;
    background: #f7f5f1;
    color: #1a1a1a;
    padding: 48px 56px 40px 56px;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
  }
  h1 {
    color: #0b3d2e;
    font-size: 1.5em;
    margin: 0 0 18px 0;
    padding: 0 0 10px 0;
    border-bottom: 3px solid #c4a35a;
    line-height: 1.25;
  }
  h2 { color: #0b3d2e; font-size: 1.1em; margin: 0 0 10px 0; }
  p, li { font-size: 0.9em; line-height: 1.35; }
  ul { margin: 0.15em 0 0.3em 1.1em; }
  table { font-size: 0.8em; width: 100%; border-collapse: collapse; }
  th, td { border: 1px solid #cfc8bc; padding: 6px 10px; text-align: left; }
  th { background: #e4efe9; color: #0b3d2e; }
  pre, code { font-size: 0.55em; }
  pre { background: #ece8e0; padding: 10px; border-radius: 4px; }
  section.lead {
    background: linear-gradient(145deg, #0b3d2e 0%, #1a5c45 55%, #c4a35a 160%);
    color: #f7f5f1;
    justify-content: center;
    align-items: center;
    text-align: center;
  }
  section.lead h1 { color: #f7f5f1; border-bottom-color: #c4a35a; font-size: 1.9em; }
  section.lead h2, section.lead p { color: #f7f5f1; }
  section.part {
    background: #0b3d2e; color: #f7f5f1;
    justify-content: center; align-items: center; text-align: center;
  }
  section.part h1 { color: #f7f5f1; border-bottom-color: #c4a35a; font-size: 1.9em; }
  section.shot { padding: 40px 40px 24px 40px; }
  section.shot h1 { font-size: 1.2em; margin-bottom: 10px; }
  section.shot img {
    max-height: 540px; max-width: 100%; width: auto;
    display: block; margin: 0 auto; object-fit: contain;
  }
  footer { color: #666; font-size: 0.5em; }
footer: Синхронизация · OpenTitan + Zephyr
---

<!-- _class: lead -->

# Синхронизация в OpenTitan и Zephyr

Исследование механизмов синхронизации  
и способов их отладки

Стенд: Earl Grey (Verilator) + Zephyr 3.7

---

# Повестка

1. Два уровня синхронизации  
2. Аппаратура OpenTitan (CDC, регистры)  
3. Handshake `prim_sync_reqack`  
4. Отладка: логи и волны  
5. Объект синхронизации Zephyr (`k_sem`)  
6. Взаимодействие компонентов  
7. Итоги  

---

<!-- _class: part -->

# Часть 1
## Два уровня

---

<!-- _class: shot -->

# Два уровня синхронизации

![w:1180](assets/01-two-levels.png)

---

# Зачем разделять уровни

| Уровень | Что синхронизируем |
|---------|-------------------|
| **OpenTitan** | Сигналы между **тактовыми доменами** (CDC) |
| **Zephyr** | Потоки и ISR: «кто ждёт событие» |

Железо делает безопасным **бит/событие между clock domains**.  
ОС координирует **логику потоков**. Одно другое не заменяет.

---

<!-- _class: part -->

# Часть 2
## OpenTitan — железо

---

# Проблема: метастабильность

В SoC Earl Grey несколько тактовых доменов (Ibex, периферия, async-входы).

Если сигнал из домена A защёлкнуть **одним** триггером на такте B →  
риск **метастабильности**.

Решение: **двухступенчатый синхронизатор** (`prim_flop_2sync`).

---

<!-- _class: shot -->

# prim_flop_2sync

![w:1180](assets/02-flop-2sync.png)

---

# Регистры, которые смотрим

Файл: `prim_generic_flop_2sync.sv`

| Имя | Роль |
|-----|------|
| `d_i` | вход (может быть async к `clk_i`) |
| `d_o` | после CDC-delay модели (в SIM) |
| **`intq`** | выход FF1 — промежуточный регистр |
| **`q_o`** | выход FF2 — стабильный для логики DST |

Порты такта: `clk_i`, `rst_ni` — **приёмный** домен.  
Латентность обычно **2 такта** DST.

---

<!-- _class: shot -->

# prim_sync_reqack

![w:1180](assets/03-reqack.png)

---

# Handshake: суть

Нужно передать **событие** (REQ/ACK), а не просто статический бит.

- SRC: `src_req_i` / `src_ack_o`, FSM `src_fsm_q`  
- DST: `dst_req_o` / `dst_ack_i`, FSM `dst_fsm_q`  
- Линии REQ и ACK идут через **`prim_flop_2sync`**

Правила: не снимать REQ без ACK; не слать ACK без REQ;  
при сбросе — осторожно с NRZ vs RZ режимами.

---

# Другие примитивы (обзор)

| Модуль | Назначение |
|--------|------------|
| `prim_pulse_sync` | синхронизация импульса |
| `prim_rst_sync` | синхронизация сброса |
| `prim_fifo_async` | FIFO между доменами |
| `prim_mubi*_sync` | multi-bit / MuBi |
| `prim_reg_cdc` | CDC регистров периферии |

Для отчёта достаточно уверенно разобрать **flop_2sync** + **sync_reqack**.

---

<!-- _class: part -->

# Часть 3
## Отладка

---

<!-- _class: shot -->

# Логи и волны

![w:1180](assets/06-debug.png)

---

# Практика на стенде Verilator

**Логи ПО**

- `uart0.log` / PTY — boot, `READY`, ответы приложения  
- `sim.stdout` — PTY, ошибки meminit  

**Волны железа**

- FST/VCD → GTKWave  
- искать `intq`, `q_o`, `src_fsm_q`, `dst_fsm_q`  
- смотреть относительно такта **DST**

На учебном Verilator «отладчик» часто = **логи + волны**, не полный JTAG.

---

# Типичные ошибки

| Симптом | Куда смотреть |
|---------|----------------|
| Нет READY | boot / ELF / жив ли sim |
| Мусор UART | неверный pts, фрагментация |
| Пропал импульс на DST | ширина импульса vs 2sync |
| Рассинхрон битов шины | нужен gray / handshake, не N×2sync |
| FSM «разъехались» | сброс только одного домена (NRZ) |

---

<!-- _class: part -->

# Часть 4
## Zephyr — объект синхронизации

---

<!-- _class: shot -->

# Семафор k_sem

![w:1180](assets/04-zephyr-sem.png)

---

# Назначение и принцип

**`struct k_sem`** — counting semaphore ядра Zephyr.

- **count** — сколько раз можно взять  
- **limit** — максимум count  
- `k_sem_give` — сигналить (поток или ISR)  
- `k_sem_take` — ждать / забрать (поток)

```c
K_SEM_DEFINE(my_sem, 0, 1);  /* бинарный */
k_sem_give(&my_sem);         /* ISR / producer */
k_sem_take(&my_sem, K_MSEC(50));
```

Документация: `zephyr/doc/kernel/services/synchronization/`

---

# Соседи и планировщик

| Объект | Когда |
|--------|--------|
| `k_mutex` | критическая секция (только потоки) |
| `k_condvar` | условие + mutex |
| `k_event` / очереди | более сложные события |

При `take` с count=0 поток **блокируется**; `give` будит  
ожидающего через **планировщик** Zephyr.

---

<!-- _class: shot -->

# Связь с железом OT

![w:1180](assets/05-stack.png)

---

# Как уровни стыкуются

```text
IRQ / статус периферии
        ↓
  (ниже: CDC flop_2sync — безопасный сигнал)
        ↓
ISR Zephyr → k_sem_give
        ↓
Поток → k_sem_take → обработка
```

HW синхронизирует **сигналы между тактами**.  
SW синхронизирует **потоки**. На стенде OT+Zephyr работают вместе.

---

# Итоги

1. OT: CDC через `prim_flop_2sync` (`intq`, `q_o`) и `prim_sync_reqack`  
2. Отладка: UART-логи сценария + волны регистров синхронизаторов  
3. Zephyr: главный объект — **`k_sem`** (give/take, ISR↔поток)  
4. Уровни дополняют друг друга, не дублируют  

---

<!-- _class: lead -->

# Спасибо

## Вопросы?

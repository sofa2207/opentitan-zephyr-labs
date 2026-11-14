#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d .git || ! -d opentitan-zephyr/labs ]]; then
  echo "Ошибка: запустите скрипт из корня репозитория opentitan-zephyr-labs." >&2
  exit 1
fi
if [[ "$(git branch --show-current)" != "main" ]]; then
  echo "Ошибка: ожидается ветка main." >&2
  exit 1
fi

for lab in 05-mp2fa 06-synchronization; do
  if [[ ! -f "opentitan-zephyr/labs/$lab/README.md" ]]; then
    echo "Ошибка: лабораторная $lab не найдена." >&2
    exit 1
  fi
done

# Удаляем только презентационные материалы из двух новых лабораторных.
for lab in 05-mp2fa 06-synchronization; do
  mat="opentitan-zephyr/labs/$lab/materials"
  if [[ -d "$mat" ]]; then
    find "$mat" -type f \( -name '*.pptx' -o -name '*.pdf' -o -name '*.html' -o -name 'slides.md' -o -name 'speaker-notes.md' \) -delete
    find "$mat" -depth -type d -empty -delete
  fi
done

# Файлы README из архива расположены по пути репозитория и перезаписываются при распаковке.
echo "Готово. Теперь выполните: git status; git diff --check; git add -A; git commit -m 'Remove presentation materials from labs 5 and 6'; git push origin main"

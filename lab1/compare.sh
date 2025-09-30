#!/usr/bin/env bash

# Перевірка кількості параметрів
if [[ $# -ne 2 ]]; then
    echo "Використання: $0 <число1> <число2>"
    exit 1
fi

# Числові параметри
a=$1
b=$2

# Функція для виведення розміру файлу скрипта
show_script_size() {
    # ${BASH_SOURCE[0]} – шлях до поточного скрипта
    local script_path="${BASH_SOURCE[0]}"
    if [[ -f "$script_path" ]]; then
        local size
        size=$(stat -c%s "$script_path" 2>/dev/null || stat -f%z "$script_path")
        echo "Розмір скрипта \"$script_path\": $size байт"
    else
        echo "Не вдалося визначити розмір скрипта."
    fi
}

# Порівняння параметрів
if (( a > b )); then
    echo "Перший параметр ($a) більше другого ($b)."
    echo "Список псевдонімів (alias) у вашій системі:"
    alias
else
    echo "Перший параметр ($a) НЕ більше другого ($b)."
    show_script_size
fi

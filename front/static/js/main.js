document.addEventListener('DOMContentLoaded', async function() {
    // Константы
    const ROW_HEIGHT = 40;
    const HEADER_HEIGHT = 30;
    const BASE_MAX_HEIGHT = 8 * ROW_HEIGHT + HEADER_HEIGHT;

    // Инициализация панелей (синхронная часть)
    function initPanels() {
        const panelsData = [
            { subtitle: "Рейс", title: "Ничего не выбрано", hasArrow: true },
            { subtitle: "Борт", title: "Boeing 737-800", hasArrow: false },
            { subtitle: "Компоновка", title: "Б8 Э60", hasArrow: false },
            { subtitle: "ВС", title: "ТУЗ", hasArrow: false },
            { subtitle: "Маршрут", title: "ДМД - РЩН", hasArrow: false },
            { subtitle: "Вылет", title: "11:00", hasArrow: false },
            { subtitle: "Регистрация до", title: "10:25", hasArrow: false },
            { subtitle: "Тип", title: "Пассажирский", hasArrow: false },
            { subtitle: "Статус", title: "Регистрация", hasArrow: false }
        ];

        const leftPanel = document.querySelector('.left-panel');
        leftPanel.innerHTML = '';

        panelsData.forEach(panel => {
            const panelElement = document.createElement('div');
            panelElement.className = 'panel';
            panelElement.innerHTML = `
                <div class="panel__inner">
                    <div class="panel__content">
                        <span class="panel__subtitle">${panel.subtitle}</span>
                        <span class="panel__title">${panel.title}</span>
                    </div>
                    ${panel.hasArrow ? '<img src="/static/resources/arrow.svg" alt="Стрелка" class="panel__arrow">' : ''}
                </div>
            `;
            leftPanel.appendChild(panelElement);
        });
    }

    // Основная функция инициализации таблицы
    async function initTable() {
        const tableContainer = document.querySelector('.table-scroll-container');
        const thead = document.querySelector('.table-header thead');
        const tbody = document.querySelector('.table-body tbody');

        // Создаем заголовок для выбранных строк
        const selectedRowsHeader = document.createElement('div');
        selectedRowsHeader.className = 'selected-rows-header';
        const selectedRowsTable = document.createElement('table');
        selectedRowsTable.className = 'table';
        const selectedRowsBody = document.createElement('tbody');
        selectedRowsTable.appendChild(selectedRowsBody);
        selectedRowsHeader.appendChild(selectedRowsTable);
        thead.parentNode.insertBefore(selectedRowsHeader, thead.nextSibling);

        const selectedRows = new Map();

        try {
            // Загрузка данных
            const response = await fetch('/api/passengers/get_passengers_by_flight');
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            
            const tableData = await response.json();
            if (!Array.isArray(tableData)) throw new Error('Expected array');
            
            // Заполнение таблицы
            fillTable(tableData);
            
            // Настройка контейнера
            tableContainer.style.maxHeight = `${BASE_MAX_HEIGHT}px`;
            
            // Синхронизация размеров
            setTimeout(() => {
                syncColumnWidths();
                updateContainerHeight();
            }, 0);
            
        } catch (error) {
            console.error('Failed to load passenger data:', error);
            alert('Не удалось загрузить данные пассажиров. Пожалуйста, обновите страницу.');
        }

            function updatePassengerDetails() {
        const passengersContainer = document.querySelector('.passanges');
        passengersContainer.innerHTML = '';

        selectedRows.forEach(({ original }) => {
            const pnr = original.dataset.pnr;
            const cells = original.cells;
            const passengerData = {
                pnr: cells[0].textContent,
                name: cells[1].textContent,
                seat: cells[2].textContent,
                class: cells[3].textContent,
                ticket: cells[7].textContent,
                doc: cells[8].textContent
            };

            const passengerDiv = document.createElement('div');
            passengerDiv.className = 'passenger-div';
            passengerDiv.innerHTML = `
                <div class="passenger-header">
                    <h3>${passengerData.name}</h3>
                    <span class="passenger-pnr">${passengerData.pnr}</span>
                </div>
                <div class="passenger-content">
                    <div class="passenger-info">
                        <div class="info-row">
                            <span class="info-label">Место:</span>
                            <div class="info-value">
                                <span class="seat-value">${passengerData.seat}</span>
                                <button class="seat-select-btn">Выбрать</button>
                            </div>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Класс:</span>
                            <span class="info-value">${passengerData.class}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Билет:</span>
                            <span class="info-value">${passengerData.ticket}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Документ:</span>
                            <span class="info-value">${passengerData.doc}</span>
                        </div>
                    </div>
                    <div class="passenger-remarks">
                        <div class="remark-input-container">
                            <input type="text" class="remark-input" placeholder="Введите примечание" title="Нажмите Enter для добавления">
                            <button class="add-remark-btn">Добавить</button>
                        </div>
                        <div class="remarks-list"></div>
                    </div>
                </div>
                <div class="passenger-actions">
                    <button class="action-btn checkin-btn">Оформить посадку</button>
                    <button class="action-btn cancel-btn">Отмена</button>
                </div>
            `;

            // Элементы управления
            const addRemarkBtn = passengerDiv.querySelector('.add-remark-btn');
            const remarkInput = passengerDiv.querySelector('.remark-input');
            const remarksList = passengerDiv.querySelector('.remarks-list');
            const seatSelectBtn = passengerDiv.querySelector('.seat-select-btn');
            const seatValue = passengerDiv.querySelector('.seat-value');
            const checkinBtn = passengerDiv.querySelector('.checkin-btn');
            const passengerContent = passengerDiv.querySelector('.passenger-content');
            const passengerActions = passengerDiv.querySelector('.passenger-actions');

            // Массив для хранения примечаний
            const remarks = [];

            // Обновление списка примечаний
            function updateRemarksList() {
                remarksList.innerHTML = '';
                remarks.forEach((remark, index) => {
                    const remarkItem = document.createElement('div');
                    remarkItem.className = 'remark-item';
                    remarkItem.innerHTML = `
                        <span>${remark}</span>
                        <button class="remove-remark-btn" data-index="${index}">×</button>
                    `;
                    remarksList.appendChild(remarkItem);
                });
            }

            // Добавление примечания
            function addRemark() {
                const text = remarkInput.value.trim();
                if (text) {
                    remarks.push(text);
                    remarkInput.value = '';
                    updateRemarksList();
                    remarkInput.focus();
                }
            }

            // Обработчики событий
            remarkInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    addRemark();
                }
            });

            addRemarkBtn.addEventListener('click', addRemark);

            remarksList.addEventListener('click', (e) => {
                if (e.target.classList.contains('remove-remark-btn')) {
                    const index = parseInt(e.target.dataset.index);
                    remarks.splice(index, 1);
                    updateRemarksList();
                }
            });

            seatSelectBtn.addEventListener('click', () => {
                const newSeat = prompt('Введите номер места:', passengerData.seat);
                if (newSeat) {
                    seatValue.textContent = newSeat;
                }
            });

            checkinBtn.addEventListener('click', () => {
                console.log('Оформление посадки:', {
                    pnr: passengerData.pnr,
                    seat: seatValue.textContent,
                    remarks: [...remarks]
                });

                // Сворачиваем до ФИО и PNR
                passengerContent.style.display = 'none';
                passengerActions.style.display = 'none';
                passengerDiv.classList.add('checked-in');
            });

            passengersContainer.appendChild(passengerDiv);
        });
    }


    function selectRow(row, index) {
        if (selectedRows.has(index)) return;

        const newRow = document.createElement('tr');
        newRow.innerHTML = row.innerHTML;
        newRow.classList.add('selected');
        selectedRowsBody.appendChild(newRow);

        selectedRows.set(index, {
            original: row,
            cloned: newRow
        });
        updatePassengerDetails();

        row.style.display = 'none';

        newRow.addEventListener('click', function (e) {
            if (e.ctrlKey || e.metaKey) {
                unselectRow(index);
            }
        });

        const rowsCount = document.querySelectorAll('.table-body tr:not([style*="display: none"])').length;
        if (rowsCount >= 8) {
            const currentMaxHeight = parseInt(tableContainer.style.maxHeight) || BASE_MAX_HEIGHT;
            tableContainer.style.maxHeight = `${currentMaxHeight + ROW_HEIGHT}px`;
        }
        syncColumnWidths();
        updateContainerHeight();
    }

    function updateContainerHeight() {
        const headerHeight = document.querySelector('.table-header').offsetHeight;
        const selectedRowsHeight = selectedRowsHeader.offsetHeight;
        const bodyHeight = tbody.offsetHeight;
        const minHeight = parseInt(getComputedStyle(tableContainer).minHeight);
        const totalHeight = headerHeight + selectedRowsHeight + bodyHeight;

        tableContainer.style.height = `${Math.max(totalHeight, minHeight)}px`;
    }

    function unselectRow(index) {
        if (!selectedRows.has(index)) return;

        const { original, cloned } = selectedRows.get(index);
        selectedRowsBody.removeChild(cloned);
        original.style.display = '';
        selectedRows.delete(index);
        updatePassengerDetails();

        const rowsCount = document.querySelectorAll('.table-body tr:not([style*="display: none"])').length;
        if (rowsCount >= 8) {
            const currentMaxHeight = parseInt(tableContainer.style.maxHeight) || BASE_MAX_HEIGHT;
            tableContainer.style.maxHeight = `${Math.max(BASE_MAX_HEIGHT, currentMaxHeight - ROW_HEIGHT)}px`;
        }

        syncColumnWidths();
        updateContainerHeight();
    }

    function clearSelection() {
        selectedRows.forEach((_value, index) => {
            unselectRow(index);
            updatePassengerDetails();
        });
    }

    function fillTable(data) {
        tbody.innerHTML = '';
        selectedRowsBody.innerHTML = '';
        selectedRows.clear();

        data.forEach((item, index) => {
            const row = document.createElement('tr');
            row.dataset.pnr = item.pnr;
            row.dataset.index = index;

            row.innerHTML = `
                <td>${item.pnr || ''}</td>
                <td>${item.name || ''}</td>
                <td>${item.ps || ''}</td>
                <td>${item.kl || ''}</td>
                <td>${item.podkl || ''}</td>
                <td>${item.kr || ''}</td>
                <td>${item.pn || ''}</td>
                <td>${item.ticket || ''}</td>
                <td>${item.doc || ''}</td>
            `;

            row.addEventListener('click', function (e) {
                if (e.ctrlKey || e.metaKey) {
                    if (selectedRows.has(index)) {
                        unselectRow(index);
                    } else {
                        selectRow(row, index);
                    }
                } else {
                    selectAllWithSamePnr(item.pnr);
                }
            });

            tbody.appendChild(row);
        });
    }

    function selectAllWithSamePnr(pnr) {
        clearSelection();
        const rows = document.querySelectorAll(`.table-body tr[data-pnr="${pnr}"]`);

        rows.forEach(row => {
            const index = parseInt(row.dataset.index);
            if (!selectedRows.has(index)) {
                selectRow(row, index);
            }
        });
    }

    function syncColumnWidths() {
        const headerCols = document.querySelectorAll('.table-header th');
        const selectedCols = document.querySelectorAll('.selected-rows-header td');
        const bodyCols = document.querySelectorAll('.table-body td');

        headerCols.forEach((th, index) => {
            const width = th.style.width || getComputedStyle(th).width;
            if (selectedCols[index]) selectedCols[index].style.width = width;
            if (bodyCols[index]) bodyCols[index].style.width = width;
        });
    }

        // ... остальные функции (fillTable, updatePassengerDetails и т.д.) остаются без изменений
        // Они должны быть объявлены внутри initTable()
    }

    // Инициализация
    initPanels();
    initTable();
});
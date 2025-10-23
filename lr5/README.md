# Практическая работа №5, Никитин Артемий Викторович, ЭФБО-10-23
## Цели:

- Научиться отображать коллекции данных с помощью ListView.builder.
    
- Освоить базовую навигацию Navigator.push / Navigator.pop и передачу данных через конструктор.
    
- Научиться добавлять, редактировать и удалять элементы списка без внешних пакетов и сложных архитектур.
## Ход работы
- **Создание проекта**.
- **Настройка структуры файлов**:
    
    - Созданы файлы:
        - *lib/models/note.dart* для модели данных Note.
        - *lib/edit_note_page.dart* для экрана добавления/редактирования заметок.
        - *lib/main.dart* для главного экрана со списком заметок.
- **Реализация модели данных**:
    
    - В файле *note.dart* определён класс *Note* с полями *id*, *title*, *body* и методом *copyWith* для создания обновлённых копий объекта.
    - Уникальный идентификатор генерируется через *DateTime.now().millisecondsSinceEpoch.toString().*
    
    **Фрагмент кода**:
    
  ```dart
  class Note {
  final String id;
  String title;
  String body;
  Note({required this.id, required this.title, required this.body});
  Note copyWith({String? title, String? body}) => Note(
   id: id,
   title: title ?? this.title,
   body: body ?? this.body,
  );
}
   ```
   *Класс Note обеспечивает иммутабельность идентификатора и позволяет обновлять заголовок и текст заметки.*
	**Реализация главного экрана**:

	- В main.dart создан экран NotesPage с использованием StatefulWidget для управления списком заметок.
	- Реализован ListView.builder для отображения заметок с использованием ListTile и Dismissible для свайп-удаления.
	- Добавлена кнопка FloatingActionButton для перехода к созданию новой заметки.
	- Реализован поиск через SearchDelegate, фильтрующий заметки по заголовку.
	**Фрагмент кода**
```dart
ListView.builder(
  itemCount: filteredNotes.length,
  itemBuilder: (context, i) {
    final note = filteredNotes[i];
    return Dismissible(
      key: ValueKey(note.id),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _delete(note),
      child: Container(
        color: Colors.red[900],
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          title: Text(
            note.title.isEmpty ? '(без названия)' : note.title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Text(
            note.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[300]),
          ),
          onTap: () => _edit(note),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => _delete(note),
          ),
        ),
      ),
    );
  },
)
```
*Пояснение: ListView.builder отображает заметки с возможностью свайп-удаления через Dismissible. Использование ValueKey(note.id) обеспечивает стабильность анимаций.*
	**Обработка событий и навигация**:

- Добавление заметки: Navigator.push открывает EditNotePage, результат добавляется в список через setState.
- Редактирование: Передача объекта Note через конструктор, обновление через copyWith и setState.
- Удаление: Реализовано через кнопку корзины и свайп (Dismissible) с SnackBar для отмены.
- Поиск: SearchDelegate фильтрует заметки по заголовку в реальном времени.
**Фрагмент кода**
```dart
void _delete(Note note) {
  setState(() {
    _notes.removeWhere((n) => n.id == note.id);
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Заметка удалена', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: 'Отменить',
    

    textColor: Colors.red,
        onPressed: () {
          setState(() => _notes.add(note));
        },
      ),
    ),
  );
}
```
Пояснение: Удаление обновляет список через setState, а SnackBar позволяет отменить действие.
## Скриншоты:
![[video_2025-10-09_13-25-00.mp4]]
## Выводы:
были приобретены навыки:
- Использование ListView.builder для эффективного отображения динамических списков.
- Навигация и передача данных между экранами через Navigator.push/pop.
- Управление состоянием списка с помощью setState и иммутабельной модели Note.
- Реализация свайп-удаления через Dismissible и фильтрации через SearchDelegate.
- Настройка визуального стиля с чёрно-красной палитрой, обеспечивающей контрастность и доступность.

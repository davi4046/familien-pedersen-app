import 'dart:math';
import 'dish_selection_page.dart';
import 'package:flutter/material.dart';

class Dish {
  Dish({required this.title, required this.time});

  final String title;
  final String time;
  List<Dish> accompaniment = [];
}

class WeekDay {
  WeekDay({
    this.isExpanded = false,
    required this.header,
  });

  bool isExpanded;
  final String header;
  TimeOfDay dinnerTime = TimeOfDay(hour: 19, minute: 0);
  List<Dish> dishes = [];
}

List<WeekDay> _weekDays = [
  WeekDay(header: 'Mandag'),
  WeekDay(header: 'Tirsdag'),
  WeekDay(header: 'Onsdag'),
  WeekDay(header: 'Torsdag'),
  WeekDay(header: 'Fredag'),
  WeekDay(header: 'Lørdag'),
  WeekDay(header: 'Søndag'),
];

late int _selWeekDayIndex;
late int _selDishIndex;

class FoodplanCreationPage extends StatefulWidget {
  const FoodplanCreationPage({Key? key}) : super(key: key);

  @override
  State<FoodplanCreationPage> createState() => _FoodplanCreationPageState();
}

class _FoodplanCreationPageState extends State<FoodplanCreationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opret madplan'),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expandedHeaderPadding: const EdgeInsets.all(0),
          children: _weekDays.map((WeekDay weekDay) {
            return ExpansionPanel(
              isExpanded: weekDay.isExpanded,
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      weekDay.header,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
              body: WeekDayBody(index: _weekDays.indexOf(weekDay)),
            );
          }).toList(),
          expansionCallback: (i, isExpanded) =>
              setState(() => _weekDays[i].isExpanded = !isExpanded),
        ),
      ),
    );
  }
}

class WeekDayBody extends StatefulWidget {
  WeekDayBody({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<WeekDayBody> createState() => _WeekDayBodyState();
}

class _WeekDayBodyState extends State<WeekDayBody> {
  late String displayTime =
      _weekDays[widget.index].dinnerTime.toString().split('(')[1].split(')')[0];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 16),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Spisetidspunkt:',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    displayTime,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  'Deltagere (4):',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          radius: 24,
                          child: ClipOval(
                            child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          radius: 24,
                          child: ClipOval(
                            child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          radius: 24,
                          child: ClipOval(
                            child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          radius: 24,
                          child: ClipOval(
                            child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 24,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const Divider(thickness: 1),
      ReorderableListView(
        shrinkWrap: true,
        onReorder: (oldIndex, newIndex) {
          final index = newIndex > oldIndex ? newIndex - 1 : newIndex;
          setState(() {
            final dish = _weekDays[widget.index].dishes.removeAt(oldIndex);
            _weekDays[widget.index].dishes.insert(index, dish);
          });
        },
        children: _buildDishes(),
      ),
      TextButton(
        onPressed: () {
          _openDishSelectionPage(context);
          _selWeekDayIndex = widget.index;
        },
        child: const Text(
          'Tilføj ret',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ]);
  }

  // Opens DishSelectionPage() and takes 'selectedDish' as an argument on navigator.pop().
  Future<void> _openDishSelectionPage(BuildContext context) async {
    final selectedDish = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DishSelectionPage()),
    );

    if (selectedDish != null) {
      setState(() => _weekDays[_selWeekDayIndex].dishes.add(selectedDish));
    }
  }

  List<Dismissible> _buildDishes() {
    return _weekDays[widget.index].dishes.map((dish) {
      return Dismissible(
        background: Container(
          color: Colors.red,
          child: Icon(
            Icons.delete,
            color: Theme.of(context).canvasColor,
          ),
        ),
        direction: DismissDirection.startToEnd,
        key: ValueKey(getRandomString(10)),
        onDismissed: (direction) {
          setState(() {
            _weekDays[widget.index]
                .dishes
                .removeAt(_weekDays[widget.index].dishes.indexOf(dish));
          });
        },
        child: ListTile(
          key: ValueKey(getRandomString(10)),
          title: Text(dish.title),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _weekDays[widget.index]
                .dishes[_weekDays[widget.index].dishes.indexOf(dish)]
                .accompaniment
                .map((acc) {
              return InkWell(
                onLongPress: () => setState(() {_weekDays[widget.index]
                    .dishes[_weekDays[widget.index].dishes.indexOf(dish)]
                    .accompaniment
                    .remove(acc);}),
                child: Text(acc.title),
              );
            }).toList(),
          ),
          trailing: TextButton(
            onPressed: () async {
              _selDishIndex = _weekDays[widget.index].dishes.indexOf(dish);

              final selAcc = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DishSelectionPage()),
              );

              if (selAcc != null) {
                setState(() => _weekDays[widget.index]
                    .dishes[_selDishIndex]
                    .accompaniment
                    .add(selAcc));
              }
            },
            child: const Text('Tilføj tilbehør'),
          ),
        ),
      );
    }).toList();
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

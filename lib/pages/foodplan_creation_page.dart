import 'dish_selection_page.dart';
import 'package:familien_pedersen_app/classes.dart';
import 'package:flutter/material.dart';

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

class FoodplanCreationPage extends StatefulWidget {
  const FoodplanCreationPage({Key? key}) : super(key: key);

  @override
  State<FoodplanCreationPage> createState() => _FoodplanCreationPageState();
}

class _FoodplanCreationPageState extends State<FoodplanCreationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save),
      ),
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
  const WeekDayBody({Key? key, required this.index}) : super(key: key);
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
      final newDish = selectedDish.clone();

      setState(() => _weekDays[_selWeekDayIndex].dishes.add(newDish));
    }
  }

  List<Dismissible> _buildDishes() {
    return _weekDays[widget.index]
        .dishes
        .asMap()
        .map((dishIndex, dish) {
          return MapEntry(
            dishIndex,
            Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  _weekDays[widget.index].dishes.remove(dish);
                });
              },
              child: ListTile(
                minVerticalPadding: 18, // Centers title vertically
                title: Text(dish.title),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _weekDays[widget.index]
                      .dishes[dishIndex]
                      .subDishes
                      .map((subDish) {
                    return InkWell(
                      onLongPress: () => setState(() {
                        _weekDays[widget.index]
                            .dishes[dishIndex]
                            .subDishes
                            .remove(subDish);
                      }),
                      child: Text(subDish.title),
                    );
                  }).toList(),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final selectedSubDish = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DishSelectionPage()),
                    );

                    if (selectedSubDish != null) {
                      final newSubDish = selectedSubDish.clone();

                      setState(() => _weekDays[widget.index]
                          .dishes[dishIndex]
                          .subDishes
                          .add(newSubDish));
                    }
                  },
                  child: const Text('Tilføj tilbehør'),
                ),
              ),
            ),
          );
        })
        .values
        .toList();
  }
}

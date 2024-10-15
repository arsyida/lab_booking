import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Home Page"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'JADWAL PENGGUNAAN',
              textAlign: TextAlign.center, // Center the text in the Text widget
            ),
            Text(
              'LAB KOMPUTER PTI',
              textAlign: TextAlign.center, // Center the text in the Text widget
            ),
          ],
        ),
        centerTitle: true, // Center the title within the AppBar
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          TableCalendar(
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LabSchedulePage(selectedDate: selectedDay),
                ),
              );
            },
            calendarFormat: CalendarFormat.month,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: const HeaderStyle(
              titleCentered: true,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BookingFormPage(selectedDate: _focusedDay)),
          );
        },
        backgroundColor: Color.fromRGBO(159, 168, 218, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LabSchedulePage extends StatefulWidget {
  final DateTime selectedDate;

  const LabSchedulePage({super.key, required this.selectedDate});

  @override
  _LabSchedulePageState createState() => _LabSchedulePageState();
}

class _LabSchedulePageState extends State<LabSchedulePage> {
  List<String> labSchedules = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchLabSchedules();
  }

  // Fetch lab schedules from API
  Future<void> fetchLabSchedules() async {
    try {
      // Assuming the API URL returns schedules based on the selected date
      final response =
          await http.get(Uri.parse('https://labooking.vercel.app/schedules'));
      if (response.statusCode == 200) {
        // Parse the JSON data
        final data = json.decode(response.body);
        setState(() {
          labSchedules = List<String>.from(
              data['schedules']); // Assuming 'schedules' is a list of strings
          isLoading = false;
          print(labSchedules);
        });
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Pemakaian Lab'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Pemakaian ${DateFormat('dd-MM-yyyy').format(widget.selectedDate)}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            // Show loading spinner or data
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? const Center(child: Text('Failed to load schedules.'))
                    : labSchedules.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: labSchedules.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.access_time),
                                  title: Text(labSchedules[index]),
                                );
                              },
                            ),
                          )
                        : const Text(
                            'Tidak ada jadwal pemakaian untuk tanggal ini.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookingFormPage(selectedDate: widget.selectedDate),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(159, 168, 218, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BookingFormPage extends StatefulWidget {
  final DateTime selectedDate;

  const BookingFormPage({super.key, required this.selectedDate});

  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _angkatanController = TextEditingController();
  final TextEditingController _kegiatanController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _mulaiController = TextEditingController();
  final TextEditingController _selesaiController = TextEditingController();
  final TextEditingController _dosenController = TextEditingController();

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final DateTime now = DateTime.now();
      final DateTime fullPickedTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      final String formattedTime = DateFormat('HH:mm').format(fullPickedTime);
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Booking Laboratorium Komputer PTI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib di isi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _angkatanController,
                decoration: const InputDecoration(labelText: 'Angkatan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib di isi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mulaiController,
                decoration: const InputDecoration(labelText: 'Waktu Mulai'),
                readOnly: true,
                onTap: () => _selectTime(_mulaiController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib di isi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _selesaiController,
                decoration: const InputDecoration(labelText: 'Waktu Selesai'),
                readOnly: true,
                onTap: () => _selectTime(_selesaiController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib di isi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kegiatanController,
                decoration: const InputDecoration(labelText: 'Kegiatan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib di isi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _teleponController,
                decoration: const InputDecoration(labelText: 'Telepon'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib di isi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dosenController,
                decoration: const InputDecoration(labelText: 'Dosen Pengampu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib di isi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Tanggal Booking: ${DateFormat('dd-MM-yyyy').format(widget.selectedDate)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Booking berhasil ditambahkan!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

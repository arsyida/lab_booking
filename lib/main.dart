import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JADWAL PENGGUNAAN LAB KOMPUTER PTI'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          TableCalendar(
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
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
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
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LabSchedulePage extends StatelessWidget {
  final DateTime selectedDate;

  const LabSchedulePage({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final List<String> labSchedules = [
      '08:00 - 09:00: Lab A - Pemrograman Dasar',
      '10:00 - 11:00: Lab B - Jaringan Komputer',
      '13:00 - 14:00: Lab A - Basis Data',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Pemakaian ${selectedDate.toLocal()}'.split(' ')[0]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal pemakaian lab:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            labSchedules.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: labSchedules.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(labSchedules[index]),
                      );
                    },
                  )
                : const Text('Tidak ada jadwal pemakaian untuk tanggal ini.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingFormPage(
                selectedDate: selectedDate,
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BookingFormPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _angkatanController = TextEditingController();
  final TextEditingController _kegiatanController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _mulaiController = TextEditingController();
  final TextEditingController _selesaiController = TextEditingController();
  final TextEditingController _dosenController = TextEditingController();
  final DateTime selectedDate;

  BookingFormPage({super.key, required this.selectedDate});

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
                'Tanggal Booking: ${selectedDate.toLocal()}'.split(' ')[0],
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

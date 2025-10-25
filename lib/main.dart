import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactListPage(),
    );
  }
}

class ContactListPage extends StatelessWidget {
  ContactListPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Dummy list data for UI only
  final List<Map<String, String>> contacts = [
    {"name": "Jawad", "phone": "01877-777777"},
    {"name": "Ferdous", "phone": "01673-777777"},
    {"name": "Hasan", "phone": "01745-777777"},
    {"name": "Hasan", "phone": "01745-777777"},
    {"name": "Hasan", "phone": "01745-777777"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            // Add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Add"),
              ),
            ),
            const SizedBox(height: 16),
            // Contact list
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        contact["name"]!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.brown),
                      ),
                      subtitle: Text(contact["phone"]!),
                      trailing: const Icon(Icons.call, color: Colors.blue),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class Planetchoice extends StatefulWidget {
  final String userEmail;

  const Planetchoice({super.key, required this.userEmail});

  @override
  _Planetchoice createState() => _Planetchoice();
}

class _Planetchoice extends State<Planetchoice> {
  late Future<List<Map<String, dynamic>>> searchData;
  List<Map<String, dynamic>> originalData = [];
  List<Map<String, dynamic>> selectedPlanets = [];
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    searchData = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.0.106:4000/api/data'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Map<String, dynamic>> mappedData =
            jsonData.cast<Map<String, dynamic>>();
        originalData = mappedData;
        return mappedData;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      throw Exception('Error during HTTP request: $error');
    }
  }

  void toggleSelection(Map<String, dynamic> planet) {
    setState(() {
      if (selectedPlanets.contains(planet)) {
        selectedPlanets.remove(planet);
      } else {
        if (selectedPlanets.length < 4) {
          selectedPlanets.add(planet);
        } else {
          // You can show a message to the user here that they can only select up to 4 planets
          // or implement any other behavior you desire
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Conquer Planets'),
        ),
        body: FutureBuilder(
          future: searchData,
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> planet = snapshot.data![index];
                  bool isSelected = selectedPlanets.contains(planet);
                  return ListTile(
                    title: Text(planet['PlanetName']),
                    subtitle: Text(
                        'Energon: ${planet['EnergonProduction']}, Materials: ${planet['MaterialProduction']}'),
                    onTap: () => toggleSelection(planet),
                    leading: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.circle_outlined),
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: selectedPlanets.length == 4
            ? FloatingActionButton(
                onPressed: () async {
                  final userEmail = widget.userEmail;
                  final planetsData = selectedPlanets
                      .map((planet) => {'PlanetId': planet['PlanetId']})
                      .toList();

                  try {
                    final response = await http.post(
                      Uri.parse('http://192.168.0.106:4000/api/conquer'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode(
                          {'Email': userEmail, 'Planets': planetsData}),
                    );

                    if (response.statusCode == 201) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()),
                      );
                    } else if (response.statusCode == 401) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.thumb_down,
                                  color: Colors.deepOrange[300]),
                              const SizedBox(width: 30),
                              const Text('At least one Planet already conquered, choose another'),
                            ],
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ),
                      );
                    } else {
                      // Handle other status codes
                      print('Error: ${response.statusCode}');
                    }
                  } catch (error) {
                    // Handle network errors
                    print('Error: $error');
                  }
                },
                child: const Icon(Icons.check),
              )
            :null
      ),
    );
  }
}

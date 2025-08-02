import "dart:convert";
import "dart:ui";
import "package:flutter/material.dart";
import "package:whether_app/additional_items.dart";
import "package:whether_app/Apikey.dart";
import "package:whether_app/hourly_forecast_item.dart";
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class WhetherScreen extends StatefulWidget {
  const WhetherScreen({super.key});

  @override
  State<WhetherScreen> createState() => _WhetherScreenState();
}

class _WhetherScreenState extends State<WhetherScreen> {
  String cityName = 'Delhi';

  @override
  void initState() {
    super.initState();
    getWhetherData();
  }

  Future<Map<String, dynamic>> getWhetherData() async {
    try {
      final response = await http.get(Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=3&aqi=no&alerts=no",
      ));

      final data = jsonDecode(response.body);

      if (data.containsKey("error")) {
        throw data["error"]["message"];
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  void changeCity() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter City Name'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Mumbai',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('City name cannot be empty')),
                  );
                  return;
                }

                setState(() {
                  cityName = controller.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getWhetherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      changeCity(); // user ko dobara input dene ka option
                    },
                    child: const Text("Change City"),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          List hours = data['forecast']['forecastday'][0]['hour'];

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                const Text(
                                  "Average Temperature",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "${data['forecast']['forecastday'][0]['day']['avgtemp_c']}°c",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                                Icon(
                                  data['forecast']['forecastday'][0]['day']
                                              ['condition']['text'] ==
                                          "Sunny"
                                      ? Icons.sunny
                                      : Icons.cloud,
                                  size: 64,
                                ),
                                Text(
                                  data['forecast']['forecastday'][0]['day']
                                      ['condition']['text'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                TextButton(
                                    onPressed: () => changeCity(),
                                    child: Text(cityName))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < hours.length; i += 2)
                          HourlyForecast(
                            time: hours[i]['time'].split(" ")[1],
                            icon: hours[i]['condition']['text'] == "Sunny"
                                ? Icons.sunny
                                : Icons.cloud,
                            temperature: "${hours[i]['temp_c']}°c",
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Additionalltems(
                          icon: Icons.water_drop,
                          condition: "Humidity",
                          value: data['current']['humidity'].toString()),
                      Additionalltems(
                        icon: Icons.air,
                        condition: "Wind Speed",
                        value: data['current']['wind_kph'].toString(),
                      ),
                      Additionalltems(
                        icon: Icons.umbrella,
                        condition: "Pressure",
                        value: data['current']['pressure_in'].toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

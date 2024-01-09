import "../models/bloodsugar.dart";
import '../componets/sidebar.dart';
class HomeScreen extends StatefulWidget {
  @override
  _BloodSugarTrackerScreenState createState() => _BloodSugarTrackerScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Record> bloodSugarRecords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Sugar Tracker'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the add record screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRecordScreen()),
              ).then((newRecord) {
                if (newRecord != null) {
                  setState(() {
                    bloodSugarRecords.add(newRecord);
                  });
                }
              });
            },
            child: Text('Add Blood Sugar Record'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bloodSugarRecords.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Blood Sugar: ${bloodSugarRecords[index].bloodSugar} mg/dL'),
                  subtitle: Text('Carbs: ${bloodSugarRecords[index].carbs} grams'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

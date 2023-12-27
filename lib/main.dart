import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> options = [];
  dynamic jsonResult;
  dynamic loanSchema;
  dynamic selectedValue;
  Color primaryColor = Colors.orange;
  bool viewAbout = false;

  Future<void> readJson() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/Questions.json");
    setState(() {
      jsonResult = jsonDecode(data);
    });
  }

  bool selectValue(e) {
    return e['value'] == selectedValue;
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  void handleTap(dynamic e) {
    if (e['type'] == 'Section') {
      if (e['schema'] != null && e['schema']['options'] != null) {
        setState(() {
          options = e['schema']['options'];
        });
        print(options);
      } else {
        setState(() {
          loanSchema = e['schema'];
        });
      }
    } else {
      if (e['schema'] != null && e['schema']['options'] != null) {
        setState(() {
          options = e['schema']['options'];
        });
        print(options);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(size.height * 0.05),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              jsonResult['title'],
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .merge(TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          options.isEmpty
              ? Center(
                  child: loanSchema == null
                      ? _buildQuestionnaire(jsonResult['schema'])
                      : _buildQuestionnaire(loanSchema),
                )
              : aboutLoan()
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            loanSchema != null || options.isNotEmpty
                ? TextButton.icon(
                    onPressed: () {
                      if (loanSchema != null) {
                        setState(() {
                          loanSchema = null;
                        });
                      }
                      if (options.isNotEmpty) {
                        setState(() {
                          options.clear();
                          readJson();
                        });
                      }
                    },
                    icon: Icon(Icons.arrow_back_ios),
                    label: Text('Back'))
                : SizedBox(),
            IconButton(
                style: IconButton.styleFrom(shape: CircleBorder()),
                onPressed: () {},
                icon: Icon(Icons.arrow_forward_ios))
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionnaire(dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (data['fields'] as List<dynamic>).map<Widget>((e) {
        return InkWell(
          onTap: () {
            handleTap(e);
          },
          child: Container(
            height: 50,
            margin: EdgeInsets.all(8.0),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e['schema']['label'] ?? 'Label Not Found'),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget aboutLoan() {
    return Container(
      width: double.infinity,
      child: Container(
        child: Column(
          children: (options ?? []).map<Widget>((e) {
            return Container(
              margin: EdgeInsets.all(8.0),
              height: 50,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(
                    color: selectValue(e) ? primaryColor : Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: RadioListTile(
                activeColor: primaryColor,
                value: e['value'],
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
                title: Text('${e['value']}',
                    style: TextStyle(
                        color: selectValue(e) ? primaryColor : Colors.black)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

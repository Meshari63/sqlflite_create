import 'package:dog_exaple/sqldb.dart';
import 'package:flutter/material.dart';

TextEditingController dogName = TextEditingController();
TextEditingController dogAge = TextEditingController();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqlDb = SqlDb();

  Future<List<Map>> readData() async {
    List<Map> response = await sqlDb.readDate("SELECT * FROM dogs");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dog Example"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          opneDialog();
        },
        label: const Text('ADD'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        child: ListView(
          children: [
            FutureBuilder(
              builder:
                  (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                              title: Text(snapshot.data![index]['dogname']),
                              subtitle: Text(snapshot.data![index]['dogage']),
                              leading: CircleAvatar(
                                  child: IconButton(
                                      onPressed: () {
                                        edit(
                                            snapshot.data![index]['id'],
                                            snapshot.data![index]['dogname'],
                                            snapshot.data![index]['dogage']);
                                      },
                                      icon: const Icon(Icons.edit))),
                              trailing: CircleAvatar(
                                backgroundColor: Colors.red[400],
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                         sqlDb.deleteDate(
                                            "DELETE FROM 'dogs' WHERE id = ${snapshot.data![index]['id']}");
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    )),
                              )),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: readData(),
            ),
          ],
        ),
      ),
    );
  }

  Future opneDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Add new dog"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Dog Name",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: dogName,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Dog Age",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  controller: dogAge,
                ),
              ],
            ),
            actions: [
              MaterialButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                onPressed: () {
                  String DogName = dogName.text;
                  String DogAge = dogAge.text;
                  setState(() {
                    sqlDb.insertDate(
                        "INSERT INTO 'dogs' ('dogname', 'dogage') VALUES ('$DogName', '$DogAge')");
                  });
                  dogName.clear();
                  dogAge.clear();
                  Navigator.of(context).pop();
                },
                child: const Text("Insert Data"),
              ),
            ],
          ));
  Future edit(index, DogNameUpdate, DogAgeUpdate) {
    dogName.text = DogNameUpdate;
    dogAge.text = DogAgeUpdate;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add new dog"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Dog Name",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: dogName,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Dog Age",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: dogAge,
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                  onPressed: () {
                    String DogName = dogName.text;
                    String DogAge = dogAge.text;
                    print(index);
                    setState(() {
                      sqlDb.updateDate(
                          "UPDATE dogs SET 'dogage' = '$DogAge' ,'dogname' = '$DogName' WHERE id = $index");
                    });

                    dogName.clear();
                    dogAge.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Update Data"),
                ),
              ],
            ));
  }
}

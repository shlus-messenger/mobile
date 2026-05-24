import 'package:flutter/material.dart';

class CommunicationScreen extends StatefulWidget {

  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();

}

class _CommunicationScreenState extends State<CommunicationScreen> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Новое сообщение",
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              height: 40,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Поиск контактов",
                  hintStyle: TextStyle(
                    fontSize: 14
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  )

                ),
              )
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.group),
                        const SizedBox(width: 10),
                        Text(
                          "Создать группу"
                        )
                      ],
                    )
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.speaker),
                        const SizedBox(width: 10),
                        Text(
                          "Создать группу"
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Text(
                      "test",
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              )
            )
          ],
        )
      )
    );
  }
}
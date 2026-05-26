import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shlus/ui/screens/new_group_screen.dart';
import 'package:shlus/ui/widgets/input_component.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CommunicationScreen extends StatefulWidget {

  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();

}

class _CommunicationScreenState extends State<CommunicationScreen> {

	late StreamSubscription<List<ConnectivityResult>> _subscription;
	String _appBarText = "Соединение...";

	void _showBottomSheet(BuildContext context) {

		showModalBottomSheet(
			context: context,
			shape: const RoundedRectangleBorder(
				borderRadius: BorderRadius.vertical(top: Radius.circular(20))
			),
			builder: (BuildContext context) {
				return Container(
					padding: EdgeInsets.all(20),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.start,
						mainAxisSize: MainAxisSize.min,
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
							Align(
								alignment: Alignment.centerLeft,
								child: const Text(
									"Новый контакт",
									textAlign: TextAlign.start,
									style: TextStyle(
										fontWeight: FontWeight.w500,
										fontSize: 20
									)
								),
							),
							const SizedBox(height: 20),
							InputComponent(
								placeholder: "Имя (обязательно)",
							),
							const SizedBox(height: 20),
							InputComponent(
								placeholder: "Фамилия (необязательно)",
							),
							const SizedBox(height: 20),
							InputComponent(
								placeholder: "Номер телефона",
							),
							const SizedBox(height: 20),
							InkWell(
								onTap: () {
									Navigator.pop(context);
								},
								child: Container(
									alignment: Alignment.center,
									padding: EdgeInsets.symmetric(vertical: 10),
									decoration: BoxDecoration(
										borderRadius: BorderRadius.circular(5),
										color: Colors.blue,
									),
									child: Text(
										"Создать контакт",
										style: TextStyle(
											color: Colors.white,
											fontSize: 16,
											fontWeight: FontWeight.w500
										)
									),
								),
							),
							const SizedBox(height: 20),
						],
					)
				);
			}
		);
	}

	@override
	void initState() {

		super.initState();


		_subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {

			print("Колбек вызван");

			setState(() {
				_appBarText = result.contains(ConnectivityResult.none) ? "Соединение..." : "Новое сообщение";
			});

		});

	}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appBarText,
          style: TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
				elevation: 0,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _showBottomSheet(context),
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
										onTap: () {
											Navigator.push(
												context,
												MaterialPageRoute(
													builder: (context) => NewGroupScreen()
												)
											);
										},
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
            Container(
							padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
							decoration: BoxDecoration(
									color: Colors.white,
							),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										"Сортировка по имени",
										textAlign: TextAlign.start,
										style: TextStyle(
											color: Colors.blue,
											fontWeight: FontWeight.w500
										)
									),
									const SizedBox(height: 10),
									ListView.builder(
										shrinkWrap: true,
										itemCount: 20,
										itemBuilder: (context, index) {
												return Text(
														"test",
														textAlign: TextAlign.center,
												);
										},
									),
								],
							)
            )
          ],
        )
      )
    );
  }
}
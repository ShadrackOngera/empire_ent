import 'package:empire_ent/database/database.dart';
import 'package:empire_ent/utils/widget_helper.dart';
import 'package:empire_ent/widgets/primary_button.dart';
import 'package:empire_ent/widgets/primary_text.dart';
import 'package:empire_ent/widgets/primary_text_field.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController ticketId = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  final saveDetailsKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        // title: ,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: saveDetailsKey,
          child: Column(
            children: [
              PrimaryTextField(
                obsecureText: false,
                controller: ticketId,
                hintText: 'Ticket Id',
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryTextField(
                obsecureText: false,
                controller: phoneNumber,
                hintText: 'Phone Number',
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                onTap: () {
                  if (saveDetailsKey.currentState!.validate()) {
                    Database()
                        .saveTicket(ticketId.text, phoneNumber.text)
                        .then((value) {
                      WidgetHelper.snackbar(
                        "Great",
                        'Saved',
                      );
                    });
                  }
                },
                child: PrimaryText(
                  text: 'save',
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:expense_app2/components/expense_summary.dart';
import 'package:expense_app2/components/expense_tile.dart';
import 'package:expense_app2/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_app2/data/expense_data.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //prepare data
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: 'Food, shoes, grocery etc....',
                label: Text('Expense Name'),
              ),
            ),

            //expense amount
            TextField(
              controller: newExpenseAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '\$12.99',
                label: Text('Amount'),
              ),
            ),
          ],
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: save,
            padding: const EdgeInsets.all(10),
            elevation: 10,
            child: const Text('Save'),
          ),

          //cancel button
          MaterialButton(
            onPressed: cancel,
            padding: const EdgeInsets.all(10),
            elevation: 10,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  //delete expense
  void deleteExpense(ExpenseItem expense)
  {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    if(newExpenseNameController.text.isNotEmpty && newExpenseAmountController.text.isNotEmpty)
      {
        ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: newExpenseAmountController.text,
          dateTime: DateTime.now(),
        );

        //add the new expense
        Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
        Navigator.pop(context);
        clear();
      }
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            shape: const CircleBorder(eccentricity: 1),
            backgroundColor: Colors.purple[300],
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: [
              //weekly summary
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),

              const SizedBox(
                height: 20,
              ),

              //expense tile
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped : (p0) => deleteExpense(value.getAllExpenseList()[index]) ,
                ),
                itemCount: value.getAllExpenseList().length,
              ),
            ],
          )),
    );
  }
}

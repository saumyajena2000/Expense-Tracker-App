
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_app2/models/expense_item.dart';

class HiveDataBase {
  //reference our hive box
  final _myBox = Hive.box("expense_database");

  //write data
  void saveData(List<ExpenseItem> allExpense) {
    /*
    Hive can store only strings and dateTime, and not custom objects like ExpenseItem
     Convert ExpenseItem objects into a list of types that can be stored in Hive
     */

    List<List<dynamic>> allExpenseFormatted = [];

    for (var expense in allExpense) {
      //convert each list item into a list of storable types(strings, dateTime)
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];

      allExpenseFormatted.add(expenseFormatted);
    }

    //finally store in DB
    _myBox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  //read data
  List<ExpenseItem> readData() {
    /*
    convert Hive DB format to ExpenseItem objects
     */
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      //collect individual expense dat
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      //create expense item
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      //add expense to overall list of expenses
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}

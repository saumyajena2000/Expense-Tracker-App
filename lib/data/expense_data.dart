import 'package:expense_app2/data/hive_database.dart';
import 'package:expense_app2/datetime/date_time_helper.dart';
import 'package:expense_app2/models/expense_item.dart';
import 'package:flutter/cupertino.dart';

class ExpenseData extends ChangeNotifier{
  //list of all Expenses
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  //prepare data to display
  final db = HiveDataBase();
  void prepareData() {
    // if there exists data , collect it
    if(db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add  new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday(mon, tues, etc) from a datetime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  //get the date for the start of the week (sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    //get today's date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sunday') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  /*
  convert overall list of expenses into a daily expense summary

  e.g
  overallExpenseList =
  [

    [food,02/07/2023, $10],
    [meat,02/07/2023, $15],
    [shoes, 03/07/2023, $50],
    [groceries, 03/07/23, $15],

  ]

  ->

  Daily Expense Summary =
  [
    [02/07/23: $25]
    [03/07/23: $65]

   */

Map<String, double> calculateDailyExpenseSummary() {
  Map<String, double> dailyExpenseSummary = {
    // date (dd/mm/yyyy) : amountTotalForDay
  };

  for(var expense in overallExpenseList) {
    String date = convertDateTimeToString(expense.dateTime);
    double amount = double.parse(expense.amount);

    if(dailyExpenseSummary.containsKey(date))
      {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      }
    else
      {
        dailyExpenseSummary.addAll({date: amount});
      }
  }
  return dailyExpenseSummary;
}
}

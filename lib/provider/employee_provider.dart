import 'dart:convert';
import 'package:genesis_packaging_v2/models/employee.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EmployeeProvider with ChangeNotifier {
// setter
  List<Employee> _workers = [];

// getter
  List<Employee> get worker {
    return [..._workers];
  }

  Employee findById(String? id) {
    return _workers.firstWhere((prod) => prod.id! == id!);
  }

  Future<void> fetchAndSetEmployee() async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/employees.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Employee> loadedEmployee = [];
      extractedData.forEach((empId, empData) {
        loadedEmployee.add(Employee(
          id: empId,
          name: empData['name'],
          gender: empData['gender'],
          startTime: empData['startTime'],
          endTime: empData['endTime'],
          wages: empData['wages'],
          overTime: empData['overTime'],
          dateTime: empData['dateTime'],
        ));
      });
      _workers = loadedEmployee;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addEmployee(Employee employee) async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/employees.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'name': employee.name,
          'gender': employee.gender,
          'startTime': employee.startTime,
          'endTime': employee.endTime,
          'wages': employee.wages,
          'dateTime': employee.dateTime,
          'overTime': employee.overTime,
        }),
      );
      final newEmployee = Employee(
        id: json.decode(response.body)['name'],
        name: employee.name,
        gender: employee.gender,
        startTime: employee.startTime,
        endTime: employee.endTime,
        wages: employee.wages,
        overTime: employee.overTime,
        dateTime: employee.dateTime,
      );
      _workers.add(newEmployee);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateEmployee(String id, Employee newEmployee) async {
    final employeeIndex = _workers.indexWhere((emp) => emp.id == id);
    try {
      if (employeeIndex >= 0) {
        final url =
            'https://genesispackaging-9905b-default-rtdb.firebaseio.com/employees/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'name': newEmployee.name,
              'gender': newEmployee.gender,
              'startTime': newEmployee.startTime,
              'endTime': newEmployee.endTime,
              'wages': newEmployee.wages,
              'dateTime': newEmployee.dateTime,
              'overTime': newEmployee.overTime,
            }));
        _workers[employeeIndex] = newEmployee;
        notifyListeners();
      } 
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteEmployee(String id) async {
    final url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/employees/$id.json';
    try {
      final exsistingEmployeeIndex = _workers.indexWhere((emp) => emp.id == id);
      dynamic exsistingEmployee = _workers[exsistingEmployeeIndex];
      _workers.removeAt(exsistingEmployeeIndex);
      notifyListeners();
      // _items.removeWhere((prod) => prod.id == id);
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        _workers.insert(exsistingEmployeeIndex, exsistingEmployee);
        notifyListeners();
      }
      exsistingEmployee = null;
    } catch (error) {
      rethrow;
    }
  }
}

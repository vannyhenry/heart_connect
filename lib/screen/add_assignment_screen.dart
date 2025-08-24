// lib/screens/add_assignment_screen.dart
// YOUR PART - Add Assignment Page with Edit/Delete functionality

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/assignment.dart';

class AddAssignmentScreen extends StatefulWidget {
  final Assignment? assignment; // For editing existing assignments

  const AddAssignmentScreen({Key? key, this.assignment}) : super(key: key);

  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  String _priority = 'medium';
  String _status = 'pending';
  bool _isLoading = false;
  bool get isEditing => widget.assignment != null;

  @override
  void initState() {
    super.initState();
    // If editing, populate fields with existing data
    if (isEditing) {
      _titleController.text = widget.assignment!.title;
      _subjectController.text = widget.assignment!.subject;
      _descriptionController.text = widget.assignment!.description;
      _selectedDate = widget.assignment!.dueDate;
      _priority = widget.assignment!.priority;
      _status = widget.assignment!.status;
    }
  }

  // CORE FUNCTIONALITY: Save Assignment (Create/Update)
  Future<void> _saveAssignment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          _showSnackBar('User not authenticated', Colors.red);
          return;
        }

        final assignmentData = {
          'title': _titleController.text.trim(),
          'subject': _subjectController.text.trim(),
          'description': _descriptionController.text.trim(),
          'dueDate': Timestamp.fromDate(_selectedDate),
          'priority': _priority,
          'status': _status,
          'userId': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (isEditing) {
          // UPDATE existing assignment
          await FirebaseFirestore.instance
              .collection('assignments')
              .doc(widget.assignment!.id)
              .update(assignmentData);
          
          _showSnackBar('Assignment updated successfully!', Colors.green);
        } else {
          // CREATE new assignment
          assignmentData['createdAt'] = FieldValue.serverTimestamp();
          await FirebaseFirestore.instance
              .collection('assignments')
              .add(assignmentData);
          
          _showSnackBar('Assignment added successfully!', Colors.green);
          _clearForm(); // Clear form after adding
        }

      } catch (e) {
        _showSnackBar('Error: ${e.toString()}', Colors.red);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // DELETE functionality
  Future<void> _deleteAssignment() async {
    if (!isEditing) return;

    final confirmed = await _showDeleteConfirmation();
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('assignments')
          .doc(widget.assignment!.id)
          .delete();
      
      _showSnackBar('Assignment deleted successfully!', Colors.green);
      Navigator.pop(context); // Go back after deletion
      
    } catch (e) {
      _showSnackBar('Error deleting assignment: ${e.toString()}', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Date and Time picker
  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFF4F63FE)),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: Color(0xFF4F63FE)),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  // Helper methods
  void _clearForm() {
    _titleController.clear();
    _subjectController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedDate = DateTime.now().add(Duration(days: 1));
      _priority = 'medium';
      _status = 'pending';
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Assignment'),
          ],
        ),
        content: Text('Are you sure you want to delete "${widget.assignment!.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Assignment' : 'Add Assignment'),
        backgroundColor: Color(0xFF4F63FE),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _isLoading ? null : _deleteAssignment,
              icon: Icon(Icons.delete),
              tooltip: 'Delete Assignment',
            ),
          IconButton(
            onPressed: _isLoading ? null : _saveAssignment,
            icon: Icon(Icons.save),
            tooltip: 'Save Assignment',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4F63FE), Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                if (isEditing)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Colors.blue[50]!, Colors.white],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.edit, color: Color(0xFF4F63FE)),
                              SizedBox(width: 8),
                              Text(
                                'Editing Assignment',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4F63FE),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Make changes to "${widget.assignment!.title}" below',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                SizedBox(height: 16),

                // Basic Information Card
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📝 Basic Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F63FE),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Title Field
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Assignment Title *',
                            hintText: 'e.g., Math Homework Chapter 5',
                            prefixIcon: Icon(Icons.assignment, color: Color(0xFF4F63FE)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF4F63FE), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter assignment title';
                            }
                            if (value.trim().length < 3) {
                              return 'Title must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Subject Field
                        TextFormField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            labelText: 'Subject/Course *',
                            hintText: 'e.g., Mathematics, English, Science',
                            prefixIcon: Icon(Icons.school, color: Color(0xFF4F63FE)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF4F63FE), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter subject/course';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Description Field
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description (Optional)',
                            hintText: 'Add any additional details about the assignment...',
                            prefixIcon: Icon(Icons.description, color: Color(0xFF4F63FE)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF4F63FE), width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 16),

                // Due Date Card
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📅 Due Date & Time',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F63FE),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        InkWell(
                          onTap: _selectDateTime,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[50],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, color: Color(0xFF4F63FE)),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Due Date & Time',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        _formatDateTime(_selectedDate),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.edit, color: Colors.grey[400]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 16),

                // Priority & Status Card
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '⚡ Priority & Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F63FE),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Priority Selection
                        Text(
                          'Priority Level',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        
                        Row(
                          children: ['low', 'medium', 'high'].map((priority) {
                            final isSelected = _priority == priority;
                            final color = _getPriorityColor(priority);
                            
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  onTap: () => setState(() => _priority = priority),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
                                      border: Border.all(
                                        color: isSelected ? color : Colors.grey[300]!,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          priority == 'high' ? Icons.arrow_upward :
                                          priority == 'medium' ? Icons.remove :
                                          Icons.arrow_downward,
                                          color: isSelected ? color : Colors.grey[600],
                                          size: 20,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          priority.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? color : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Status Dropdown
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        
                        DropdownButtonFormField<String>(
                          value: _status,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF4F63FE), width: 2),
                            ),
                            prefixIcon: Icon(Icons.flag, color: Color(0xFF4F63FE)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'pending',
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Pending'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'in-progress',
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('In Progress'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'completed',
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Completed'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _status = value!);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    if (isEditing) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _deleteAssignment,
                          icon: _isLoading 
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Icon(Icons.delete),
                          label: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                    ],
                    
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _saveAssignment,
                        icon: _isLoading 
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Icon(isEditing ? Icons.update : Icons.add),
                        label: Text(
                          isEditing ? 'Update Assignment' : 'Add Assignment',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4F63FE),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (!isEditing) ...[
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: _clearForm,
                      icon: Icon(Icons.clear_all),
                      label: Text('Clear Form'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
                
                SizedBox(height: 32), // Extra space at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

// lib/models/assignment.dart
// Simple Assignment model for your part

class Assignment {
  final String? id;
  final String title;
  final String subject;
  final String description;
  final DateTime dueDate;
  final String priority; // 'low', 'medium', 'high'
  final String status;   // 'pending', 'in-progress', 'completed'
  final String userId;

  Assignment({
    this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.userId,
  });

  // Create Assignment from Firestore document
  factory Assignment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Assignment(
      id: doc.id,
      title: data['title'] ?? '',
      subject: data['subject'] ?? '',
      description: data['description'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: data['priority'] ?? 'medium',
      status: data['status'] ?? 'pending',
      userId: data['userId'] ?? '',
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/event_bloc.dart';
import '../../blocs/event_event.dart';
import '../../blocs/event_state.dart';
import '../../models/event_model.dart';

class AddEventScreen extends StatefulWidget {
  final Event? event;

  const AddEventScreen({
    super.key,
    this.event,
  });

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _imageUrlController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.event?.description ?? '');
    _locationController =
        TextEditingController(text: widget.event?.location ?? '');
    _dateController = TextEditingController();
    _imageUrlController =
        TextEditingController(text: widget.event?.imageUrl ?? '');

    if (widget.event != null) {
      _selectedDate = widget.event!.date;
      _dateController.text = _formatDate(widget.event!.date);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _handleSaveEvent() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (widget.event != null) {
        // Update event
        context.read<EventBloc>().add(
              UpdateEventEvent(
                eventId: widget.event!.id,
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
                location: _locationController.text.trim(),
                date: _selectedDate!,
                imageUrl: _imageUrlController.text.trim(),
              ),
            );
      } else {
        // Create new event
        context.read<EventBloc>().add(
              CreateEventEvent(
                title: _titleController.text.trim(),
                description: _descriptionController.text.trim(),
                location: _locationController.text.trim(),
                date: _selectedDate!,
                imageUrl: _imageUrlController.text.trim(),
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event != null ? 'Edit Event' : 'Add New Event'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Event saved successfully'),
              ),
            );
            Navigator.pop(context);
          } else if (state is EventFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                Text(
                  'Event Title',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter event title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.event),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Event title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Event Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter event description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Event Location
                Text(
                  'Location',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Enter event location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Location is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Event Date
                Text(
                  'Date',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Select event date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Image URL
                Text(
                  'Image URL',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    hintText: 'Enter image URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.image),
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    if (widget.event != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showDeleteConfirmation();
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    if (widget.event != null) const SizedBox(width: 12),
                    Expanded(
                      child: BlocBuilder<EventBloc, EventState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed:
                                state is EventLoading ? null : _handleSaveEvent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                            ),
                            child: state is EventLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    widget.event != null
                                        ? 'Update Event'
                                        : 'Create Event',
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<EventBloc>().add(DeleteEventEvent(widget.event!.id));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

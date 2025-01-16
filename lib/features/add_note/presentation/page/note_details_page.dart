import 'dart:math';

import 'package:diary/features/add_note/presentation/bloc/add_note/add_note_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/date_time_format.dart';
import '../../domain/entity/note_entity.dart';
import '../bloc/add_note/add_note_cubit.dart';
import '../bloc/get_note/get_note_cubit.dart';
import '../bloc/update_note/update_note_cubit.dart';
import '../bloc/update_note/update_note_state.dart';

class NoteDetailsPage extends StatefulWidget {
  const NoteDetailsPage({super.key, this.noteId, this.description, this.title});
  final int? noteId;
  final String? description;
  final String? title;

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _updateNoteCubit = getIt<UpdateNoteCubit>();
  final _addNoteCubit = getIt<AddNoteCubit>();
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title ?? '';
    _descriptionController.text = widget.description ?? '';
  }

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _descriptionController.dispose();
  //   _updateNoteCubit.close();
  //   _addNoteCubit.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _title(size),
                    const SizedBox(height: 20),
                    _description(size),
                    const SizedBox(height: 20),
                    BlocBuilder<UpdateNoteCubit, UpdateNoteState>(
                      bloc: _updateNoteCubit,
                      builder: (context, state) {
                        if (state is UpdateNoteLoading) {
                          return const CircularProgressIndicator();
                        }
                        if (state is UpdateNoteSuccess) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          });
                          // Navigator.pop(context);
                        }
                        if (state is UpdateNoteFailure) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          });
                        }
                        return _save();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _save() {
    return ElevatedButton(
      onPressed: () {
        if (widget.noteId != null &&
            _titleController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty) {
          _updateNoteCubit.updateNote(
            NoteEntity(
              id: widget.noteId!,
              title: _titleController.text,
              description: _descriptionController.text,
              createdAt: '',
            ),
          );
        } else if (_titleController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty) {
          _addNoteCubit.addNote(
            NoteEntity(
              title: _titleController.text,
              description: _descriptionController.text,
              createdAt: DateTimeFormat.getPrettyDate(
                DateTime.now(),
              ),
            ),
          );
          // Navigator.pop(context);
        }
      },
      child: BlocBuilder<AddNoteCubit, AddNoteState>(
        bloc: _addNoteCubit,
        builder: (context, state) {
          if (state is AddNoteLoading) {
            return const CircularProgressIndicator(color: Colors.white);
          }
          if (state is AddNoteFailure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            });
          }
          if (state is AddNoteSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            });
          }
          return const Text('Save', style: TextStyle(color: Colors.white));
        },
      ),
    );
  }

  SizedBox _description(Size size) {
    return SizedBox(
      height: min(size.height, size.width) * 0.5,
      child: TextField(
        maxLines: 20,
        controller: _descriptionController,
        decoration: const InputDecoration(
          labelText: 'Description',
        ),
      ),
    );
  }

  SizedBox _title(Size size) {
    return SizedBox(
      child: TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Title',
        ),
      ),
    );
  }
}

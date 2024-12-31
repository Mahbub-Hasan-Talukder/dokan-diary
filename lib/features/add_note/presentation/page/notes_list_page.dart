import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/delete_note/delete_note_cubit.dart';
import '../bloc/delete_note/delete_note_state.dart';
import '../bloc/get_note/get_note_cubit.dart';

import '../widget/view_notes.dart';
import 'note_details_page.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  final GetNoteCubit _getNoteCubit = getIt.get<GetNoteCubit>();
  final DeleteNoteCubit _deleteNoteCubit = getIt.get<DeleteNoteCubit>();
  @override
  void initState() {
    _getNoteCubit.getNotes();

    super.initState();
  }

  @override
  void dispose() {
    _getNoteCubit.close();
    _deleteNoteCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteDetailsPage()),
          ).then((value) {
            _getNoteCubit.getNotes();
          });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _deleteNoteCubit,
          child: BlocBuilder<DeleteNoteCubit, DeleteNoteState>(
            bloc: _deleteNoteCubit,
            builder: (context, state) {
              if (state is DeleteNoteLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is DeleteNoteFailure) {
                return Center(
                  child: Text(state.message),
                );
              }
              if (state is DeleteNoteSuccess) {
                _getNoteCubit.getNotes();
              }
              return Column(
                children: [
                  ViewNotes(
                    deleteNoteCubit: _deleteNoteCubit,
                    getNoteCubit: _getNoteCubit,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

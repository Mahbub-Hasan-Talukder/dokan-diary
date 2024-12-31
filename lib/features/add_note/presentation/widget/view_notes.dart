import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/note_entity.dart';
import '../bloc/delete_note/delete_note_cubit.dart';
import '../bloc/get_note/get_note_cubit.dart';
import '../bloc/get_note/get_note_state.dart';
import '../page/note_details_page.dart';

class ViewNotes extends StatefulWidget {
  final DeleteNoteCubit deleteNoteCubit;
  final GetNoteCubit getNoteCubit;
  const ViewNotes({
    super.key,
    required this.deleteNoteCubit,
    required this.getNoteCubit,
  });

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  @override
  void initState() {
    widget.getNoteCubit.getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).height;

    return BlocBuilder<GetNoteCubit, GetNoteState>(
        bloc: widget.getNoteCubit,
        builder: (context, state) {
          if (state is GetNoteLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetNoteSuccess) {
            if (state.notes.isEmpty) {
              return const Center(
                child: Text('No notes found'),
              );
            }
            return SizedBox(
              height: size * 0.85,
              child: _notesView(state.notes.reversed.toList(), size),
            );
          }
          if (state is GetNoteFailure) {
            return const Center(
              child: Text('Failed to get notes'),
            );
          }
          return const SizedBox.shrink();
        });
  }

  Widget _notesView(List<NoteEntity> notes, double size) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return _note(notes, index, context);
      },
    );
  }

  GestureDetector _note(
      List<NoteEntity> notes, int index, BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteDialog(context, notes[index].id ?? 0);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailsPage(
              noteId: notes[index].id,
              title: notes[index].title,
              description: notes[index].description,
            ),
          ),
        ).then((value) {
          widget.getNoteCubit.getNotes();
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notes[index].title ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                notes[index].description ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.deleteNoteCubit.deleteNote(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

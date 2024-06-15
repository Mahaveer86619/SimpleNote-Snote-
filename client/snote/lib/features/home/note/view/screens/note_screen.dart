import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snote/core/model/note_details.dart';
import 'package:snote/core/utils/extensions.dart';
import 'package:snote/features/home/note/view/components/note_tile.dart';
import 'package:snote/features/home/note/view/components/search_form_field.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _changeScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    ).then((_) {
      // After navigating back, fetch notes again
      // context.read<NoteBloc>().add(FetchNotes());
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  _fab() {
    return FloatingActionButton.extended(
      onPressed: () {
        // _changeScreen(context, const AddNoteScreen());
      },
      label: const Text('Add Note'),
      icon: const Icon(Icons.add),
    );
  }

  _customAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: Icon(
                Icons.search,
                color: theme.colorScheme.onBackground,
              ),
              leadingWidth: 6,
              title: SearchFormField(
                hintText: "Search your notes",
                controller: _searchController,
                validator: (val) {
                  if (!val!.isValidName) {
                    return 'Enter a valid text.';
                  }
                  return null;
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.sync,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    // context.read<NoteBloc>().add(LogOut());
                  },
                  child: Image.asset(
                    'assets/logo/note_it_logo.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _notesEmptyWidget() {
    return Center(
      child: Column(
        children: [
          _customAppBar(context),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/empty_box.svg',
                  width: 200,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    "No Notes Found, add notes by clicking the add button.",
                    style: GoogleFonts.poppins(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _errorWidget(String msg) {
    return Center(
      child: Column(
        children: [
          _customAppBar(context),
          Expanded(
            child: Column(
              children: [
                Text(
                  msg,
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    // context.read<NoteBloc>().add(FetchNotes());
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _loadingWidget() {
    return Column(
      children: [
        _customAppBar(context),
        const Expanded(
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        )
      ],
    );
  }

  _buildUI(BuildContext context, List<NoteDetails> notes) {
    return Column(
      children: [
        _customAppBar(context),
        const SizedBox(height: 8.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: NoteTile(
                    note: note,
                    onTap: () {
                      // _changeScreen(context, EditNoteScreen(note: note));
                    },
                    onDelete: () {
                      // context.read<NoteBloc>().add(DeleteNote(note.id));
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

}
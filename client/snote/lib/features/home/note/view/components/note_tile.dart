import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snote/core/common/constants/app_constants.dart';
import 'package:snote/core/model/note_details.dart'; // Import intl package for date formatting

class NoteTile extends StatelessWidget {
  final NoteDetails note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: noteColors[note.noteColorIndex],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.hasCoverImage())
              // Display cover image if available
              Container(
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(
                      note.coverImagePath!,
                    ), //! Replace with your image loading logic, use cachecd image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 8.0),
            Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              _getFormattedDate(note.updatedAt),
              style: TextStyle(
                fontSize: 10.0,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime dateTime) {
    final formatter =
        DateFormat('dd MMM yyyy, HH:mm'); // Customize date format as needed
    return formatter.format(dateTime);
  }
}

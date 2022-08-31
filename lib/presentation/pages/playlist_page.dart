import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:reorderables/reorderables.dart';

import '../../domain/entities/playlist.dart';
import '../../domain/entities/shuffle_mode.dart';
import '../../domain/entities/song.dart';
import '../mucke_icons.dart';
import '../state/audio_store.dart';
import '../state/music_data_store.dart';
import '../state/navigation_store.dart';
import '../state/play_list_page_store.dart';
import '../utils.dart' as utils;
import '../widgets/bottom_sheet/add_to_playlist.dart';
import '../widgets/bottom_sheet/remove_from_playlist.dart';
import '../widgets/cover_sliver_appbar.dart';
import '../widgets/custom_modal_bottom_sheet.dart';
import '../widgets/playlist_cover.dart';
import '../widgets/song_bottom_sheet.dart';
import '../widgets/song_list_tile.dart';
import 'playlist_form_page.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key, required this.playlist}) : super(key: key);

  final Playlist playlist;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late PlaylistPageStore store;

  @override
  void initState() {
    super.initState();
    store = GetIt.I<PlaylistPageStore>(param1: widget.playlist);
    store.setupReactions();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AudioStore audioStore = GetIt.I<AudioStore>();
    final MusicDataStore musicDataStore = GetIt.I<MusicDataStore>();
    final NavigationStore navStore = GetIt.I<NavigationStore>();

    return SafeArea(
      child: Observer(
        builder: (context) {
          final songs = store.playlistSongStream.value ?? [];
          final playlist = store.playlistStream.value ?? widget.playlist;

          final totalDuration = songs.fold(
            const Duration(milliseconds: 0),
            (Duration d, s) => d + s.duration,
          );

          IconData playIcon = Icons.play_arrow_rounded;
          switch (playlist.shuffleMode) {
            case ShuffleMode.standard:
              playIcon = Icons.shuffle_rounded;
              break;
            case ShuffleMode.plus:
              playIcon = MuckeIcons.shuffle_heart;
              break;
            case ShuffleMode.none:
              playIcon = MuckeIcons.shuffle_none;
              break;
            default:
          }

          return Scaffold(
            body: Scrollbar(
              child: CustomScrollView(
                slivers: [
                  CoverSliverAppBar(
                    actions: [
                      Observer(
                        builder: (context) {
                          final isMultiSelectEnabled = store.selection.isMultiSelectEnabled;

                          if (!isMultiSelectEnabled)
                            return IconButton(
                              key: GlobalKey(),
                              icon: const Icon(Icons.edit_rounded),
                              onPressed: () => navStore.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => PlaylistFormPage(
                                    playlist: playlist,
                                  ),
                                ),
                              ),
                            );

                          return Container();
                        },
                      ),
                      Observer(
                        builder: (context) {
                          final isMultiSelectEnabled = store.selection.isMultiSelectEnabled;

                          if (isMultiSelectEnabled)
                            return IconButton(
                              key: GlobalKey(),
                              icon: const Icon(Icons.more_vert_rounded),
                              onPressed: () => _openMultiselectMenu(context, playlist),
                            );

                          return Container();
                        },
                      ),
                      Observer(
                        builder: (context) {
                          final isMultiSelectEnabled = store.selection.isMultiSelectEnabled;
                          final isAllSelected = store.selection.isAllSelected;

                          if (isMultiSelectEnabled)
                            return IconButton(
                              key: GlobalKey(),
                              icon: isAllSelected
                                  ? const Icon(Icons.deselect_rounded)
                                  : const Icon(Icons.select_all_rounded),
                              onPressed: () {
                                if (isAllSelected)
                                  store.selection.deselectAll();
                                else
                                  store.selection.selectAll();
                              },
                            );

                          return Container();
                        },
                      ),
                      Observer(
                        builder: (context) {
                          final isMultiSelectEnabled = store.selection.isMultiSelectEnabled;
                          return IconButton(
                            key: const ValueKey('PLAYLIST_MULTISELECT'),
                            icon: isMultiSelectEnabled
                                ? const Icon(Icons.close_rounded)
                                : const Icon(Icons.checklist_rtl_rounded),
                            onPressed: () => store.selection.toggleMultiSelect(),
                          );
                        },
                      ),
                    ],
                    title: playlist.name,
                    subtitle2: '${songs.length} songs • ${utils.msToTimeString(totalDuration)}',
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: playlist.gradient,
                      ),
                    ),
                    cover: PlaylistCover(
                      size: 120,
                      icon: playlist.icon,
                      gradient: playlist.gradient,
                    ),
                    button: ElevatedButton(
                      onPressed: () => audioStore.playPlaylist(playlist),
                      child: Row(
                        children: [
                          const Expanded(child: Center(child: Text('Play'))),
                          Icon(playIcon),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        primary: Colors.white10,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Observer(
                    builder: (context) {
                      final bool isMultiSelectEnabled = store.selection.isMultiSelectEnabled;
                      final List<bool> isSelected = store.selection.isSelected.toList();

                      return ReorderableSliverList(
                        enabled: !isMultiSelectEnabled,
                        delegate: ReorderableSliverChildBuilderDelegate(
                          (context, int index) {
                            final Song song = songs[index];
                            return Dismissible(
                              key: ValueKey(song.path),
                              child: SongListTile(
                                song: song,
                                showAlbum: true,
                                subtitle: Subtitle.artistAlbum,
                                onTap: () => audioStore.playSong(index, songs, playlist),
                                onTapMore: () => showModalBottomSheet(
                                  context: context,
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  // TODO: include RemoveFromPlaylist here!
                                  builder: (context) => SongBottomSheet(
                                    song: song,
                                  ),
                                ),
                                isSelectEnabled: isMultiSelectEnabled,
                                isSelected: isMultiSelectEnabled && isSelected[index],
                                onSelect: (bool selected) =>
                                    store.selection.setSelected(selected, index),
                              ),
                              onDismissed: (direction) {
                                musicDataStore.removePlaylistEntry(playlist.id, index);
                              },
                            );
                          },
                          childCount: songs.length,
                        ),
                        onReorder: (oldIndex, newIndex) =>
                            musicDataStore.movePlaylistEntry(playlist.id, oldIndex, newIndex),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // TODO: customize; maybe DRY
  Future<void> _openMultiselectMenu(BuildContext context, Playlist playlist) async {
    final audioStore = GetIt.I<AudioStore>();
    final musicDataStore = GetIt.I<MusicDataStore>();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Observer(builder: (context) {
        final isSelected = store.selection.isSelected;
        final allSongs = store.playlistSongStream.value ?? [];
        final songs = <Song>[];
        final songPositions = <int>[];
        for (int i = 0; i < allSongs.length; i++) {
          if (isSelected[i]) {
            songs.add(allSongs[i]);
            songPositions.add(i);
          }
        }

        return MyBottomSheet(
          widgets: [
            ListTile(
              title: Text('${songs.length} songs selected'),
            ),
            ListTile(
              title: const Text('Play next'),
              leading: const Icon(Icons.play_arrow_rounded),
              onTap: () {
                audioStore.playNext(songs);
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            ListTile(
              title: const Text('Append to manually queued songs'),
              leading: const Icon(Icons.play_arrow_rounded),
              onTap: () {
                audioStore.appendToNext(songs);
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            ListTile(
              title: const Text('Add to queue'),
              leading: const Icon(Icons.queue_rounded),
              onTap: () {
                audioStore.addToQueue(songs);
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            RemoveFromPlaylistTile(
              songPositions: songPositions,
              musicDataStore: musicDataStore,
              playlist: playlist,
              callback: () => store.selection.deselectAll(),
            ),
            AddToPlaylistTile(songs: songs, musicDataStore: musicDataStore),
          ],
        );
      }),
    );
  }
}

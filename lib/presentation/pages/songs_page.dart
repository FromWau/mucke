import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/song.dart';
import '../state/audio_store.dart';
import '../state/music_data_store.dart';
import '../widgets/song_list_tile.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({Key key}) : super(key: key);

  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    print('SongsPage.build');
    final MusicDataStore musicDataStore = Provider.of<MusicDataStore>(context);
    final AudioStore audioStore = Provider.of<AudioStore>(context);

    super.build(context);
    return Observer(builder: (_) {
      print('SongsPage.build -> Observer.builder');
      final bool isFetching = musicDataStore.isFetchingSongs;

      if (isFetching) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(),
            Text('Loading items...'),
          ],
        );
      } else {
        final List<Song> songs = musicDataStore.songs;
        return ListView.separated(
          itemCount: songs.length,
          itemBuilder: (_, int index) {
            final Song song = songs[index];
            return SongListTile(
              song: song,
              inAlbum: false,
              onTap: () => audioStore.playSong(index, songs),
              onTapMore: () => _openBottomSheet(song),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 4.0,
          ),
        );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  void _openBottomSheet(Song song) {
    final AudioStore audioStore = Provider.of<AudioStore>(context, listen: false);

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Add to queue'),
                  onTap: () {
                    audioStore.addToQueue(song);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}

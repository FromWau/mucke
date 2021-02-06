import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/song.dart';
import '../state/audio_store.dart';
import '../theming.dart';
import '../widgets/album_art.dart';
import '../widgets/album_background.dart';
import '../widgets/next_song.dart';
import '../widgets/playback_control.dart';
import '../widgets/song_customization_buttons.dart';
import '../widgets/time_progress_indicator.dart';
import 'queue_page.dart';

class CurrentlyPlayingPage extends StatelessWidget {
  const CurrentlyPlayingPage({Key key}) : super(key: key);

  static final _log = Logger('CurrentlyPlayingPage');

  @override
  Widget build(BuildContext context) {
    _log.info('build started');
    final AudioStore audioStore = Provider.of<AudioStore>(context);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (dragEndDetails) {
            if (dragEndDetails.primaryVelocity < 0) {
              _openQueue(context);
            } else if (dragEndDetails.primaryVelocity > 0) {
              Navigator.pop(context);
            }
          },
          child: Observer(
            builder: (BuildContext context) {
              _log.info('Observer.build');
              final Song song = audioStore.currentSongStream.value;

              return Stack(
                children: [
                  AlbumBackground(
                    song: song,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor,
                        DARK3.withOpacity(0.2),
                        DARK3.withOpacity(0.2),
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                      stops: const [
                        0.0,
                        0.2,
                        0.55,
                        0.7,
                        1.0,
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      top: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.expand_more),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _openQueue(context),
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Next up'.toUpperCase(),
                                        style: TEXT_SMALL_HEADLINE,
                                      ),
                                      NextSong(
                                        queue: audioStore.queueStream.value,
                                        index: audioStore.queueIndexStream.value,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () => null,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 1000,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 0.0,
                              ),
                              child: AlbumArt(
                                song: song,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(
                          flex: 60,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 2.0, right: 2.0),
                          child: SongCustomizationButtons(),
                        ),
                        const Spacer(
                          flex: 30,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: PlaybackControl(),
                        ),
                        const Spacer(
                          flex: 30,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                          child: TimeProgressIndicator(),
                        ),
                        const Spacer(
                          flex: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _openQueue(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => const QueuePage(),
      ),
    );
  }
}

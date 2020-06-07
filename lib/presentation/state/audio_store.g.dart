// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AudioStore on _AudioStore, Store {
  final _$currentSongAtom = Atom(name: '_AudioStore.currentSong');

  @override
  ObservableStream<Song> get currentSong {
    _$currentSongAtom.context.enforceReadPolicy(_$currentSongAtom);
    _$currentSongAtom.reportObserved();
    return super.currentSong;
  }

  @override
  set currentSong(ObservableStream<Song> value) {
    _$currentSongAtom.context.conditionallyRunInAction(() {
      super.currentSong = value;
      _$currentSongAtom.reportChanged();
    }, _$currentSongAtom, name: '${_$currentSongAtom.name}_set');
  }

  final _$songAtom = Atom(name: '_AudioStore.song');

  @override
  Song get song {
    _$songAtom.context.enforceReadPolicy(_$songAtom);
    _$songAtom.reportObserved();
    return super.song;
  }

  @override
  set song(Song value) {
    _$songAtom.context.conditionallyRunInAction(() {
      super.song = value;
      _$songAtom.reportChanged();
    }, _$songAtom, name: '${_$songAtom.name}_set');
  }

  final _$playbackStateStreamAtom =
      Atom(name: '_AudioStore.playbackStateStream');

  @override
  ObservableStream<PlaybackState> get playbackStateStream {
    _$playbackStateStreamAtom.context
        .enforceReadPolicy(_$playbackStateStreamAtom);
    _$playbackStateStreamAtom.reportObserved();
    return super.playbackStateStream;
  }

  @override
  set playbackStateStream(ObservableStream<PlaybackState> value) {
    _$playbackStateStreamAtom.context.conditionallyRunInAction(() {
      super.playbackStateStream = value;
      _$playbackStateStreamAtom.reportChanged();
    }, _$playbackStateStreamAtom,
        name: '${_$playbackStateStreamAtom.name}_set');
  }

  final _$currentPositionStreamAtom =
      Atom(name: '_AudioStore.currentPositionStream');

  @override
  ObservableStream<int> get currentPositionStream {
    _$currentPositionStreamAtom.context
        .enforceReadPolicy(_$currentPositionStreamAtom);
    _$currentPositionStreamAtom.reportObserved();
    return super.currentPositionStream;
  }

  @override
  set currentPositionStream(ObservableStream<int> value) {
    _$currentPositionStreamAtom.context.conditionallyRunInAction(() {
      super.currentPositionStream = value;
      _$currentPositionStreamAtom.reportChanged();
    }, _$currentPositionStreamAtom,
        name: '${_$currentPositionStreamAtom.name}_set');
  }

  final _$playSongAsyncAction = AsyncAction('playSong');

  @override
  Future<void> playSong(int index, List<Song> songList) {
    return _$playSongAsyncAction.run(() => super.playSong(index, songList));
  }

  final _$playAsyncAction = AsyncAction('play');

  @override
  Future<void> play() {
    return _$playAsyncAction.run(() => super.play());
  }

  final _$pauseAsyncAction = AsyncAction('pause');

  @override
  Future<void> pause() {
    return _$pauseAsyncAction.run(() => super.pause());
  }

  final _$updateSongAsyncAction = AsyncAction('updateSong');

  @override
  Future<void> updateSong(Song streamValue) {
    return _$updateSongAsyncAction.run(() => super.updateSong(streamValue));
  }

  final _$_AudioStoreActionController = ActionController(name: '_AudioStore');

  @override
  void init() {
    final _$actionInfo = _$_AudioStoreActionController.startAction();
    try {
      return super.init();
    } finally {
      _$_AudioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'currentSong: ${currentSong.toString()},song: ${song.toString()},playbackStateStream: ${playbackStateStream.toString()},currentPositionStream: ${currentPositionStream.toString()}';
    return '{$string}';
  }
}
enum LottieAnimation {
  dataNotFound(name: 'data_not_found'),
  empty(name: 'empty'),
  error(name: 'error'),
  loading(name: 'loading'),
  smallError(name: 'error_small');

  final String name;
  const LottieAnimation({
    required this.name,
  });
}

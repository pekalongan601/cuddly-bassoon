class DepositPromotion {
  const DepositPromotion({
    required this.term,
    required this.rate,
    required this.previousRate,
    required this.quota,
  });

  final String term;
  final String rate;
  final String previousRate;
  final String quota;
}

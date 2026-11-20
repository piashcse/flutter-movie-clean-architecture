import 'package:flutter/widgets.dart';
import 'package:flutter_movie_clean_architecture/core/error/app_failure.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';

/// Returns a localized, user-facing message for [error].
String failureMessage(BuildContext context, Object error) =>
    failureMessageFor(context.l10n, error);

String failureMessageFor(AppLocalizations l10n, Object error) {
  final failure = error is AppFailure ? error : mapError(error);

  return switch (failure.kind) {
    FailureKind.network => l10n.errorNetwork,
    FailureKind.timeout => l10n.errorTimeout,
    FailureKind.unauthorized => l10n.errorUnauthorized,
    FailureKind.forbidden => l10n.errorForbidden,
    FailureKind.notFound => l10n.errorNotFound,
    FailureKind.rateLimit => l10n.errorRateLimit,
    FailureKind.server => l10n.errorServer,
    FailureKind.parse => l10n.errorParse,
    FailureKind.storage => l10n.errorStorage,
    FailureKind.unknown => l10n.errorUnknown,
  };
}

bool isRetryable(Object error) =>
    error is AppFailure ? error.isRetryable : true;

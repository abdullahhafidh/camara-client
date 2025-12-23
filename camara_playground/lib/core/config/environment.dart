class Environment {
  const Environment({
    required this.authorizeUrl,
    required this.tokenValidateUrl,
    required this.verifyMsisdnUrl,
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
    required this.apiKey,
  });

  final String authorizeUrl;
  final String tokenValidateUrl;
  final String verifyMsisdnUrl;
  final String clientId;
  final String redirectUri;
  final List<String> scopes;
  final String apiKey;
}

enum EnvironmentType {
  iohSandbox,
  custom,
}

class EnvironmentConfig {
  const EnvironmentConfig._(this.type, this.environment);

  final EnvironmentType type;
  final Environment environment;

  static EnvironmentConfig iohSandbox() {
    return EnvironmentConfig._(
      EnvironmentType.iohSandbox,
      const Environment(
        authorizeUrl: 'https://camara.ioh.co.id/ida-camara/authorize',
        tokenValidateUrl: 'https://ida.ioh.id/api/v1/ipification/idm/validate-token',
        verifyMsisdnUrl: 'https://ida.ioh.id/api/v1/ipification/idm/verify-msisdn',
        clientId: 'uZNv6kA2Jn69Y8E7LsGt63hdOwiOmmoc6VrX/PWDDVE=',
        redirectUri: 'https://ida.ioh.id/callbackCamara',
        scopes: [
          'openid',
          'number-verification:verify',
          'dpv:FraudPreventionAndDetection',
        ],
        apiKey: 'A7mRgmo97TrNIdkL0go4vApV1xYiu+EhFmZzdgSXDYo=',
      ),
    );
  }
}



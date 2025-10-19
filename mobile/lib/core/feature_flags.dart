/// Feature Flags for Beauty Pro Network - Phase 1 MVP
///
/// Toggle features on/off for development, testing, and phased rollout.
/// All flags default to values that are safe for production.
class FeatureFlags {
  // External Trends Integration (Instagram + TikTok oEmbed)
  static const bool externalTrends = true;

  // AI-powered features
  static const bool aiSummaries = true;
  static const bool aiAutoTagging = true;
  static const bool aiCaptionSuggestions = true;
  static const bool weeklyTrendRadar = true;

  // Video features
  static const bool videoUpload = true;
  static const bool videoPlayer = true;

  // Social features
  static const bool follows = true;
  static const bool collections = true;
  static const bool saves = true;

  // Discovery & Search
  static const bool personalization = true;
  static const bool advancedFilters = true;

  // Professional features
  static const bool proProfiles = true;
  static const bool bookingRequests = true;

  // Future Phase 2 features (disabled for now)
  static const bool visualSearchPhase2 = false;
  static const bool paymentsIntegration = false;
  static const bool liveVideo = false;

  // Development/Debug features
  static const bool mockData = false;  // ✅ CHANGED: Now using real backend API
  static const bool debugLogging = true;  // Enable for API debugging

  /// Check if a feature is enabled
  static bool isEnabled(String feature) {
    switch (feature) {
      case 'externalTrends':
        return externalTrends;
      case 'aiSummaries':
        return aiSummaries;
      case 'aiAutoTagging':
        return aiAutoTagging;
      case 'aiCaptionSuggestions':
        return aiCaptionSuggestions;
      case 'weeklyTrendRadar':
        return weeklyTrendRadar;
      case 'videoUpload':
        return videoUpload;
      case 'videoPlayer':
        return videoPlayer;
      case 'follows':
        return follows;
      case 'collections':
        return collections;
      case 'saves':
        return saves;
      case 'personalization':
        return personalization;
      case 'advancedFilters':
        return advancedFilters;
      case 'proProfiles':
        return proProfiles;
      case 'bookingRequests':
        return bookingRequests;
      case 'visualSearchPhase2':
        return visualSearchPhase2;
      case 'paymentsIntegration':
        return paymentsIntegration;
      case 'liveVideo':
        return liveVideo;
      case 'mockData':
        return mockData;
      case 'debugLogging':
        return debugLogging;
      default:
        return false;
    }
  }

  /// Get all enabled features as a map
  static Map<String, bool> getAllFlags() {
    return {
      'externalTrends': externalTrends,
      'aiSummaries': aiSummaries,
      'aiAutoTagging': aiAutoTagging,
      'aiCaptionSuggestions': aiCaptionSuggestions,
      'weeklyTrendRadar': weeklyTrendRadar,
      'videoUpload': videoUpload,
      'videoPlayer': videoPlayer,
      'follows': follows,
      'collections': collections,
      'saves': saves,
      'personalization': personalization,
      'advancedFilters': advancedFilters,
      'proProfiles': proProfiles,
      'bookingRequests': bookingRequests,
      'visualSearchPhase2': visualSearchPhase2,
      'paymentsIntegration': paymentsIntegration,
      'liveVideo': liveVideo,
      'mockData': mockData,
      'debugLogging': debugLogging,
    };
  }
}


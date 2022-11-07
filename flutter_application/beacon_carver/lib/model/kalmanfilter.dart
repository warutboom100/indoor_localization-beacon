class KalmanFilter {
  KalmanFilter(double processNoise, double sensorNoise, double estimatedError,
      double initialValue) {
    q = processNoise;
    r = sensorNoise;
    p = estimatedError;
    x = initialValue;
  }

  /* Kalman filter variables */

  double q = 0; //process noise covariance
  double r = 0; //measurement noise covariance
  double x = 0; //value
  double p = 0; //estimation error covariance
  double k = 0; //kalman gain

  double getFilteredValue(double measurement) {
    // prediction phase
    p = p + q;

    // measurement update
    k = p / (p + r);
    x = x + k * (measurement - x);
    p = (1 - k) * p;

    return x;
  }
}

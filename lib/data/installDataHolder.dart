class InstallDataHolder {
  String? installerTaskID = "Unknown";
  int imeiStatus = 1;
  int connectivityStatus = 0;
  int powerOneStatus = 0;
  int powerTwoStatus = 0;
  int locationStatus = 0;
  int relayStatusOne = 0;
  int relayStatusTwo = 0;
  int photosStatus = 0;
  bool completeStatus = false;
  InstallDataHolder({
    required this.installerTaskID,
  });
}

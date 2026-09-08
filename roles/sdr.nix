{ pkgs, ... }:

{
  # Enables udev rules for RTL-SDR hardware, ensures the 'plugdev' group exists,
  # and blacklists conflicting default DVB kernel drivers (e.g., dvb_usb_rtl28xxu).
  hardware.rtl-sdr.enable = true;

  # Ensure users accessing the SDR dongle belong to the plugdev group
  users.users.bence.extraGroups = [ "plugdev" ];

  # Install SDR software & tools
  environment.systemPackages = with pkgs; [
    # RTL-SDR CLI utilities (rtl_test, rtl_fm, rtl_sdr)
    rtl-sdr

    # Graphical SDR applications
    sdrpp
    gnuradio

    # SoapySDR hardware abstraction layer & RTL-SDR driver plugin
    soapysdr-with-plugins
    soapyrtlsdr

	# 433 MHz decoder
	rtl_433
  ];

  # Allow SoapySDR plugins (used by GNU Radio) to be discovered at runtime
  environment.sessionVariables = {
    SOAPY_SDR_PLUGIN_PATH = "${pkgs.soapysdr-with-plugins}/lib/SoapySDR/modules0.8";
  };
}

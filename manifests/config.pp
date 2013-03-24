# Internal: Configure dnsmasq.
#
# Examples
#
#   include dnsmasq::config
class dnsmasq::config ($configfile_source = 'puppet:///modules/dnsmasq/dnsmasq.conf') {
  require boxen::config

  $configdir  = "${boxen::config::configdir}/dnsmasq"
  $configfile = "${configdir}/dnsmasq.conf"
  $datadir    = "${boxen::config::datadir}/dnsmasq"
  $executable = "${boxen::config::homebrewdir}/sbin/dnsmasq"
  $logdir     = "${boxen::config::logdir}/dnsmasq"
  $logfile    = "${logdir}/console.log"

  anchor { [
    $configdir,
    $configfile,
    $datadir,
    $executable,
    $logdir,
    $logfile,
  ]: }
}

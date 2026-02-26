{ config, lib, ... }:
{
  accounts.email.accounts = {
    "hannes.leutloff@yeldirium.de" = {
      primary = true;
      address = "hannes.leutloff@yeldirium.de";
      realName = "Hannes Leutloff";

      thunderbird = lib.mkIf config.programs.thunderbird.enable {
        enable = true;
        settings = _: {
          "mail.openpgp.allow_external_gnupg" = true;
        };
      };

      gpg = {
        key = "8DFC1FE97A49B7CEF042DE06BA239C4139A9A514";
        signByDefault = true;
      };

      flavor = "plain";
      userName = "hannes.leutloff@yeldirium.de";
      imap = {
        host = "secureimap111.ek-networks.de";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "securemx111.ek-networks.de";
        port = 465;
        tls.enable = true;
      };
    };
  };
}

{ config, lib, ... }:
{
  accounts.contact.accounts = {
    "Contacts" = {
      remote = {
        type = "carddav";
        userName = "yeldir";
        url = "https://nextcloud.yeldirium.de/remote.php/dav/addressbooks/users/yeldir/contacts/";
      };
      thunderbird = lib.mkIf config.programs.thunderbird.enable {
        enable = true;
      };
    };
  };
}

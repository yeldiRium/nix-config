{ config, ... }:
{
  accounts.contact.accounts = {
    "Contacts" = {
      remote = {
        type = "carddav";
        userName = "yeldir";
        url = "https://nextcloud.yeldirium.de/remote.php/dav/addressbooks/users/yeldir/contacts/";
      };
    };
  };

  # TODO: Replace this once https://github.com/nix-community/home-manager/issues/5933 is closed.
  programs.thunderbird.settings =
    let
      safeName = builtins.replaceStrings [ "." ] [ "-" ];
      makeThunderbirdContacts =
        name:
        let
          contactsAccount = config.accounts.contact.accounts.${name};
          contactsAccountSafeName = safeName contactsAccount.name;
        in
        {
          "ldap_2.servers.${contactsAccountSafeName}.carddav.url" = contactsAccount.remote.url;
          "ldap_2.servers.${contactsAccountSafeName}.carddav.username" = contactsAccount.remote.userName;
          "ldap_2.servers.${contactsAccountSafeName}.description" = contactsAccount.name;
          "ldap_2.servers.${contactsAccountSafeName}.dirType" = 102;
          "ldap_2.servers.${contactsAccountSafeName}.filename" = "abook-${contactsAccountSafeName}.sqlite";
        };
    in
    makeThunderbirdContacts "Contacts";
}

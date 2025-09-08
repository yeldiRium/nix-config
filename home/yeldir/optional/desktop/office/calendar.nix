{
  config,
  lib,
  ...
}:
let
  calendars = [
    {
      name = "Personal";
      primary = true;
      path = "personal";
    }
    {
      name = "Work";
      primary = false;
      path = "work";
    }
    {
      name = "Lea";
      primary = false;
      path = "lea";
    }
    {
      name = "Festivals & Events";
      primary = false;
      path = "festivals-events";
    }
    {
      name = "Birthdays";
      primary = false;
      path = "contact_birthdays";
    }
  ];
in
{
  accounts.calendar.accounts =
    let
      makeNextcloudCalendar = path: primary: {
        primary = primary;
        remote = {
          type = "caldav";
          userName = "yeldir";
          url = "https://nextcloud.yeldirium.de/remote.php/dav/calendars/yeldir/${path}/";
        };
      };
    in
    lib.attrsets.mergeAttrsList (
      map (cal: {
        "${cal.name}" = makeNextcloudCalendar cal.path cal.primary;
      }) calendars
    );

  # TODO: Replace this once https://github.com/nix-community/home-manager/pull/5484 is merged.
  # Make sure it works, though, including the order of calendars.
  programs.thunderbird.settings =
    let
      safeName = builtins.replaceStrings [ "." ] [ "-" ];
      makeThunderbirdCalendar =
        name:
        let
          calendarAccount = config.accounts.calendar.accounts.${name};
          calendarAccountSafeName = safeName calendarAccount.name;
        in
        {
          "calendar.registry.${calendarAccountSafeName}.cache.enabled" = true;
          "calendar.registry.${calendarAccountSafeName}.calendar-main-default" = calendarAccount.primary;
          "calendar.registry.${calendarAccountSafeName}.calendar-main-in-composite" = true;
          "calendar.registry.${calendarAccountSafeName}.name" = calendarAccount.name;
          "calendar.registry.${calendarAccountSafeName}.type" = "caldav";
          "calendar.registry.${calendarAccountSafeName}.uri" = calendarAccount.remote.url;
          "calendar.registry.${calendarAccountSafeName}.username" = calendarAccount.remote.userName;
        };
    in
    lib.attrsets.mergeAttrsList (map (cal: makeThunderbirdCalendar cal.name) calendars)
    // {
      "calendar.list.sortOrder" = lib.fold (cal: acc: cal.name + " " + acc) "" calendars;

      # Keep these after removing the above.
      "calendar.week.start" = 1;
    };
}

{pkgs, ...}: {
  # Various dependencies.
  home.packages = with pkgs; [
    bat
    ffmpeg
    ffmpegthumbnailer
  ];

  programs.ranger = {
    enable = true;
    settings = {
      show_hidden = true;
      preview_images = true;
      preview_images_method = "kitty";
    };
  };
}

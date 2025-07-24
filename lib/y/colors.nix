{lib, ...}: let
  square = x: x * x;

  splitIntoDigits = string: lib.splitString "" string |> builtins.filter (digit: digit != "");
  hexDigitToDec = digit:
    lib.lists.findFirstIndex
    (elem: elem == digit)
    (builtins.throw "hex digit must be 0-9a-f")
    (splitIntoDigits "0123456789abcdef");

  hexToDec = hex:
    builtins.foldl'
    (dec: digit: dec * 16 + (hexDigitToDec digit))
    0
    (splitIntoDigits hex);

  hexToRGB = hex: let
    color = lib.removePrefix "#" hex;
    R = lib.strings.substring 0 2 color;
    G = lib.strings.substring 2 2 color;
    B = lib.strings.substring 4 2 color;
  in {
    R = hexToDec R;
    G = hexToDec G;
    B = hexToDec B;
  };

  rgbDistance = rgb1: rgb2:
    (rgb2.R - rgb1.R |> square)
    + (rgb2.G - rgb1.G |> square)
    + (rgb2.B - rgb1.B |> square);

  rgb = R: G: B:
    if R < 0 || R > 255 || G < 0 || G > 255 || B < 0 || B > 255
    then (builtins.throw "rgb digits must be between 0 and 255")
    else {inherit R G B;};

  rgbDistanceMax = rgbDistance (rgb 0 0 0) (rgb 255 255 255);

  findClosestRGB = rgbs: rgb: let
    result =
      builtins.foldl'
      ({distance, ...} @ best: next: let
        nextDistance = rgbDistance next rgb;
      in
        if nextDistance < distance
        then {
          distance = nextDistance;
          value = next;
        }
        else best)
      {
        distance = rgbDistanceMax;
        value = builtins.throw "could not find a closest rgb";
      }
      rgbs;
  in
    result.value;
in {
  inherit
    hexDigitToDec
    hexToDec
    hexToRGB
    rgb
    rgbDistance
    rgbDistanceMax
    findClosestRGB
    ;
}

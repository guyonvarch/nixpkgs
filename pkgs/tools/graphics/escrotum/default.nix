{ lib, fetchFromGitHub, python3Packages , gtk3, gobject-introspection,
  wrapGAppsHook , pygtk , numpy ? null, buildPythonApplication }:

python3Packages.buildPythonApplication rec {
  pname = "escrotum";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner  = "Roger";
    repo   = "${pname}";
    rev = "${version}";
    sha256 = "1kzsx5daprj811y88mmw0bmxdd1vgdiyk7q15fzs2cw9db9hsx08";
  };

  postPatch = ''
    substituteInPlace ./setup.py \
      --replace "'gobject'," "'PyGObject',"
    substituteInPlace ./escrotum/util.py \
      --replace "array.array (\"c\", pixels)" "array.array ('B', pixels)"
  '';

  buildInputs = [
    gtk3
    gobject-introspection
  ];

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    numpy
    pygobject3
    xcffib
  ];

  outputs = [ "out" "man" ];

  postInstall = ''
    mkdir -p $man/share/man/man1
    cp man/escrotum.1 $man/share/man/man1/
  '';

  meta = with lib; {
    homepage = https://github.com/Roger/escrotum;
    description = "Linux screen capture using pygtk, inspired by scrot";
    platforms = platforms.linux;
    maintainers = with maintainers; [ rasendubi ];
    license = licenses.gpl3;
  };
}

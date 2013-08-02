Config {
  font = "-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*",
  bgColor = "black",
  fgColor = "grey",
  position = Top,
  lowerOnStart = True,
  commands = [
    Run Weather "EGPF" ["-t","<station>: <tempC>C","-L","18","-H","25","--normal","green","--high","red","--low","lightblue"] 36000,
    Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10,
    Run Memory ["-t","Mem: <usedratio>%"] 10,
    Run Swap [] 10,
    Run Com "uname" ["-s","-r"] "" 36000,
    Run Date "%a %b %_d %Y %H:%M:%S" "date" 10,
    Run Com "acpi | cut -d , -f 2-3" [] "battery" 100,
    Run Com "netcfg current" [] "network" 10,
    Run Com "amixer get Master | sed -n 5p | cut -d ' ' -f 6" [] "volume" 10,
    Run StdinReader
    ],
  sepChar = "%",
  alignSep = "}{",
  template = "%StdinReader% | %cpu% | %memory% * %swap% }{ <fc=#ee9a00>%network%</fc> Battery:%battery% | <fc=#ee9a00>%date%</fc> %volume%"

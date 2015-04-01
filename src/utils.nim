

template filename: string =
  instantiationInfo().filename

template runUnitTests*(code: stmt): stmt =
  when defined(testing):
    echo " *** Running units test in " & instantiationInfo().filename
    code

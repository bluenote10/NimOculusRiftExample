


template runUnitTests*(code: stmt): stmt =
  when defined(testing):
    echo "Running units test in ..."
    code

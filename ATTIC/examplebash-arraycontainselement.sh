_ArrayContainsElement() { #thanks https://stackoverflow.com/questions/3685970/
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

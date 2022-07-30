function! GetSelectedText()
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[] ")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

function! LoadSession(...)
  let session_name = a:0 >= 1 ? a:1 : 'default'
  let sessiondir = $HOME . "/.config/nvim/sessions/"
  let filename = sessiondir . 'session-' . session_name . '.vim'
  if (filereadable(filename))
    exe 'source ' filename
  else
    echo "No session loaded."
  endif
endfunction

function! Toggle(name, message)
  let b:{a:name} = !get(b:, a:name, 0)
  let trueFalseStr = b:{a:name} ? 'true': 'false'
  echo a:message . trueFalseStr
  return b:{a:name}
endfunction

function! ToggleOff(name, message)
  let b:{a:name} = 0
  echo a:message . 'false'
  return b:{a:name}
endfunction


function lfcd
	set -l tmp "$(mktemp)"
	lf -last-dir-path="$tmp"
	if test -f "$tmp"
		set -l dir "$(cat "$tmp")"
		rm -f "$tmp"
		if test -d "$dir"
			if test "$dir" != "$(pwd)"
				cd "$dir"
			end
		end
	end
end

alias f="lfcd"

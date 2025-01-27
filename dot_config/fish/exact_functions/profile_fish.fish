function profile_fish
    fish --profile-startup /tmp/fish.profile -i -c exit
    set -l sum (awk '{sum += $2} END {print sum}' /tmp/fish.profile)
    set sum (math $sum / 1000)
    set -l sum_secs (math $sum / 1000)
    echo "TOTAL: "$sum"ms ($sum_secs sec)" >>/tmp/fish.profile
    sort -nk2 /tmp/fish.profile >/tmp/fish_sorted.profile
    echo "TOTAL: $sum ms" >>/tmp/fish_sorted.profile
    nvim /tmp/fish.profile /tmp/fish_sorted.profile
end

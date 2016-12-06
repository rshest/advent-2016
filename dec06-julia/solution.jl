function get_hist(arr)
    dict = Dict{String,Int32}()
    for c in arr
        dict[c] = get(dict, c, 0) + 1
    end
    pairs = collect(dict)
    sort!(pairs, lt = (a, b) -> b.second < a.second)
    pairs
end

get_most_freq(x) = x[1].first
get_least_freq(x) = x[end].first
get_str(m, fn) = mapslices(x -> x |> get_hist |> fn, m, [2]) |> join

# read data
file = length(ARGS) > 0 ? ARGS[1] : "input.txt"
f = open(file);
lines = readlines(f)

chars = map(s -> split(strip(s), ""), lines)
m = hcat(chars...)

@printf "Word 1: %s\n" get_str(m, get_most_freq)
@printf "Word 2: %s\n" get_str(m, get_least_freq)
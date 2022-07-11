-- Given a length creates an array with the elements of that length and and shuffles them
function randomic_length_shuffle(length_of_an_array)
    local arr = {}
    for i=1, length_of_an_array do
        table.insert(arr, i)
    end
    return randomic_shuffle(arr)
end


-- Fisher-Yates shuffle
-- Randomly shuffles an array so that its members are disordered
-- https://gist.github.com/Uradamus/10323382
-- param tbl: Array
function randomic_shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

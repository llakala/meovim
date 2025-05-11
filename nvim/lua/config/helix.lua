nnoremap("y", "vy") -- Select the current character, so `y` just copies a letter
vnoremap("y", "ygv") -- Bring back selection after copying

-- Move around without selecting at all
nnoremap("<A-e>", "e")
nnoremap("<A-b>", "b")
vnoremap("<A-e>", "<Esc>e")
vnoremap("<A-b>", "<Esc>b")

-- Move around, selecting one word at a time
nnoremap("e", "eviw")
nnoremap("b", "bviwo")
vnoremap("e", "<Esc>eviw")
vnoremap("b", "<Esc>bviwo")

-- Move around, continuing selection
nnoremap("E", "ve")
nnoremap("B", "vb")
vnoremap("E", "e")
vnoremap("B", "b")

vnoremap("i", "<Esc>`<i")
vnoremap("a", "<Esc>`>a")

-- Helix-style match-in-word and match-around-word
nnoremap("mi", "vi")
nnoremap("ma", "va")

noremap("d", '"_x') -- Delete current character, and don't copy to clipboard
noremap("c", '"_s') -- Change, and don't copy to clipboard

noremap("U", "<C-r>") -- Redo

-- Go to beginning/end of visual line
noremap("H", "^")
noremap("L", "$")

nnoremap("%", "ggVG") -- Select entire file
vnoremap("%", "<Nop>")
noremap("gG", "G") -- gG to go to end of file

-- i<Esc> won't move the cursor at all, while a<Esc> will move the cursor
-- one to the right. I prefer this, as I use i more than a.
inoremap("<Esc>", "<Esc>l")

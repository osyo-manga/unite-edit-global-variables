scriptencoding utf-8

function! unite#sources#edit_global_variables#define()
	return s:source
endfunction

function! s:typename(nr)
	return get({
\		type(0)              : "Number",
\		type(0.0)            : "Float",
\		type("")             : "String",
\		type(function("tr")) : "Funcref",
\		type([])             : "List",
\		type({})             : "Dictionary",
\	}, a:nr, "")
endfunction


let s:source = {
\	"name" : "edit-global-variables",
\	"default_action" : "input",
\	"max_candidates" : 30,
\	"action_table" : {
\		"input" : {
\			"is_invalidate_cache" : 1,
\			"is_selectable" : 0,
\			"is_quit" : 0
\		},
\	},
\}


function! s:source.action_table.input.func(candidate)
	let target = a:candidate.action__target
	let name   = a:candidate.action__name
	let var    = get(eval(target), name)
	
	let result = input("input:".name."=", string(var))
	if result == "" || type(eval(result)) != type(var)
		echoerr "No match variable type. Please input ".s:typename(type(var))." type"
	endif

	let dict = eval(target)
	let dict[name] = eval(result)
endfunction


function! s:source.gather_candidates(args, context)
	let target_name = "g:"
	return map(sort(keys(copy(eval(target_name)))),'{
\		"word" : v:val." = ".string(get(eval(target_name), v:val)),
\		"action__name" : v:val,
\		"action__target" : target_name,
\}')
endfunction




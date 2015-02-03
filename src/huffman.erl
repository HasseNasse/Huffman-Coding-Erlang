-module(huffman).
-compile(export_all).

sample() -> "the quick brown fox jumps over the lazy dog
this is a sample text that we will use when we build
up a table we will only handle lower case letters and
no punctuation symbols the frequency will of course not
represent english but it is probably not that far off".

text() -> "this is something that we should encode".

test() ->
	Sample = sample(),
	Table = table(Sample),
	Text = text(),
	Seq = encode(Text, Table),
	Text = decode(Seq, Table, []).

table(Sample) -> Freq = freq(Sample),
				 Tree = huffman(Freq),
				 codes(Tree).

%%--------------------------------------------------------------------------
%% Encode Implementation:
%%--------------------------------------------------------------------------

encode(Text, Table) ->
	Dict = dict:from_list(Table),
	encode(Text, Dict, []).

encode([], _Dict, Result) ->
	Result;

encode([Char | Rest], Dict, Result) -> 
	Newvar = dict:fetch(Char, Dict),
	Newlist = lists:append([Result, Newvar]),
	encode(Rest , Dict, Newlist).
	
%%--------------------------------------------------------------------------
%% Decode Implementation:
%%--------------------------------------------------------------------------

decode([], _Table, Result) ->
	Result;

decode(Seq, Table, Result) -> 
	{Char, Rest} = decode_char(Seq, 1, Table),
	Newvar = Char,
	Newlist = lists:append([Result, [Newvar]]),
	decode(Rest, Table, Newlist).

decode_char(Seq, N, Table) ->
	{Code, Rest} = lists:split(N, Seq),
	case lists:keyfind(Code, 2, Table) of
	{C,_} ->
		{C, Rest};
	false ->
		decode_char(Seq, N+1, Table)
	end.

%%--------------------------------------------------------------------------
%% Uppgift 2:
%%--------------------------------------------------------------------------

% 2.0 Freq Implementation
freq(Sample)->          
    freq(lists:sort(Sample),[]).
freq([], Freq)-> 
    Freq;
freq([Char | Rest],Freq) ->
    {Block, MBlocks}=lists:splitwith(fun (Block) -> Block==Char end, Rest),
    freq(MBlocks,[{Char, 1 + length(Block)} | Freq]).

% 2.1 Tree Building Implementation

huffman([{X, _} | []]) ->
    X;
huffman(Freq)->
	[{Key1, Fre1},{Key2, Fre2} | Rest] = lists:keysort(2, Freq),
	huffman([{{Key1,Key2}, Fre1 + Fre2} | Rest]).	%Vi borde använda en insert, Rest är sorterat
	
% 2.2 Huffman Codes

codes({L, R}) ->
    codes(L, [0]) ++ codes(R, [1]).
  		
codes({L, R}, Val) ->
    codes(L, Val ++ [0]) ++ codes(R, Val ++ [1]);
codes(Symbol, Val) ->
    [{Symbol, Val}].



	

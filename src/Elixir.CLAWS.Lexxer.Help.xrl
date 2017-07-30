Definitions.

Bold = (.\b.)+
Linebreaks = \n+
Whitespace = \s+
Chars = [^\s\n]+

Leading = AWS\(\){Whitespace}AWS\(\){Linebreaks}
Trailing = {Linebreaks}{Whitespace}AWS\(\)\n

Rules.

{Bold} : {token,{bold,bold(TokenChars)}}.
{Chars} : {token,TokenChars}.
{Leading} : skip_token.
{Linebreaks} : {token,{line_breaks,TokenChars}}.
{Trailing} : skip_token.
{Whitespace} : {token,{whitespace,TokenChars}}.

Erlang code.

bold(Chars) ->
  Acc = [],
  bold(Chars,Acc).
bold([],Acc) ->
  lists:reverse(Acc);
bold([H,$\b,H|T],Acc) ->
  bold(T,[H|Acc]).

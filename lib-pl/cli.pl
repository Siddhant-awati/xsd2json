:- use_module(xsd2json).
:- use_module(library(http/json)).

opts_spec([
  [
    opt(space),
    type(atom),
    default(remove),
    shortflags([ s ]),
    longflags([ 'whitespace' ]),
    help([
      'whitespace handling, one of',
      '  remove   :  clean whitespace  [default]',
      '  preserve :  keep whitespace'
    ])
  ],
  [
    opt(trace),
    type(boolean),
    default(false),
    shortflags([ t ]),
    longflags([ 'trace' ]),
    help([
      'run with activated tracing'
    ])
  ], /*
  [
    opt(version),
    type(boolean),
    default(false),
    shortflags([ v ]),
    longflags([ 'version' ]),
    help([
      'show xsd2json version information'
    ])
  ], */
  [
    opt(help),
    type(boolean),
    default(false),
    shortflags([ h ]),
    longflags([ 'help' ]),
    help([
      'display this help'
    ])
  ]
]).

main :-
  opts_spec(OptsSpec),
  opt_arguments(OptsSpec,Opts,PositionalArgs),
  main(Opts,PositionalArgs).

main(Opts,_PositionalArgs) :-
  memberchk(version(true),Opts), !,
  xsd2json:version(Version),
  writeln(Version),
  halt(0).

main(Opts,PositionalArgs) :-
  (
    memberchk(help(true),Opts)
  ;
    PositionalArgs = []
  ), !,
  opts_spec(OptsSpec),
  opt_help(OptsSpec,Help),
  writeln('USAGE: xsd2json [options] <path>'), nl,
  writeln('convert a XSD file into equivalent JSON schema'), nl,
  writeln('Options:'),
  writeln(Help),
  halt(0).

main(Opts,PositionalArgs) :-
  memberchk(trace(Trace),Opts),
  PositionalArgs = [Filename|_ArgvRest],
  (
    Trace = true,
    chr_leash(none),
    chr_trace
  ;
    Trace = false
  ),
  xsd2json(Filename,Opts,JSON),
  json_write(user_output,JSON,[step(2),width(200),tab(4)]), nl,
  halt(0).

main(_,_) :- halt(1).

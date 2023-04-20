import 'package:flutter/material.dart';


/// Expect log message: 
/// Skipping: function `aaa` does not have a return type.
aaa() => print('aaa');

/// Expect log message: 
/// Skipping: function `bbb` has parameters, story functions should have zero parameters.
Widget bbb(int x) => Text('$x');

/// Expect log message: 
/// Found potential story `Function ccc()`.
/// 
/// Expect warning:
/// ══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
/// Function `ccc` is not of a story function of type `Widget Function()`. It will be ignored.
/// ════════════════════════════════════════════════════════════════════════════════════════════════════
Function ccc() => (bool b) => 5;

/// Expect log message: 
/// Skipping: the return type of function `ddd` is not a NamedType, it is a GenericFunctionTypeImpl.
int Function(bool) ddd() => (bool b) => 5;

/// Expect log message: 
/// Skipping: function `eee` has null parameters, it must be a getter.
Widget get eee => const Text('eee');

/// Expect log message: 
/// Skipping: declaration is not a FunctionDeclaration, it is a ClassDeclarationImpl.
class Fff {}

/// Expect log message: 
/// Found potential story `Widget ggg()`.
Widget ggg() => const Text('ggg');

/// Expect log message:
/// Found potential story `Text hhh()`.
Text hhh() => const Text('hhh');

/// Expect log message:
/// Skipping: function `_iii` is private.
Widget _iii() => const Text('_iii');
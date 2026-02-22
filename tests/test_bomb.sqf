#include "mock_arma.sqf"
diag_log "🧪 INITIATING BOMB TEST...";

// 1. Syntax Error: Missing Semicolon
private _error = "stutter"

// 2. Runtime Error: Undefined Variable
private _crash = _undefined_variable_uksfta + 10;

diag_log "🏁 SHOULD NEVER REACH HERE";

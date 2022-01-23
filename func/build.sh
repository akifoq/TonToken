#!/bin/bash
token_files="token/ops.fc token/settings.fc token/storage.fc token/balances.fc token/get-methods.fc token/token.fc"
custom_files="storage.fc"
func -SP stdlib+.fc msgs.fc $token_files $custom_files main.fc -o auto/token-code.fif

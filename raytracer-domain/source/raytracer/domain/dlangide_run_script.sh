
rm $0
'rdmd' '-unittest' 'parametrisation.d'
exit_code=$?
echo "
-----------------------
(program returned exit code: $exit_code)"
echo "Press return to continue..."
dummy_var=""
read dummy_var
exit $exit_code

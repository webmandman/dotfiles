component extends="commandbox.system.BaseCommand" {

	function run(){
		
		print.greenLine( "+++++++ Running Vite Post Build for Custom Combining +++++++");
		// get cwd, should be run from nxworkspace root
		var cwd = getCWD();

		// gives error if it can't find folder
		try {
            var packagename = command( 'jq' )
                .params( 
                    cwd & 'package.json', 
                    'name')
                .run( returnOutput=true );

            if( trim(packagename) neq "customcomparereact" ){
                print.redline("Please switch to 'customcomparereact' app.");
                return;
            }

		 } catch (any exception) {
			print.redline( "App not found, your probably in wrong parent folder");
			return;
		 }

        var deploypath = expandPath(cwd & "\..\..") & "\customcombining";
		deploypath = fileSystemUtil.normalizeSlashes(deploypath);

        // //rename and move
        fileMove( cwd & '/dist/index.html', deploypath & '/default.cfm');
        directoryDelete(deploypath & '/assets/', true);
        directoryRename(cwd & '/dist/assets/', deploypath & '/assets/', false);
	
        // add cfinclude code to default.cfm
        var file = fileRead(deploypath & '/default.cfm').listToArray(chr(13) & chr(10));

        var tagline = "<c" & "fin" & "clude template='../../../assets/PsomasBarCF/default.cfm'></c" & "fin" & "clude>";

        for(var i = 1; i <= arrayLen(file); i++){
            if(file[i] eq "<body>"){
                arrayInsertAt(file,i+1,tagline);
                fileWrite(deploypath & '/default.cfm', arrayToList(file," "));
                break;
            }
        }
		
		print.greenline( "+++++++++ Success ++++++++++");
	}
}
 
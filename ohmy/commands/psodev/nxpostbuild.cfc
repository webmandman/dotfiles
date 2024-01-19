component extends="commandbox.system.BaseCommand" {

	function run( required string appname ){
		
		print.greenLine( "+++++++ Running Nx Post Build on: #appname# +++++++");
		// get cwd, should be run from nxworkspace root
		var cwd = getCWD();

		

	
		// get app output path   
		// TODO: this returns carriage return at end of output. 
		// contribute to commandbox by fixing this bug.


		// gives error if it can't find folder
		try {
		var apppath = command( 'jq' )
			.params( 
				cwd & 'workspace.json', 
				'projects.' & arguments.appname )
			.run( returnOutput=true );

		 } catch (any exception) {
			print.redline( "App not found, your probably in wrong parent folder");
			return
		 }

		
		

		apppath = fileSystemUtil.normalizeSlashes(trim(cwd & apppath));

		//gives error if it can't find output path
		try {
		var appOutputPath = command( 'jq' )
			.params( 
				apppath & '\project.json', 
				'targets.build.options.outputPath' )
			.run( returnOutput=true );
		} catch (any exception) {
			print.redline("Build destination not found");
			return
		}

		appOutputPath = resolvePath(fileSystemUtil.normalizeSlashes(trim(appOutputPath)));

		if( not fileExists(appOutputPath & '/default.cfm')){
			// rename index.html to default.cfm
			fileMove( appOutputPath & '/index.html', appOutputPath & '/default.cfm');
		}

		if( fileExists(apppath & '/Application.cfc') ){
			// copy Application.cfc to outputpath
			fileCopy( apppath & '/Application.cfc', appOutputPath & '/Application.cfc');
		}

		// display outputpath contents
		command( 'ls' )
			.params( appOutputPath )
			.run();

		print.greenline( "+++++++++ Success ++++++++++")
		print.greenline( "renamed: index.html and added Application.cfc")
	}
}
 
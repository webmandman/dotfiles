component extends="commandbox.system.BaseCommand" {

	function run( required string appname ){

		// get cwd, should be run from nxworkspace root
		var cwd = getCWD();

		// get app output path   
		// TODO: this returns carriage return at end of output. 
		// contribute to commandbox by fixing this bug.
		var apppath = command( 'jq' )
			.params( 
				cwd & 'workspace.json', 
				'projects.' & arguments.appname )
			.run( returnOutput=true );

		apppath = fileSystemUtil.normalizeSlashes(trim(cwd & apppath));

		var appOutputPath = command( 'jq' )
			.params( 
				apppath & '\project.json', 
				'targets.build.options.outputPath' )
			.run( returnOutput=true );

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
		
	}
}
 
component extends="commandbox.system.BaseCommand" {
	function run(
		required string name, 
		string type="blank", 
		string folder="C:/Development/playground/webmandman-try/"){

		var basedir = getDirectoryFromPath(getCurrentTemplatePath());
		var template = basedir & "templates/" & arguments.type & ".cfc";
		var newfile = folder & arguments.name & ".cfc";

		// make sure base folder still exists
		if( not directoryExists(folder) ){
			directoryCreate(folder);
		}

		// use template
		fileCopy( template, newfile );

		// open file in default $EDITOR
		command( '!' & getEnv('EDITOR') ).params( newfile ).run();
	}
}

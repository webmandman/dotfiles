component extends="commandbox.system.BaseCommand" {
	function run(
        editor='EDITOR'
e   ){
        var today = dateFormat(now(),"yymmdd");
		var basedir = getDirectoryFromPath(getCurrentTemplatePath());
		var template = basedir & "templates/todo.md";
		var newfile = "C:/Development/playground/webmandman-todo/" & today & ".md";

        if( editor == 'EDITOR' ){
            // open file in default $EDITOR
            command( '!' & getEnv('EDITOR') ).params( newfile ).run();
            return;
        }

		// use template
		fileCopy( template, newfile );

        command( '!' & editor ).params( newfile ).run();
	}
}

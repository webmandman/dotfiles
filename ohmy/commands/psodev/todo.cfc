component extends="commandbox.system.BaseCommand" {

	variables.basedir = getDirectoryFromPath( getCurrentTemplatePath() );
	variables.template = basedir & "templates/todo.md";
	variables.todoDir = "C:/Development/playground/webmandman-todo/"; 

	function run(
        string editor='EDITOR',
		boolean prev = false,
		numeric days = -1,
		boolean pickup = false,
		boolean view = false,
		string type = 'todo',
		boolean marked = false,
		boolean unmarked = true,
		boolean all = true
   ){

		if( prev ){
			filedate = dateFormat( now().add( 'd',days ),"yymmdd" );
		}

		if( view ){
			
			// unmarked ?
			// all ? if not all, then only retrieve this week

			//var items = getTodoItemsFromRange();

			command( 'ls' )
				.params( todoDir )
				.run();

			return;
		}

		var newfile = todoDir & getNowDate() & ".md";

		// create file if it does not exist
		if( not fileExists( newfile ) ){
			// use template
			fileCopy( template, newfile );
		}

		// Copy unmarked items from last todo list
		if( pickup ){
			var lastfile = getLast();
			var unmarked = command( 'cat ' )
				.params( todoDir & lastfile )
				.pipe(
					// get unmarked items
					command( 'grep' ).params( '\[\s\]' )
				)
				.run( returnOutput=true );

			// append date
			file 
				action="append" 
				file=newfile 
				output="#### " & lastfile;

			// append unmarked items
			file 
				action="append" 
				file=newfile 
				output=unmarked;

		}

		// Use env var $EDITOR
        if( editor == 'EDITOR' ){
            // open file in default $EDITOR
            command( '!' & getEnv( 'EDITOR' ) ).params( newfile ).run();
            return;
        }

		// Use user defined editor
        command( '!' & editor ).params( newfile ).run();
	}

	private string function getLast(){
		var lastfile = ''; 
		var list = directoryList(
			path=todoDir,
			listinfo="query",
			sort="desc");
		list.each(function(file){
			if( not find( getNowDate(), file.name ) ){
				lastfile = file.name;
				break;
			}
		});

		return lastfile;
	}

	private string function getNowDate(){
		return dateFormat( now(),"yymmdd" );
	}

	private string function getTodoItems( 
		required string filepath, 
		boolean marked = false ){

		var catOutputString = command( 'cat ' )
			.params( arguments.filepath )
			.pipe(function(){
					if( arguments.marked ){
						return command( 'grep' ).params( '\[x\]' );
					}else{
						return command( 'grep' ).params( '\[\s\]' );
					}
				}
			)
			.run( returnOutput=true );

		return catOutputString;
		
	}
}

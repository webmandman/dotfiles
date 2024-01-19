component {
	function run(){
		command( 'cat **.cf?' )
			.pipe(
				command( 'grep' ).params( 'datasource="' ))	
			.pipe(
				command( 'sed' ).params( 's/.*datasource="([^"]*)".*/\1/i' ))
			.pipe(
				command( 'unique' ))
			.run();
	}
} 

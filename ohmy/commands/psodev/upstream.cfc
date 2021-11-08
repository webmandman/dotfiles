component {
	function run(){
		var branchname = 
			command( 'git' )
				.params( 'rev-parse', '--abbrev-ref', 'HEAD' )
				.run( returnOutput=true );

		command( 'git' )
			.params( 'push', '--set-upstream', 'origin', '#branchname#' )
			.run();
	}
}

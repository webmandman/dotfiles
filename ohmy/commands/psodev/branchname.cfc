component {
	function run(){
		command( '!git rev-parse --abbrev-ref HEAD' )
			.run();

	}
}

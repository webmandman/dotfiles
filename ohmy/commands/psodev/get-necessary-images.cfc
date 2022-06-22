component {
	function run(){
		var images = command( 'cat **.cf?' )
			.pipe(
				command( 'grep' ).params( 'img.+src=".*images' ))	
			.pipe(
				command( 'sed' ).params( 's/.*src="([^"]*)".*/\1/i' ))
			.pipe(
				command( 'unique' ))
			.run( returnOutput=true );
		
		var basepath = 'C:/Development/sites/psomas-assets';
		var exclude = [
			'images/people/'
		]
		// loop images
			// move image to /images3
			var fqpath = fileSystemUtil.resolvePath( filepath );
	}
} 

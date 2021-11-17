component extends="commandbox.system.BaseCommand" {
	function run( editor='EDITOR' ){
		var trycfc = 'C:/Development/Tools/dotfiles/ohmy/commands/psodev/try.cfc';

		if( editor == 'EDITOR' ){
			// open file in default $EDITOR
			command( '!' & getEnv('EDITOR') ).params( trycfc ).run();
			return;
		}
		command( '!' & editor ).params( trycfc ).run();
	}
}

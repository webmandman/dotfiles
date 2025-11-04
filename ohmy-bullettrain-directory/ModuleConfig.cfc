component {    
  function configure() {}

  function onBulletTrain( interceptData ) {
    // This helper will create ANSI-formatted text colors
    var print = wirebox.getInstance( 'print' );
    // Set our formatted text into the cars struct
    interceptData.cars.myBulletTrainCar.text = print.whiteOnBlue( shell.getPWD() );
    // Tell the main module what our background color was so it can "finish" the car's arrow
    interceptData.cars.myBulletTrainCar.background = 'blue';        
  }    
}

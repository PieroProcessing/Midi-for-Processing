public class MidiSetup {

  public MidiDevice    input;
  public MidiDevice    output;
  int selectedIn, selectedOut;
  //MidiDevice.Info[] infos = MidiSystem.getMidiDeviceInfo();
  MyReceiver receiver;
  Receiver sysex;
  //Transmitter transmitter;

  public void start() {

    init();  // initialize your midi input device

    openOut();
  }
  public void openIn() {
    try {
      input.open();
      sysex =new MyReceiver();
      //device = MidiSystem.getMidiDevice(infos[inD]);
      //receiver = MidiSystem.getReceiver();
    }
    catch (Exception e) {
    }
  }
  public void openOut() {
    try {
      output.open(); // From midi device
      receiver = new MyReceiver();
      MidiSystem.getTransmitter().setReceiver(receiver);
    }
    catch (Exception e) {
      e.printStackTrace();
      System.exit(0);
    }
  }
  public void closeOut() {
    output.close();
  }
 public void closeIn() {
    input.close();
  }
  public void init() {
    // init your midi devices here
    MidiDevice.Info[] devices = MidiSystem.getMidiDeviceInfo();
    try { 
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    } 
    catch (Exception e) { 
      e.printStackTrace();
    } 
    String [] optionsDevice = new String [devices.length];

    for (int i=0; i<devices.length; i++) {
      optionsDevice[i]= devices[i].getName();
      //println(optionsDevice[i]);
    }
    String selectedValue = (String) JOptionPane.showInputDialog(
      null, //component parentComponent
      "Dart Input", //object message
      "DART EDITOR", //string title
      JOptionPane.QUESTION_MESSAGE, // int messagetype
      null, //icon icon
      optionsDevice, // object [] section values
      optionsDevice[0]); // object initial values
    for (int i=0; i<optionsDevice.length; i++) {
      if (optionsDevice[i]== selectedValue)
      { 
        selectedIn =i;
        //println(infos[inD]);
        break;
      }
    }
    try {
      output = MidiSystem.getMidiDevice(devices[selectedIn]);
      if (! output.isOpen()) {
        output.open();
      }
    } 
    catch (Exception e ) {
    }
    String outputOpt = (String) JOptionPane.showInputDialog(
      null, 
      "Dart Out", 
      "DART EDITOR", 
      JOptionPane.QUESTION_MESSAGE, 
      null, 
      optionsDevice, 
      optionsDevice[0]);
    for (int i=0; i<optionsDevice.length; i++) {
      if (optionsDevice[i].equals(outputOpt))
      { 
        selectedOut =i;
        //println(DartOUT);
        break;
      }
    }
    try {
      input = MidiSystem.getMidiDevice(devices[selectedIn]);
      if (! input.isOpen()) {
        input.open();
      }
    }    
    catch (Exception e ) {
    }
  }

  private class MyReceiver implements Receiver {
    Receiver rcvr;
    public MyReceiver() {
      try {
        this.rcvr = MidiSystem.getReceiver();
      } 
      catch (MidiUnavailableException mue) {
        mue.printStackTrace();
      }
    }
    @Override
      public void send(MidiMessage message, long timeStamp) {
      byte[] midi = message.getMessage();
      //  if (midi[0] != (byte)254) {
      int m0 = midi[0] & 0xFF;
      int m1 = midi[1] & 0xFF;
      int m2=0;
      println(m0);
      println(m1);
      if (m0 == 192 || m0 == 208) {
      } else {
        m2 = midi[2] & 0xFF;
        System.out.println(m2);
      }
      rcvr.send(message, timeStamp);
    }
    @Override
      public void close() {
      rcvr.close();
    }
  }
}
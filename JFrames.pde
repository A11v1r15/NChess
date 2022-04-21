import javax.swing.*;
import java.awt.event.*;
import javax.swing.filechooser.*;
import java.awt.FlowLayout;
import java.awt.GridLayout;

public class StartPopUp implements ActionListener {

  final JFrame parent = new JFrame("NChess");
  JButton loadGame = new JButton();
  JButton newGame = new JButton();
  JPanel panel = new JPanel();
  PApplet chain;

  public StartPopUp(PApplet app) {
    chain = app;
    loadGame.setText("Load Game");
    loadGame.addActionListener(this);
    newGame.setText("New Game");
    newGame.addActionListener(this);
    panel.setLayout(new FlowLayout());
    panel.add(newGame);
    panel.add(loadGame);
    parent.add(panel);
    parent.pack();
    parent.setSize((int)(parent.getWidth() * 1.3), (int)(parent.getHeight()*1.1));
    parent.setLocation((displayWidth - parent.getWidth())/2, (displayHeight - parent.getHeight())/2);
    parent.setVisible(true);

    parent.addWindowListener(new java.awt.event.WindowAdapter() {
      @Override
        public void windowClosing(java.awt.event.WindowEvent windowEvent) {
        exit();
      }
    }
    );
  }

  public void actionPerformed(ActionEvent e) {
    Object source = e.getSource();
    if (source == loadGame) {
      JFileChooser chooser = new JFileChooser();
      FileNameExtensionFilter filter = new FileNameExtensionFilter("Nchess save file", "ncs");
      chooser.setFileFilter(filter);
      int returnVal = chooser.showOpenDialog(parent);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        parent.setVisible(false);
        args = new String[1];
        args[0] = chooser.getSelectedFile().getPath();
        buildBoard();
        notStarted = false;
      }
      println("Selected new file");
    } else if (source == newGame) {
      parent.setVisible(false);
      NewGamePopUp popup = new NewGamePopUp(chain);
    }
  }
}

public class NewGamePopUp implements ActionListener {
  PApplet chain;
  final JFrame parent = new JFrame("NChess - New Game");
  JLabel  playersPanel = new JLabel ();
  JTextField players = new JTextField("3");
  JLabel  emptyPanel = new JLabel ();
  JButton startGame = new JButton();
  JPanel panel = new JPanel();

  public NewGamePopUp(PApplet app) {
    chain = app;
    startGame.setText("Start Game");
    startGame.addActionListener(this);
    playersPanel.setText("Players:");
    panel.setLayout(new GridLayout(4, 1));
    panel.add(playersPanel);
    panel.add(players);
    panel.add(emptyPanel);
    panel.add(startGame);
    parent.add(panel);
    parent.pack();
    parent.setSize((int)(parent.getWidth() * 1.3), (int)(parent.getHeight()*1.1));
    parent.setLocation((displayWidth - parent.getWidth())/2, (displayHeight - parent.getHeight())/2);
    parent.setVisible(true);

    parent.addWindowListener(new java.awt.event.WindowAdapter() {
      @Override
        public void windowClosing(java.awt.event.WindowEvent windowEvent) {
        StartPopUp popup = new StartPopUp(chain);
      }
    }
    );
  }

  public void actionPerformed(ActionEvent e) {
    Object source = e.getSource();
    if (source == startGame) {
      n = max(2, parseInt(players.getText()));
      parent.setVisible(false);
      buildBoard();
      notStarted = false;
    }
  }
}

public class Menu_bar extends JFrame implements ActionListener {
  JFrame frame;
  JMenuItem new_file;

  JPanel panel;

  public Menu_bar(PApplet app, String name) {
    frame = (JFrame) ((processing.awt.PSurfaceAWT.SmoothCanvas)app.getSurface().getNative()).getFrame();

    frame.setTitle(name);

    panel =  new JPanel(); 
    panel.setOpaque(false);

    // ADDING PANEL WITH BUTTON

    JButton exit = new JButton("Exit");
    exit.setBounds(300, 300, 300, 300);  
    exit.addActionListener(this);
    panel.add(exit);

    // Creates a menubar for a JFrame
    JMenuBar menu_bar = new JMenuBar();
    // Add the menubar to the frame
    frame.setJMenuBar(menu_bar);
    // Define and add two drop down menu to the menubar
    JMenu import_menu = new JMenu("import");
    JMenu text_menu = new JMenu("text");
    JMenu shape_menu = new JMenu("shape");
    JMenu image_menu = new JMenu("image");
    JMenu video_menu = new JMenu("video");

    JMenu submenu = new JMenu("Submenu");

    JMenuItem test = new JMenuItem("Testando");

    menu_bar.add(import_menu);
    menu_bar.add(text_menu);
    menu_bar.add(shape_menu);
    menu_bar.add(image_menu);
    menu_bar.add(video_menu);

    test.addActionListener(this);
    submenu.add(test);

    import_menu.add(submenu);

    // Create and add simple menu item to one of the drop down menu
    new_file = new JMenuItem("Import file");
    JMenuItem new_folder = new JMenuItem("Import folder");
    JMenuItem action_exit = new JMenuItem("Exit");

    new_file.addActionListener(this);
    new_folder.addActionListener(this);
    action_exit.addActionListener(this);

    import_menu.add(new_file);
    import_menu.add(new_folder);

    import_menu.addSeparator();

    import_menu.add(action_exit);
    frame.setVisible(true);
  }

  public void actionPerformed(ActionEvent e) {
    String str = e.getActionCommand(); 

    Object source = e.getSource();
    if (source == new_file) {
      JFileChooser chooser = new JFileChooser();
      FileNameExtensionFilter filter = new FileNameExtensionFilter("Nchess save file", "ncs");
      chooser.setFileFilter(filter);
      int returnVal = chooser.showOpenDialog(this);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        args = new String[1];
        args[0] = chooser.getSelectedFile().getPath();
        setup();
      }
      println("Selected new file");
    }
  }
}

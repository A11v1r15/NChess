import javax.swing.*;
import java.awt.event.*;
import javax.swing.filechooser.*;
import java.awt.FlowLayout;
import java.awt.GridLayout;

public class StartPopUp implements ActionListener {

  final JFrame parent = new JFrame("NChess");
  JButton loadGame = new JButton();
  JButton newGame = new JButton();
  JButton loadNet = new JButton();
  JPanel panel = new JPanel();
  PApplet chain;

  public StartPopUp(PApplet app) {
    chain = app;
    loadGame.setText("Load Game");
    loadGame.addActionListener(this);
    newGame.setText("New Game");
    newGame.addActionListener(this);
    loadNet.setText("Load From Net");
    loadNet.addActionListener(this);
    panel.setLayout(new FlowLayout());
    panel.add(newGame);
    panel.add(loadGame);
    panel.add(loadNet);
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
    } else if (source == loadNet) {
      parent.setVisible(false);
      getFromNet("L2B3JA8D");
      notStarted = false;
    }
  }
}

public class NewGamePopUp implements ActionListener {
  PApplet chain;
  final JFrame parent = new JFrame("NChess - New Game");
  JLabel  playersPanel = new JLabel ();
  JTextField players = new JTextField(n+"");
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
  PApplet chain;
  JFrame frame;
  JMenu import_menu = new JMenu("File");
  JMenuItem new_file = new JMenuItem("New Game");
  JMenuItem old_file = new JMenuItem("Load Game");
  JMenuItem action_exit = new JMenuItem("Exit");
  
  JMenu options_menu = new JMenu("Options");
  JMenuItem animated = new JMenuItem((playerRotate?"☑":"☐")+" Rotate");
  JMenuItem drawCoords = new JMenuItem((showCoords?"☑":"☐")+" Show Coords");

  JPanel panel;

  public Menu_bar(PApplet app) {
    chain = app;
    frame = (JFrame) ((processing.awt.PSurfaceAWT.SmoothCanvas)app.getSurface().getNative()).getFrame();
    panel =  new JPanel(); 
    panel.setOpaque(false);

    // Creates a menubar for a JFrame
    JMenuBar menu_bar = new JMenuBar();
    frame.setJMenuBar(menu_bar);

    menu_bar.add(import_menu);
    new_file.addActionListener(this);
    import_menu.add(new_file);
    old_file.addActionListener(this);
    import_menu.add(old_file);
    import_menu.addSeparator();
    action_exit.addActionListener(this);
    import_menu.add(action_exit);
    
    menu_bar.add(options_menu);
    animated.addActionListener(this);
    options_menu.add(animated);
    drawCoords.addActionListener(this);
    options_menu.add(drawCoords);
    frame.setVisible(true);
  }

  public void actionPerformed(ActionEvent e) {
    String str = e.getActionCommand(); 

    Object source = e.getSource();
    if (source == new_file) {
      notStarted = true;
      NewGamePopUp popup = new NewGamePopUp(chain);
    } else if (source == old_file) {
      notStarted = true;
      JFileChooser chooser = new JFileChooser();
      FileNameExtensionFilter filter = new FileNameExtensionFilter("Nchess save file", "ncs");
      chooser.setFileFilter(filter);
      int returnVal = chooser.showOpenDialog(this);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        args = new String[1];
        args[0] = chooser.getSelectedFile().getPath();
        buildBoard();
        notStarted = false;
      }
    } else if (source == action_exit) {
      exit();
    } else if (source == animated) {
      playerRotate = !playerRotate;
      animated.setText((playerRotate?"☑":"☐")+" Rotate");
    } else if (source == drawCoords) {
       showCoords = !showCoords;
      drawCoords.setText((showCoords?"☑":"☐")+" Show Coords");
    }
  }
}

Menu_bar mp;
void buildMenuBar() {
  mp = new Menu_bar(this);
}
